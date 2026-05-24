-- SOON Fragrance Survey — Supabase Setup (v2)
-- Für eine neue Datenbank: gesamten Block ausführen.
-- Für Migration einer bestehenden DB: nur den ALTER TABLE Block unten ausführen.

-- ── Neue Tabelle (Fresh Install) ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS survey_responses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  block INTEGER,

  -- Block 1: Über dich
  gender TEXT,
  age TEXT,                    -- Freifeld (neu, ersetzt age_range)
  fragrance_count TEXT,        -- neu: Anzahl Düfte in Besitz
  age_range TEXT,              -- Legacy (alte Daten)

  -- Blöcke 2–5: Duft A–D (Reihenfolge randomisiert, Daten immer nach Buchstabe)
  a_adj TEXT[], a_occasion TEXT[], a_season TEXT[], a_gender_perception TEXT, a_intensity INTEGER, a_feedback TEXT,
  b_adj TEXT[], b_occasion TEXT[], b_season TEXT[], b_gender_perception TEXT, b_intensity INTEGER, b_feedback TEXT,
  c_adj TEXT[], c_occasion TEXT[], c_season TEXT[], c_gender_perception TEXT, c_intensity INTEGER, c_feedback TEXT,
  d_adj TEXT[], d_occasion TEXT[], d_season TEXT[], d_gender_perception TEXT, d_intensity INTEGER, d_feedback TEXT,

  -- Preise (jetzt pro Duft direkt)
  price_a NUMERIC, price_b NUMERIC, price_c NUMERIC, price_d NUMERIC,

  -- Block 6: Ranking 1–4 (rank_1 = Favorit, rank_4 = letzter Platz)
  rank_1 TEXT, rank_2 TEXT, rank_3 TEXT, rank_4 TEXT,
  rank_keep TEXT,              -- Legacy
  rank_recommend TEXT,         -- Legacy

  -- Block 7: Naming
  naming_winner TEXT,
  naming_feedback TEXT,

  -- Block 8: Sport
  sport_makes TEXT,            -- Ja / Nein
  sport_type TEXT,             -- Welcher Sport (Freifeld)
  sport_wear TEXT,             -- Trägt Duft beim Sport: Ja / Manchmal / Nein

  -- Meta
  scent_order TEXT[],          -- Randomisierte Reihenfolge, z.B. ['C','A','D','B']
  final_feedback TEXT,         -- Legacy
  completed BOOLEAN DEFAULT FALSE,
  phase TEXT DEFAULT 'dev',    -- 'dev' | 'pilot' | 'broad'
  email TEXT                   -- Optional: 20%-Rabattcode bei Launch
);

-- ── Row Level Security ────────────────────────────────────────────────────────
ALTER TABLE survey_responses ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can insert" ON survey_responses
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can update own session" ON survey_responses
  FOR UPDATE USING (true);

CREATE POLICY "Anyone can read" ON survey_responses
  FOR SELECT USING (true);


-- ── Migration (bestehende DB) — in Supabase SQL-Editor ausführen ─────────────
-- Schritt 1: Fehlende Spalten hinzufügen (falls noch nicht vorhanden)
-- ALTER TABLE survey_responses
--   ADD COLUMN IF NOT EXISTS age TEXT,
--   ADD COLUMN IF NOT EXISTS fragrance_count TEXT,
--   ADD COLUMN IF NOT EXISTS a_feedback TEXT,
--   ADD COLUMN IF NOT EXISTS b_feedback TEXT,
--   ADD COLUMN IF NOT EXISTS c_feedback TEXT,
--   ADD COLUMN IF NOT EXISTS d_feedback TEXT,
--   ADD COLUMN IF NOT EXISTS rank_1 TEXT,
--   ADD COLUMN IF NOT EXISTS rank_2 TEXT,
--   ADD COLUMN IF NOT EXISTS rank_3 TEXT,
--   ADD COLUMN IF NOT EXISTS rank_4 TEXT,
--   ADD COLUMN IF NOT EXISTS sport_makes TEXT,
--   ADD COLUMN IF NOT EXISTS sport_type TEXT,
--   ADD COLUMN IF NOT EXISTS sport_wear TEXT,
--   ADD COLUMN IF NOT EXISTS scent_order TEXT[],
--   ADD COLUMN IF NOT EXISTS phase TEXT DEFAULT 'dev',
--   ADD COLUMN IF NOT EXISTS email TEXT;

-- Schritt 2: Occasion & Season auf TEXT[] umstellen (Multi-Select)
-- Bestehende Einzel-Werte werden sicher als 1-Element-Array übernommen.
-- ALTER TABLE survey_responses
--   ALTER COLUMN a_occasion TYPE TEXT[] USING CASE WHEN a_occasion IS NULL THEN NULL ELSE ARRAY[a_occasion] END,
--   ALTER COLUMN b_occasion TYPE TEXT[] USING CASE WHEN b_occasion IS NULL THEN NULL ELSE ARRAY[b_occasion] END,
--   ALTER COLUMN c_occasion TYPE TEXT[] USING CASE WHEN c_occasion IS NULL THEN NULL ELSE ARRAY[c_occasion] END,
--   ALTER COLUMN d_occasion TYPE TEXT[] USING CASE WHEN d_occasion IS NULL THEN NULL ELSE ARRAY[d_occasion] END,
--   ALTER COLUMN a_season   TYPE TEXT[] USING CASE WHEN a_season   IS NULL THEN NULL ELSE ARRAY[a_season]   END,
--   ALTER COLUMN b_season   TYPE TEXT[] USING CASE WHEN b_season   IS NULL THEN NULL ELSE ARRAY[b_season]   END,
--   ALTER COLUMN c_season   TYPE TEXT[] USING CASE WHEN c_season   IS NULL THEN NULL ELSE ARRAY[c_season]   END,
--   ALTER COLUMN d_season   TYPE TEXT[] USING CASE WHEN d_season   IS NULL THEN NULL ELSE ARRAY[d_season]   END;
