type Env = {
    DB: D1Database;
    // Valikuline: eelrenderdatud saidi Deploy Hook. Kui see on seatud, käivitab
    // iga õnnestunud muudatus saidi uue buildi, et avalik kava uueneks.
    DEPLOY_HOOK_URL?: string;
    // Valikuline: halduse parool. Kui see on seatud, vajavad POST, PUT ja DELETE
    // sisselogimisel saadud tokenit. Lugemine (GET) jääb avalikuks.
    ADMIN_PASSWORD?: string;
};

type EventItem = {
    id: number;
    title: string;
    description: string;
    startsAt: string;
    location: string;
    host: string;
    tags: string[];
    url?: string;
    imageUrl?: string;
};

type EventRow = {
    id: number;
    title: string;
    description: string;
    starts_at: string;
    location: string;
    host: string;
    tags: string;
    url: string | null;
    image_url: string | null;
};

const CORS = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

const json = (data: unknown, status = 200): Response => {
    return Response.json(data, { status, headers: CORS });
};

const error = (message: string, status: number): Response => {
    return json({ error: message }, status);
};

// --- Sisselogimine ---
// Token on kujul "aegumisaeg.allkiri". Allkiri on HMAC, mille võti on parool:
// tokenit ei saa võltsida ilma paroolita ja parooli vahetus tühistab vanad tokenid.
// Serveris ei hoita midagi meeles, seega ei ole vaja andmebaasitabelit.
const TOKEN_LIFETIME_MS = 8 * 60 * 60 * 1000;
const encoder = new TextEncoder();

const importKey = (secret: string) =>
    crypto.subtle.importKey("raw", encoder.encode(secret), { name: "HMAC", hash: "SHA-256" }, false, [
        "sign",
        "verify",
    ]);

const toBase64 = (bytes: ArrayBuffer) => btoa(String.fromCharCode(...new Uint8Array(bytes)));
const fromBase64 = (text: string) => Uint8Array.from(atob(text), (char) => char.charCodeAt(0));

const createToken = async (secret: string): Promise<string> => {
    const expires = String(Date.now() + TOKEN_LIFETIME_MS);
    const signature = await crypto.subtle.sign("HMAC", await importKey(secret), encoder.encode(expires));
    return `${expires}.${toBase64(signature)}`;
};

const isValidToken = async (secret: string, header: string | null): Promise<boolean> => {
    const [expires, signature] = (header?.replace(/^Bearer /, "") ?? "").split(".");
    if (!expires || !signature || Number(expires) < Date.now()) return false;
    try {
        // verify võrdleb allkirju konstantse ajaga.
        return await crypto.subtle.verify("HMAC", await importKey(secret), fromBase64(signature), encoder.encode(expires));
    } catch {
        return false; // vigane base64
    }
};

// Tavaline === lõpetab esimese erineva märgi juures ja reedab ajastusega, kui palju klappis.
const isSamePassword = (given: string, expected: string): boolean => {
    const a = encoder.encode(given);
    const b = encoder.encode(expected);
    return a.byteLength === b.byteLength && crypto.subtle.timingSafeEqual(a, b);
};

const toImageUrl = (stored: string | null, origin: string): string | undefined => {
    if (!stored) return undefined;
    return stored.startsWith("/") ? `${origin}${stored}` : stored;
};

const toEvent = (row: EventRow, origin: string): EventItem => {
    return {
        id: row.id,
        title: row.title,
        description: row.description,
        startsAt: row.starts_at,
        location: row.location,
        host: row.host,
        tags: JSON.parse(row.tags) as string[],
        url: row.url ?? undefined,
        imageUrl: toImageUrl(row.image_url, origin),
    };
};

type EventWithoutId = Omit<EventItem, "id">;
type ValidationResult =
    | { ok: true; value: EventWithoutId }
    | { ok: false; errors: Record<string, string> };

const validate = (body: unknown): ValidationResult => {
    const errors: Record<string, string> = {};
    const value = body as Record<string, unknown>;

    if (typeof value?.title !== "string" || value.title.trim() === "") {
        errors.title = "Pealkiri on kohustuslik";
    }
    if (
        typeof value?.startsAt !== "string" ||
        Number.isNaN(Date.parse(value.startsAt))
    ) {
        errors.startsAt = "Algusaeg peab olema kehtiv kuupäev";
    }
    if (value?.tags !== undefined && !Array.isArray(value.tags)) {
        errors.tags = "Sildid peavad olema massiiv";
    }
    if (
        typeof value?.imageUrl === "string" &&
        value.imageUrl.trim() !== "" &&
        !/^(https?:\/\/|\/)/.test(value.imageUrl.trim())
    ) {
        errors.imageUrl = "Pildi aadress peab algama http(s):// või /";
    }

    if (Object.keys(errors).length > 0) {
        return { ok: false, errors };
    }

    return {
        ok: true,
        value: {
            title: (value.title as string).trim(),
            description:
                typeof value.description === "string" ? value.description.trim() : "",
            startsAt: value.startsAt as string,
            location: typeof value.location === "string" ? value.location.trim() : "",
            host: typeof value.host === "string" ? value.host.trim() : "",
            tags: Array.isArray(value.tags) ? value.tags.map(String) : [],
            url:
                typeof value.url === "string" && value.url.trim() !== ""
                    ? value.url.trim()
                    : undefined,
            imageUrl:
                typeof value.imageUrl === "string" && value.imageUrl.trim() !== ""
                    ? value.imageUrl.trim()
                    : undefined,
        },
    };
};

// Uus build käib taustal: vastus ei oota buildi ära ja buildi viga ei muuda vastust.
const triggerRebuild = (env: Env, ctx: ExecutionContext): void => {
    if (!env.DEPLOY_HOOK_URL) return;
    ctx.waitUntil(
        fetch(env.DEPLOY_HOOK_URL, { method: "POST" })
            .then((response) => {
                if (!response.ok) console.error(`Deploy Hook vastas veaga ${response.status}`);
            })
            .catch((caught) => console.error("Deploy Hooki ei saanud kätte", caught)),
    );
};

export default {
    async fetch(request: Request, env: Env, ctx: ExecutionContext): Promise<Response> {
        if (request.method === "OPTIONS") {
            return new Response(null, { status: 204, headers: CORS });
        }

        const url = new URL(request.url);
        const parts = url.pathname.split("/").filter(Boolean);
        const id = parts[2] ? Number(parts[2]) : null;

        // --- POST /api/login ---
        if (request.method === "POST" && url.pathname === "/api/login") {
            if (!env.ADMIN_PASSWORD) return error("Sisselogimine ei ole seadistatud", 404);
            const body = (await request.json().catch(() => null)) as { password?: unknown } | null;
            if (typeof body?.password !== "string" || !isSamePassword(body.password, env.ADMIN_PASSWORD)) {
                return error("Vale parool", 401);
            }
            return json({ token: await createToken(env.ADMIN_PASSWORD) });
        }

        if (parts[0] !== "api" || parts[1] !== "events") {
            return error("Tundmatu lõpp-punkt", 404);
        }
        if (parts[2] !== undefined && !Number.isInteger(id)) {
            return error("Vigane id", 400);
        }

        // Kirjutavad päringud vajavad tokenit. Haldusvaate peitmine üksi ei kaitseks
        // midagi: API-le saab päringu saata ka curl-iga, haldusvaadet avamata.
        const isWrite = request.method !== "GET";
        if (isWrite && env.ADMIN_PASSWORD && !(await isValidToken(env.ADMIN_PASSWORD, request.headers.get("Authorization")))) {
            return error("Logi sisse", 401);
        }

        try {
            if (request.method === "GET" && id === null) {
                const { results } = await env.DB.prepare(
                    "SELECT * FROM events ORDER BY starts_at ASC",
                ).all<EventRow>();
                return json(results.map((row) => toEvent(row, url.origin)));
            }

            if (request.method === "GET" && id !== null) {
                const row = await env.DB.prepare("SELECT * FROM events WHERE id = ?")
                    .bind(id)
                    .first<EventRow>();
                return row
                    ? json(toEvent(row, url.origin))
                    : error("Sündmust ei leitud", 404);
            }

            if (request.method === "POST" && id === null) {
                const parsed = validate(await request.json());
                if (!parsed.ok) return json({ errors: parsed.errors }, 422);

                const event = parsed.value;
                const row = await env.DB.prepare(
                    `INSERT INTO events (title, description, starts_at, location, host, tags, url, image_url)
                      VALUES (?, ?, ?, ?, ?, ?, ?, ?) RETURNING *`,
                )
                    .bind(
                        event.title,
                        event.description,
                        event.startsAt,
                        event.location,
                        event.host,
                        JSON.stringify(event.tags),
                        event.url ?? null,
                        event.imageUrl ?? null,
                    )
                    .first<EventRow>();
                triggerRebuild(env, ctx);
                return json(toEvent(row!, url.origin), 201);
            }

            if (request.method === "PUT" && id !== null) {
                const parsed = validate(await request.json());
                if (!parsed.ok) return json({ errors: parsed.errors }, 422);

                const event = parsed.value;
                const row = await env.DB.prepare(
                    `UPDATE events
                            SET title = ?, description = ?, starts_at = ?, location = ?, host = ?,
                                    tags = ?, url = ?, image_url = ?
                        WHERE id = ?
                RETURNING *`,
                )
                    .bind(
                        event.title,
                        event.description,
                        event.startsAt,
                        event.location,
                        event.host,
                        JSON.stringify(event.tags),
                        event.url ?? null,
                        event.imageUrl ?? null,
                        id,
                    )
                    .first<EventRow>();
                if (!row) return error("Sündmust ei leitud", 404);
                triggerRebuild(env, ctx);
                return json(toEvent(row, url.origin));
            }

            if (request.method === "DELETE" && id !== null) {
                const result = await env.DB.prepare("DELETE FROM events WHERE id = ?")
                    .bind(id)
                    .run();
                if (result.meta.changes === 0) return error("Sündmust ei leitud", 404);
                triggerRebuild(env, ctx);
                return new Response(null, { status: 204, headers: CORS });
            }

            return error("Meetod ei ole lubatud", 405);
        } catch (caught) {
            console.error(caught);
            return error("Serveris tekkis viga", 500);
        }
    },
} satisfies ExportedHandler<Env>;
