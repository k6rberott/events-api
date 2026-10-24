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

-- ASENDA NEED READ OMA SÜNDMUSTEGA.
-- Pildi tee vastab failile kaustas public/images/.
INSERT INTO events (title, description, starts_at, location, tags, url, image_url) VALUES
  (
    'Maastikujooksuvõistlus',
    'Rahvuslik maastikujooksuvõistlus ja Eesti Meistrivõistlused.',
    '2026-09-19T09:00',
    'Harjumaa, Ardu',
    'Eesti Hurtade Liit',
    '["koerasport", "võistlus", "hurtadeliit"]',
    'https://www.hurtadeliit.ee/',
    NULL
  );
