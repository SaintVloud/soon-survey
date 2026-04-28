-- SOON Fragrance Survey — Supabase Setup
-- Einmalig ausführen im Supabase SQL Editor

CREATE TABLE IF NOT EXISTS survey_responses (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  session_id TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  block INTEGER,

  -- Block 1: Person
  gender TEXT,
  age_range TEXT,

  -- Block 2: Duft A
  a_adj TEXT[],
  a_occasion TEXT,
  a_gender_perception TEXT,
  a_intensity INTEGER,

  -- Block 3: Duft B
  b_adj TEXT[],
  b_occasion TEXT,
  b_gender_perception TEXT,
  b_intensity INTEGER,

  -- Block 4: Duft C
  c_adj TEXT[],
  c_occasion TEXT,
  c_gender_perception TEXT,
  c_intensity INTEGER,

  -- Block 5: Duft D
  d_adj TEXT[],
  d_occasion TEXT,
  d_gender_perception TEXT,
  d_intensity INTEGER,

  -- Block 6: Naming
  naming_winner TEXT,
  naming_feedback TEXT,

  -- Block 7: Kaufbereitschaft
  price_a NUMERIC,
  price_b NUMERIC,
  price_c NUMERIC,
  price_d NUMERIC,

  -- Block 8: Ranking
  rank_keep TEXT,
  rank_recommend TEXT,
  final_feedback TEXT,

  -- Meta
  completed BOOLEAN DEFAULT FALSE
);

-- Row Level Security aktivieren
ALTER TABLE survey_responses ENABLE ROW LEVEL SECURITY;

-- Jeder darf einfügen und updaten (für anonyme Umfrage)
CREATE POLICY "Anyone can insert" ON survey_responses
  FOR INSERT WITH CHECK (true);

CREATE POLICY "Anyone can update own session" ON survey_responses
  FOR UPDATE USING (true);

CREATE POLICY "Only authenticated can read" ON survey_responses
  FOR SELECT USING (true);
