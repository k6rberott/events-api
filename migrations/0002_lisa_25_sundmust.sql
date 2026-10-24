-- Migration number: 0002 	 2026-10-24T11:13:25.071Z
CREATE TABLE IF NOT EXISTS events (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  title       TEXT    NOT NULL,
  description TEXT    NOT NULL DEFAULT '',
  starts_at   TEXT    NOT NULL,
  location    TEXT    NOT NULL DEFAULT '',
  host        TEXT    NOT NULL DEFAULT '',
  tags        TEXT    NOT NULL DEFAULT '[]',
  url         TEXT,
  image_url   TEXT
);

INSERT INTO events (title, description, starts_at, location, host, tags, url, image_url) VALUES
  (
    'Maastikujooksuvõistlus',
    'Rahvuslik maastikujooksuvõistlus ja Eesti Meistrivõistlused.',
    '2026-09-19T09:00',
    'Harjumaa, Ardu',
    'Eesti Hurtade Liit',
    '["koerasport", "võistlus", "hurtadeliit"]',
    'https://www.hurtadeliit.ee/',
    '/images/event-01-maastikujooks.webp'
  ),
  ( 
    'Näitus',
    'FCI I, II & IX rühma näitus, sh pürenee mäestikukoerte erinäitus.',
    '2026-09-19T10:00',
    'Harjumaa',
    'Eesti Prantsuse Lamba- ja Karjakaitsekoerte TÜ',
    '["koerasport", "näitus", "erinäitus"]',
    'https://www.eplk.ee/post/fci-i-ii-ix-r%C3%BChma-n%C3%A4itus-sh-p%C3%BCrenee-m%C3%A4estikukoerte-erin%C3%A4itus-19-09-2026',
    '/images/event-02-naitus.webp'
  ),
  (
    'Jahiomaduste kindlakstegemine',
    'Jahiomaduste kindlakstegemine 500–600 meetri pikkusel kunstlikul verejäljel (VJ) CACT',
    '2026-09-20T11:00',
    'Mulgi vald',
    'Eesti Beaglete Tõuühing',
    '["koerasport", "jahikatsed", "beagle"]',
    'https://eestibeagle.ee/%f0%9d%90%82%f0%9d%90%80%f0%9d%90%82%f0%9d%90%93-3-%f0%9d%90%81%f0%9d%90%9e%f0%9d%90%9a%f0%9d%90%a0%f0%9d%90%a5%f0%9d%90%9e%f0%9d%90%ad%f0%9d%90%9e-%f0%9d%90%9e%f0%9d%90%ab%f0%9d%90%a2-%f0%9d%90%89/',
    '/images/event-03-jahiomaduste-katse.webp'
  ),
  (
    'EKL üldkoosolek',
    'Arutame asju.',
    '2026-10-31T18:00',
    'Narva mnt 29, Tallinn',
    'Eesti Kennelliit',
    '["koerasport", "üldkoosolek"]',
    'https://kennelliit.ee/',
    '/images/event-04-ekl-uldkoosolek.webp'
  ),
  (
    'Rahvuslik kõikide tõugude koertenäitus Tartus',
    'Rahvusliku koertenäitus(1 x CAC) ja rahvusvahelised koertenäitused (2 X CACIB)',
    '2026-11-06T12:00',
    'Tartu Näitused, Friedrich Reinhold Kreutzwaldi 60, Tartu',
    'Lõuna Eesti Koertekeskus',
    '["koerasport", "näitus", "sisenäitus"]',
    'https://www.lekk.ee/tartutripleshows2026',
    '/images/event-05-tartu-koertenaitus.webp'
  ),
  (
    'Kasvatajakoolitus: koera käitumine',
    'MTÜ Happy Dog koostöös Eesti Kennelliiduga korraldab 2026. aasta sügisel EKL poolt tunnustatud eestikeelse kasvatajakoolituse.',
    '2026-11-14T10:00',
    'Pilve tn 16, Märja alevik, Tartumaa',
    'MTÜ Happy Dog',
    '["koerasport", "koolitus", "käitumine"]',
    'https://happydog.ee/kasvatajakoolitus.html',
    '/images/event-06-kasvatajakoolitus.webp'
  ),
  (
    'Koeruse agilityvõistlus Männikul',
    'Agilityvõistlus 24.–25. oktoobril 2026. Kohtunik Emilia Tziliou.',
    '2026-10-24T10:00',
    'Männiku',
    'Koeraspordiklubi Koerus',
    '["koerasport", "agility", "võistlus"]',
    'https://agilitykoer.ee/?controller=competitions',
    '/images/event-07-koerus-agility.webp'
),
(
    'Vauh Karikas – agilityvõistluse II etapp',
    'Mitteametlik agilityvõistlus Tallinnas.',
    '2026-10-31T10:00',
    'Tallinn',
    'Vauh MTÜ',
    '["koerasport", "agility", "võistlus"]',
    'https://agilitykoer.ee/?controller=competitions',
    NULL
),
(
    'Koerteklubi Aktiiv agilityvõistlus',
    'Mitteametlik agilityvõistlus.',
    '2026-11-01T12:00',
    'Eesti',
    'Koerteklubi Aktiiv',
    '["koerasport", "agility", "võistlus"]',
    'https://agilitykoer.ee/?controller=competitions',
    '/images/event-09-aktiiv-agility.webp'
),
(
    'TAKO A0 ja OPEN agilityvõistlus',
    'Tarkade Koerte Klubi mitteametlik agilityvõistlus algajatele ja OPEN klassile.',
    '2026-11-01T12:00',
    'Eesti',
    'Tarkade Koerte Klubi (TAKO)',
    '["koerasport", "agility", "võistlus"]',
    'https://agilitykoer.ee/?controller=competitions',
    '/images/event-10-tako-open-agility.webp'
),
(
    'Säde agilityvõistlus Vastse-Kuustes',
    'Agilityvõistlus 7.–8. novembril 2026. Kohtunik Jenny Naumanen.',
    '2026-11-07T10:00',
    'Vastse-Kuuste',
    'Koerteklubi Säde',
    '["koerasport", "agility", "võistlus"]',
    'https://agilitykoer.ee/?controller=competitions',
    '/images/event-11-sade-agility.webp'
),
(
    'TAKO agilityvõistlus',
    'Agilityvõistlus 14.–15. novembril 2026. Kohtunik Sari Mikkilä.',
    '2026-11-14T10:00',
    'Eesti',
    'Tarkade Koerte Klubi (TAKO)',
    '["koerasport", "agility", "võistlus"]',
    'https://agilitykoer.ee/?controller=competitions',
    '/images/event-12-tako-agility.webp'
),
(
    'Agility Arenguseltsi võistlused Vastse-Kuustes',
    'Agilityvõistlused 21.–22. novembril 2026. Kohtunik Marko Visse.',
    '2026-11-21T10:00',
    'Vastse-Kuuste',
    'Agility Arenguselts MTÜ',
    '["koerasport", "agility", "võistlus"]',
    'https://agilitykoer.ee/?controller=competitions',
    NULL
),
(
    'BH eksam',
    'Koera käitumise ja kuulekuse eksam.',
    '2026-10-24T09:00',
    'Eesti',
    'Tartu Koerte Klubi AMUR',
    '["koerasport", "eksam", "BH"]',
    'https://www.sportkoer.com/prox/trialcalendar/',
    '/images/event-14-bh-eksam.webp'
),
(
    'IGP eksam',
    'IGP eksam koertele.',
    '2026-10-24T11:00',
    'Eesti',
    'Tartu Koerte Klubi AMUR',
    '["koerasport", "eksam", "IGP"]',
    'https://www.sportkoer.com/prox/trialcalendar/',
    NULL
),
(
    'KK eksam',
    'Kuulekuskoolituse eksam.',
    '2026-10-24T10:00',
    'Eesti',
    'Harjumaa Koerte Treeningkeskus',
    '["koerasport", "eksam", "kuulekus"]',
    'https://www.sportkoer.com/prox/trialcalendar/',
    NULL
),
(
    'Rallikuulekuse võistlus',
    'Ametlik rallikuulekuse võistlus.',
    '2026-11-07T12:00',
    'Eesti',
    'MTÜ Vauh',
    '["koerasport", "rallikuulekus", "võistlus"]',
    'https://www.sportkoer.com/prox/trialcalendar/',
    NULL
),
(
    'Kuulekuskoolituse võistlus',
    'KK võistlus.',
    '2026-11-14T10:00',
    'Eesti',
    'Koerteklubi Articus',
    '["koerasport", "kuulekus", "võistlus"]',
    'https://www.sportkoer.com/prox/trialcalendar/',
    NULL
),
(
    'Rallikuulekuse võistlus retriiveritele',
    'Ametlik rallikuulekuse võistlus.',
    '2026-11-14T14:00',
    'Eesti',
    'Eesti Retriiverite Tõuühing',
    '["koerasport", "rallikuulekus", "retriiverid"]',
    'https://www.sportkoer.com/prox/trialcalendar/',
    '/images/event-19-rallikuulekus-retriiveritele.webp'
),
(
    'SK võistlus',
    'Sõnakuulelikkuse võistlus.',
    '2026-11-28T12:00',
    'Eesti',
    'Tarkade Koerte Klubi (TAKO)',
    '["koerasport", "sõnakuulelikkus", "võistlus"]',
    'https://www.sportkoer.com/prox/trialcalendar/',
    NULL
),
(
    'Rallikuulekuse võistlus',
    'Rallikuulekuse võistlus.',
    '2026-11-29T12:00',
    'Eesti',
    'Tarkade Koerte Klubi (TAKO)',
    '["koerasport", "rallikuulekus", "võistlus"]',
    'https://www.sportkoer.com/prox/trialcalendar/',
    NULL
),
(
    'Rallikuulekuse võistlus Tartus',
    'Rallikuulekuse võistlus.',
    '2026-12-13T10:00',
    'Tartu',
    'Tartu Trennid',
    '["koerasport", "rallikuulekus", "võistlus"]',
    'https://www.sportkoer.com/prox/trialcalendar/',
    NULL
),
(
    'Tartu rahvuslik ja rahvusvaheline koertenäitus – 1. päev',
    'Rahvuslik koertenäitus (1 x CAC) ja rahvusvaheliste näituste sari.',
    '2026-11-06T12:00',
    'Tartu Näitused, Friedrich Reinhold Kreutzwaldi 60, Tartu',
    'Lõuna-Eesti Koertekeskus',
    '["koerasport", "koertenäitus", "CAC", "CACIB"]',
    'https://www.lekk.ee/tartutripleshows2026',
    '/images/event-23-tartu-koeranaitus-paev-1.webp'
),
(
    'Tartu rahvuslik ja rahvusvaheline koertenäitus – 2. päev',
    'Rahvuslik koertenäitus (1 x CAC) ja rahvusvaheliste näituste sari.',
    '2026-11-07T10:00',
    'Tartu Näitused, Friedrich Reinhold Kreutzwaldi 60, Tartu',
    'Lõuna-Eesti Koertekeskus',
    '["koerasport", "koertenäitus", "CAC", "CACIB"]',
    'https://www.lekk.ee/tartutripleshows2026',
    NULL
),
(
    'Tartu rahvuslik ja rahvusvaheline koertenäitus – 3. päev',
    'Rahvuslik koertenäitus (1 x CAC) ja rahvusvaheliste näituste sari.',
    '2026-11-08T09:00',
    'Tartu Näitused, Friedrich Reinhold Kreutzwaldi 60, Tartu',
    'Lõuna-Eesti Koertekeskus',
    '["koerasport", "koertenäitus", "CAC", "CACIB"]',
    'https://www.lekk.ee/tartutripleshows2026',
    NULL
);