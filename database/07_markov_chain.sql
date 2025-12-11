-- Markov Chain Text Generator
CREATE EXTENSION IF NOT EXISTS hstore;

CREATE TABLE IF NOT EXISTS faker.markov_transitions (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    word1 TEXT NOT NULL,
    word2 TEXT NOT NULL,
    weight INTEGER DEFAULT 1,
    CONSTRAINT fk_markov_locale FOREIGN KEY (locale) REFERENCES faker.locales(code)
);
CREATE INDEX IF NOT EXISTS idx_markov_lookup ON faker.markov_transitions(locale, word1);

-- Integer IDs for fast comparisons
CREATE TABLE IF NOT EXISTS faker.word_dictionary (
    word_id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    word_text TEXT NOT NULL,
    UNIQUE(locale, word_text)
);
CREATE INDEX IF NOT EXISTS idx_dict_lookup ON faker.word_dictionary(locale, word_text);

-- Optimized transitions with integer IDs
CREATE TABLE IF NOT EXISTS faker.markov_transitions_optimized (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    word1_id INTEGER NOT NULL REFERENCES faker.word_dictionary(word_id),
    word2_id INTEGER NOT NULL REFERENCES faker.word_dictionary(word_id),
    weight INTEGER DEFAULT 1
);
CREATE INDEX IF NOT EXISTS idx_opt_lookup ON faker.markov_transitions_optimized(locale, word1_id);

-- Seed Data: English (en_US)
INSERT INTO faker.markov_transitions (locale, word1, word2, weight) VALUES
('en_US', '__START__', 'The', 8), ('en_US', '__START__', 'Our', 6),
('en_US', '__START__', 'We', 5), ('en_US', '__START__', 'Every', 4),
('en_US', '__START__', 'All', 3), ('en_US', '__START__', 'Innovation', 3),
('en_US', '__START__', 'Success', 2), ('en_US', '__START__', 'Quality', 2),
('en_US', '__START__', 'Working', 2), ('en_US', '__START__', 'Building', 2),
('en_US', 'The', 'team', 4), ('en_US', 'The', 'project', 3),
('en_US', 'The', 'solution', 3), ('en_US', 'The', 'company', 2),
('en_US', 'The', 'system', 2), ('en_US', 'The', 'future', 2),
('en_US', 'Our', 'team', 4), ('en_US', 'Our', 'mission', 3),
('en_US', 'Our', 'goal', 3), ('en_US', 'Our', 'commitment', 2),
('en_US', 'Our', 'vision', 2), ('en_US', 'Our', 'approach', 2),
('en_US', 'team', 'delivers', 4), ('en_US', 'team', 'creates', 3),
('en_US', 'team', 'builds', 3), ('en_US', 'team', 'works', 2),
('en_US', 'team', 'provides', 2), ('en_US', 'project', 'delivers', 3),
('en_US', 'project', 'brings', 3), ('en_US', 'project', 'enables', 2),
('en_US', 'project', 'creates', 2), ('en_US', 'solution', 'enables', 4),
('en_US', 'solution', 'brings', 3), ('en_US', 'solution', 'delivers', 2),
('en_US', 'solution', 'provides', 2), ('en_US', 'company', 'strives', 3),
('en_US', 'company', 'delivers', 2), ('en_US', 'company', 'focuses', 2),
('en_US', 'mission', 'is', 4), ('en_US', 'goal', 'is', 4),
('en_US', 'commitment', 'to', 4), ('en_US', 'vision', 'is', 4),
('en_US', 'approach', 'focuses', 3), ('en_US', 'approach', 'delivers', 2),
('en_US', 'delivers', 'outstanding', 4), ('en_US', 'delivers', 'excellent', 3),
('en_US', 'delivers', 'quality', 3), ('en_US', 'delivers', 'innovative', 2),
('en_US', 'creates', 'innovative', 4), ('en_US', 'creates', 'sustainable', 3),
('en_US', 'creates', 'lasting', 2), ('en_US', 'builds', 'strong', 4),
('en_US', 'builds', 'lasting', 3), ('en_US', 'builds', 'trust', 2),
('en_US', 'works', 'together', 4), ('en_US', 'works', 'efficiently', 3),
('en_US', 'works', 'hard', 2), ('en_US', 'provides', 'excellent', 4),
('en_US', 'provides', 'quality', 3), ('en_US', 'provides', 'sustainable', 2),
('en_US', 'brings', 'innovative', 3), ('en_US', 'brings', 'positive', 3),
('en_US', 'brings', 'new', 2), ('en_US', 'enables', 'efficient', 4),
('en_US', 'enables', 'sustainable', 3), ('en_US', 'enables', 'continuous', 2),
('en_US', 'strives', 'for', 5), ('en_US', 'focuses', 'on', 5),
('en_US', 'is', 'to', 4), ('en_US', 'is', 'building', 3),
('en_US', 'is', 'creating', 3), ('en_US', 'is', 'our', 2),
('en_US', 'to', 'deliver', 4), ('en_US', 'to', 'create', 3),
('en_US', 'to', 'build', 3), ('en_US', 'to', 'achieve', 2),
('en_US', 'to', 'provide', 2), ('en_US', 'to', 'excellence', 2),
('en_US', 'outstanding', 'results', 4), ('en_US', 'outstanding', 'service', 3),
('en_US', 'outstanding', 'value', 2), ('en_US', 'excellent', 'results', 4),
('en_US', 'excellent', 'service', 3), ('en_US', 'excellent', 'solutions', 2),
('en_US', 'innovative', 'solutions', 4), ('en_US', 'innovative', 'approaches', 3),
('en_US', 'innovative', 'ideas', 2), ('en_US', 'sustainable', 'growth', 4),
('en_US', 'sustainable', 'solutions', 3), ('en_US', 'sustainable', 'value', 2),
('en_US', 'lasting', 'value', 4), ('en_US', 'lasting', 'partnerships', 3),
('en_US', 'lasting', 'impact', 2), ('en_US', 'strong', 'relationships', 4),
('en_US', 'strong', 'partnerships', 3), ('en_US', 'strong', 'foundations', 2),
('en_US', 'efficient', 'workflows', 4), ('en_US', 'efficient', 'processes', 3),
('en_US', 'efficient', 'systems', 2), ('en_US', 'continuous', 'improvement', 4),
('en_US', 'continuous', 'innovation', 3), ('en_US', 'continuous', 'growth', 2),
('en_US', 'positive', 'change', 4), ('en_US', 'positive', 'impact', 3),
('en_US', 'new', 'opportunities', 4), ('en_US', 'new', 'ideas', 3),
('en_US', 'quality', 'products', 4), ('en_US', 'quality', 'service', 3),
('en_US', 'results', '__END__', 5), ('en_US', 'service', '__END__', 5),
('en_US', 'value', '__END__', 5), ('en_US', 'solutions', '__END__', 5),
('en_US', 'growth', '__END__', 5), ('en_US', 'partnerships', '__END__', 5),
('en_US', 'impact', '__END__', 5), ('en_US', 'relationships', '__END__', 5),
('en_US', 'foundations', '__END__', 5), ('en_US', 'workflows', '__END__', 5),
('en_US', 'processes', '__END__', 5), ('en_US', 'systems', '__END__', 5),
('en_US', 'improvement', '__END__', 5), ('en_US', 'innovation', '__END__', 5),
('en_US', 'change', '__END__', 5), ('en_US', 'opportunities', '__END__', 5),
('en_US', 'ideas', '__END__', 5), ('en_US', 'products', '__END__', 5),
('en_US', 'approaches', '__END__', 5), ('en_US', 'trust', '__END__', 5),
('en_US', 'excellence', '__END__', 5),
-- Extended chains
('en_US', 'We', 'deliver', 4), ('en_US', 'We', 'create', 3),
('en_US', 'We', 'build', 3), ('en_US', 'We', 'believe', 3),
('en_US', 'We', 'strive', 2), ('en_US', 'Every', 'project', 4),
('en_US', 'Every', 'solution', 3), ('en_US', 'Every', 'team', 2),
('en_US', 'All', 'our', 4), ('en_US', 'our', 'solutions', 3),
('en_US', 'our', 'team', 3), ('en_US', 'our', 'work', 2),
('en_US', 'Innovation', 'drives', 4), ('en_US', 'Innovation', 'is', 3),
('en_US', 'Success', 'comes', 4), ('en_US', 'Success', 'through', 3),
('en_US', 'Quality', 'is', 4), ('en_US', 'Quality', 'drives', 3),
('en_US', 'Working', 'together', 4), ('en_US', 'Working', 'hard', 3),
('en_US', 'Building', 'strong', 4), ('en_US', 'Building', 'lasting', 3),
('en_US', 'deliver', 'outstanding', 4), ('en_US', 'deliver', 'excellent', 3),
('en_US', 'deliver', 'quality', 2), ('en_US', 'create', 'innovative', 4),
('en_US', 'create', 'sustainable', 3), ('en_US', 'create', 'lasting', 2),
('en_US', 'build', 'strong', 4), ('en_US', 'build', 'lasting', 3),
('en_US', 'believe', 'in', 5), ('en_US', 'in', 'quality', 4),
('en_US', 'in', 'innovation', 3), ('en_US', 'in', 'excellence', 2),
('en_US', 'strive', 'for', 5), ('en_US', 'for', 'excellence', 4),
('en_US', 'for', 'quality', 3), ('en_US', 'for', 'continuous', 2),
('en_US', 'drives', 'our', 4), ('en_US', 'drives', 'success', 3),
('en_US', 'drives', 'growth', 2), ('en_US', 'comes', 'through', 4),
('en_US', 'comes', 'from', 3), ('en_US', 'through', 'teamwork', 4),
('en_US', 'through', 'innovation', 3), ('en_US', 'through', 'dedication', 2),
('en_US', 'from', 'hard', 4), ('en_US', 'from', 'dedicated', 3),
('en_US', 'from', 'continuous', 2), ('en_US', 'teamwork', '__END__', 5),
('en_US', 'teamwork', 'and', 2), ('en_US', 'and', 'dedication', 4),
('en_US', 'and', 'innovation', 3), ('en_US', 'and', 'continuous', 2),
('en_US', 'dedication', '__END__', 5), ('en_US', 'hard', 'work', 5),
('en_US', 'work', '__END__', 5), ('en_US', 'dedicated', 'teams', 5),
('en_US', 'teams', '__END__', 5), ('en_US', 'together', 'we', 4),
('en_US', 'together', 'to', 3), ('en_US', 'we', 'achieve', 4),
('en_US', 'we', 'create', 3), ('en_US', 'achieve', 'greatness', 4),
('en_US', 'achieve', 'success', 3), ('en_US', 'greatness', '__END__', 5),
('en_US', 'success', '__END__', 5), ('en_US', 'system', 'enables', 4),
('en_US', 'system', 'provides', 3), ('en_US', 'future', 'is', 4),
('en_US', 'future', 'belongs', 3), ('en_US', 'belongs', 'to', 5),
('en_US', 'building', 'a', 4), ('en_US', 'creating', 'a', 4),
('en_US', 'a', 'better', 4), ('en_US', 'a', 'brighter', 3),
('en_US', 'better', 'future', 4), ('en_US', 'better', 'tomorrow', 3),
('en_US', 'brighter', 'future', 5), ('en_US', 'tomorrow', '__END__', 5);

-- Seed Data: German (de_DE)
INSERT INTO faker.markov_transitions (locale, word1, word2, weight) VALUES
('de_DE', '__START__', 'Unser', 6), ('de_DE', '__START__', 'Das', 5),
('de_DE', '__START__', 'Wir', 5), ('de_DE', '__START__', 'Die', 4),
('de_DE', '__START__', 'Jedes', 3), ('de_DE', '__START__', 'Qualität', 2),
('de_DE', '__START__', 'Innovation', 2), ('de_DE', '__START__', 'Erfolg', 2),
('de_DE', '__START__', 'Gemeinsam', 2),
('de_DE', 'Unser', 'Team', 4), ('de_DE', 'Unser', 'Ziel', 3),
('de_DE', 'Unser', 'Ansatz', 2), ('de_DE', 'Das', 'Team', 4),
('de_DE', 'Das', 'Projekt', 3), ('de_DE', 'Das', 'System', 2),
('de_DE', 'Wir', 'liefern', 4), ('de_DE', 'Wir', 'schaffen', 3),
('de_DE', 'Wir', 'bauen', 2), ('de_DE', 'Wir', 'glauben', 2),
('de_DE', 'Wir', 'streben', 2), ('de_DE', 'Die', 'Lösung', 4),
('de_DE', 'Die', 'Zukunft', 3), ('de_DE', 'Die', 'Qualität', 2),
('de_DE', 'Team', 'liefert', 4), ('de_DE', 'Team', 'schafft', 3),
('de_DE', 'Team', 'arbeitet', 2), ('de_DE', 'Ziel', 'ist', 4),
('de_DE', 'Ansatz', 'liefert', 3), ('de_DE', 'Ansatz', 'schafft', 2),
('de_DE', 'Projekt', 'liefert', 4), ('de_DE', 'Projekt', 'ermöglicht', 3),
('de_DE', 'Projekt', 'schafft', 2), ('de_DE', 'System', 'ermöglicht', 4),
('de_DE', 'System', 'liefert', 3), ('de_DE', 'Lösung', 'ermöglicht', 4),
('de_DE', 'Lösung', 'bietet', 3), ('de_DE', 'Zukunft', 'gehört', 4),
('de_DE', 'Zukunft', 'ist', 3), ('de_DE', 'ist', 'Exzellenz', 4),
('de_DE', 'ist', 'Innovation', 3), ('de_DE', 'ist', 'unser', 2),
('de_DE', 'liefert', 'hervorragende', 4), ('de_DE', 'liefert', 'exzellente', 3),
('de_DE', 'liefert', 'innovative', 2), ('de_DE', 'schafft', 'nachhaltige', 4),
('de_DE', 'schafft', 'innovative', 3), ('de_DE', 'schafft', 'starke', 2),
('de_DE', 'arbeitet', 'effizient', 4), ('de_DE', 'arbeitet', 'gemeinsam', 3),
('de_DE', 'arbeitet', 'hart', 2), ('de_DE', 'ermöglicht', 'effiziente', 4),
('de_DE', 'ermöglicht', 'nachhaltige', 3), ('de_DE', 'ermöglicht', 'kontinuierliche', 2),
('de_DE', 'bietet', 'exzellente', 4), ('de_DE', 'bietet', 'innovative', 3),
('de_DE', 'gehört', 'denen', 4), ('de_DE', 'denen', 'die', 5),
('de_DE', 'die', 'innovativ', 4), ('de_DE', 'die', 'hart', 3),
('de_DE', 'innovativ', 'denken', 5), ('de_DE', 'denken', '__END__', 5),
('de_DE', 'hervorragende', 'Ergebnisse', 4), ('de_DE', 'hervorragende', 'Lösungen', 3),
('de_DE', 'exzellente', 'Ergebnisse', 4), ('de_DE', 'exzellente', 'Lösungen', 3),
('de_DE', 'innovative', 'Lösungen', 4), ('de_DE', 'innovative', 'Ansätze', 3),
('de_DE', 'nachhaltige', 'Ergebnisse', 4), ('de_DE', 'nachhaltige', 'Lösungen', 3),
('de_DE', 'nachhaltige', 'Werte', 2), ('de_DE', 'starke', 'Partnerschaften', 4),
('de_DE', 'starke', 'Beziehungen', 3), ('de_DE', 'effiziente', 'Prozesse', 4),
('de_DE', 'effiziente', 'Abläufe', 3), ('de_DE', 'kontinuierliche', 'Verbesserung', 4),
('de_DE', 'kontinuierliche', 'Innovation', 3),
('de_DE', 'Ergebnisse', '__END__', 5), ('de_DE', 'Lösungen', '__END__', 5),
('de_DE', 'Ansätze', '__END__', 5), ('de_DE', 'Beziehungen', '__END__', 5),
('de_DE', 'Werte', '__END__', 5), ('de_DE', 'Prozesse', '__END__', 5),
('de_DE', 'Abläufe', '__END__', 5), ('de_DE', 'Veränderung', '__END__', 5),
('de_DE', 'Möglichkeiten', '__END__', 5), ('de_DE', 'Wege', '__END__', 5),
('de_DE', 'Mehrwert', '__END__', 5), ('de_DE', 'Exzellenz', '__END__', 5),
('de_DE', 'Innovation', '__END__', 5),
('de_DE', 'Lösungen', 'für', 2), ('de_DE', 'Ergebnisse', 'und', 2),
('de_DE', 'für', 'nachhaltigen', 3), ('de_DE', 'für', 'unsere', 3),
('de_DE', 'für', 'Exzellenz', 2), ('de_DE', 'und', 'nachhaltige', 3),
('de_DE', 'und', 'innovative', 3), ('de_DE', 'und', 'kontinuierliche', 2),
('de_DE', 'nachhaltigen', 'Erfolg', 5), ('de_DE', 'unsere', 'Kunden', 4),
('de_DE', 'unsere', 'Partner', 3), ('de_DE', 'Erfolg', '__END__', 5),
('de_DE', 'Kunden', '__END__', 5), ('de_DE', 'Partner', '__END__', 5),
('de_DE', 'schaffen', 'Mehrwert', 4), ('de_DE', 'schaffen', 'Lösungen', 3),
('de_DE', 'schaffen', 'innovative', 2), ('de_DE', 'liefern', 'Ergebnisse', 4),
('de_DE', 'liefern', 'Qualität', 3), ('de_DE', 'liefern', 'Mehrwert', 2),
('de_DE', 'bauen', 'auf', 4), ('de_DE', 'bauen', 'starke', 3),
('de_DE', 'Partnerschaften', '__END__', 5), ('de_DE', 'glauben', 'an', 5),
('de_DE', 'an', 'Innovation', 3), ('de_DE', 'an', 'Qualität', 3),
('de_DE', 'an', 'Exzellenz', 2), ('de_DE', 'nach', 'Exzellenz', 4),
('de_DE', 'nach', 'Innovation', 3), ('de_DE', 'nach', 'Qualität', 2),
('de_DE', 'Jedes', 'Projekt', 4), ('de_DE', 'Jedes', 'Team', 3),
('de_DE', 'Qualität', 'ist', 4), ('de_DE', 'Qualität', 'steht', 2),
('de_DE', 'Innovation', 'treibt', 4), ('de_DE', 'Erfolg', 'kommt', 4),
('de_DE', 'Gemeinsam', 'arbeiten', 4), ('de_DE', 'Gemeinsam', 'schaffen', 3),
('de_DE', 'treibt', 'uns', 4), ('de_DE', 'treibt', 'Wachstum', 2),
('de_DE', 'uns', 'voran', 5), ('de_DE', 'voran', '__END__', 5),
('de_DE', 'Wachstum', '__END__', 5), ('de_DE', 'kommt', 'durch', 5),
('de_DE', 'durch', 'Teamarbeit', 4), ('de_DE', 'durch', 'Innovation', 3),
('de_DE', 'Teamarbeit', '__END__', 5), ('de_DE', 'Teamarbeit', 'und', 2),
('de_DE', 'steht', 'im', 4), ('de_DE', 'im', 'Mittelpunkt', 5),
('de_DE', 'Mittelpunkt', '__END__', 5), ('de_DE', 'gemeinsam', 'an', 4),
('de_DE', 'gemeinsam', 'für', 3), ('de_DE', 'effizient', '__END__', 4),
('de_DE', 'hart', 'an', 3), ('de_DE', 'an', 'Lösungen', 3),
('de_DE', 'an', 'Ideen', 2), ('de_DE', 'Verbesserung', '__END__', 5),
('de_DE', 'Arbeit', 'schafft', 4), ('de_DE', 'Arbeit', 'liefert', 3),
('de_DE', 'Lösungen', 'schaffen', 2), ('de_DE', 'Lösungen', 'liefern', 2);

-- Populate optimized tables
INSERT INTO faker.word_dictionary (locale, word_text)
SELECT DISTINCT locale, word1 FROM faker.markov_transitions
UNION
SELECT DISTINCT locale, word2 FROM faker.markov_transitions
ON CONFLICT (locale, word_text) DO NOTHING;

INSERT INTO faker.markov_transitions_optimized (locale, word1_id, word2_id, weight)
SELECT t.locale, d1.word_id, d2.word_id, t.weight
FROM faker.markov_transitions t
JOIN faker.word_dictionary d1 ON d1.locale = t.locale AND d1.word_text = t.word1
JOIN faker.word_dictionary d2 ON d2.locale = t.locale AND d2.word_text = t.word2;

-- Materialized view with pre-computed cumulative weights
CREATE MATERIALIZED VIEW IF NOT EXISTS faker.markov_cumulative AS
WITH ranked AS (
    SELECT t.locale, t.word1_id, t.word2_id, t.weight, d2.word_text as word2_text,
        ROW_NUMBER() OVER (PARTITION BY t.locale, t.word1_id ORDER BY t.word2_id) as idx
    FROM faker.markov_transitions_optimized t
    JOIN faker.word_dictionary d2 ON d2.word_id = t.word2_id
),
with_cumulative AS (
    SELECT r.*,
        SUM(weight) OVER (PARTITION BY locale, word1_id ORDER BY idx ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cumulative_weight,
        SUM(weight) OVER (PARTITION BY locale, word1_id) as total_weight
    FROM ranked r
)
SELECT locale, word1_id, word2_id, word2_text, weight, idx, cumulative_weight, total_weight
FROM with_cumulative ORDER BY locale, word1_id, idx;

CREATE UNIQUE INDEX IF NOT EXISTS idx_markov_cum_lookup ON faker.markov_cumulative(locale, word1_id, idx);
CREATE INDEX IF NOT EXISTS idx_markov_cum_word1 ON faker.markov_cumulative(locale, word1_id);

-- Optimized Markov text generator using HSTORE for O(1) lookups
CREATE OR REPLACE FUNCTION faker.blazing_fast_markov_text(
    p_locale VARCHAR DEFAULT 'en_US',
    p_seed INTEGER DEFAULT 0,
    p_min_words INTEGER DEFAULT 8,
    p_max_words INTEGER DEFAULT 20
)
RETURNS TEXT AS $$
DECLARE
    v_start_id INTEGER; v_end_id INTEGER;
    v_starter_ids INTEGER[]; v_starter_texts TEXT[];
    v_starter_cum INTEGER[]; v_starter_total INTEGER;
    v_word1_ids INTEGER[]; v_word2_ids INTEGER[];
    v_word2_texts TEXT[]; v_cum INTEGER[]; v_totals INTEGER[];
    v_index HSTORE; v_index_pos INTEGER;
    v_result TEXT := ''; v_current_id INTEGER; v_current_text TEXT;
    v_next_id INTEGER; v_next_text TEXT;
    v_word_count INTEGER := 0; v_sentence_word_count INTEGER := 0;
    v_sentence_count INTEGER := 0; v_min_sentence_words INTEGER := 4;
    v_random_val INTEGER; v_hash_num BIGINT; v_i INTEGER; v_arr_len INTEGER;
BEGIN
    SELECT word_id INTO v_start_id FROM faker.word_dictionary WHERE locale = p_locale AND word_text = '__START__';
    SELECT word_id INTO v_end_id FROM faker.word_dictionary WHERE locale = p_locale AND word_text = '__END__';
    IF v_start_id IS NULL THEN RETURN 'No patterns.'; END IF;
    
    SELECT ARRAY_AGG(word2_id ORDER BY idx), ARRAY_AGG(word2_text ORDER BY idx),
           ARRAY_AGG(cumulative_weight ORDER BY idx), MAX(total_weight)
    INTO v_starter_ids, v_starter_texts, v_starter_cum, v_starter_total
    FROM faker.markov_cumulative WHERE locale = p_locale AND word1_id = v_start_id;
    IF v_starter_total IS NULL THEN RETURN 'No starters.'; END IF;
    
    SELECT ARRAY_AGG(word1_id ORDER BY word1_id, idx), ARRAY_AGG(word2_id ORDER BY word1_id, idx),
           ARRAY_AGG(word2_text ORDER BY word1_id, idx), ARRAY_AGG(cumulative_weight ORDER BY word1_id, idx),
           ARRAY_AGG(total_weight ORDER BY word1_id, idx)
    INTO v_word1_ids, v_word2_ids, v_word2_texts, v_cum, v_totals
    FROM faker.markov_cumulative WHERE locale = p_locale AND word1_id != v_start_id;
    
    v_arr_len := COALESCE(array_length(v_word1_ids, 1), 0);
    v_index := ''::HSTORE;
    FOR v_i IN 1..v_arr_len LOOP
        IF (v_index -> v_word1_ids[v_i]::TEXT) IS NULL THEN
            v_index := v_index || hstore(v_word1_ids[v_i]::TEXT, v_i::TEXT);
        END IF;
    END LOOP;
    
    WHILE v_word_count < p_max_words AND v_sentence_count < 5 LOOP
        v_hash_num := (p_seed::BIGINT * 1000000) + v_sentence_count;
        v_random_val := ABS(hashtext(v_hash_num::TEXT)) % v_starter_total;
        
        FOR v_i IN 1..array_length(v_starter_cum, 1) LOOP
            IF v_starter_cum[v_i] > v_random_val THEN
                v_current_id := v_starter_ids[v_i]; v_current_text := v_starter_texts[v_i];
                EXIT;
            END IF;
        END LOOP;
        
        IF v_result != '' THEN v_result := v_result || ' '; END IF;
        v_result := v_result || v_current_text;
        v_word_count := v_word_count + 1; v_sentence_word_count := 1;
        
        FOR v_i IN 1..30 LOOP
            IF v_word_count >= p_max_words THEN
                v_result := v_result || '.'; v_sentence_count := v_sentence_count + 1; EXIT;
            END IF;
            
            v_index_pos := (v_index -> v_current_id::TEXT)::INTEGER;
            IF v_index_pos IS NULL THEN
                v_result := v_result || '.'; v_sentence_count := v_sentence_count + 1; EXIT;
            END IF;
            
            v_hash_num := (p_seed::BIGINT * 10000000) + (v_word_count * 1000) + v_current_id;
            v_random_val := ABS(hashtext(v_hash_num::TEXT)) % v_totals[v_index_pos];
            v_next_id := NULL;
            
            WHILE v_index_pos <= v_arr_len AND v_word1_ids[v_index_pos] = v_current_id LOOP
                IF v_sentence_word_count >= v_min_sentence_words OR v_word2_ids[v_index_pos] != v_end_id THEN
                    IF v_cum[v_index_pos] > v_random_val THEN
                        v_next_id := v_word2_ids[v_index_pos]; v_next_text := v_word2_texts[v_index_pos]; EXIT;
                    END IF;
                END IF;
                v_index_pos := v_index_pos + 1;
            END LOOP;
            
            IF v_next_id IS NULL OR v_next_id = v_end_id THEN
                v_result := v_result || '.'; v_sentence_count := v_sentence_count + 1; EXIT;
            END IF;
            
            v_result := v_result || ' ' || v_next_text;
            v_word_count := v_word_count + 1; v_sentence_word_count := v_sentence_word_count + 1;
            v_current_id := v_next_id;
        END LOOP;
        
        IF v_word_count >= p_min_words THEN EXIT; END IF;
    END LOOP;
    
    RETURN v_result;
END;
$$ LANGUAGE plpgsql;

-- Generate bio text (convenience wrapper)
CREATE OR REPLACE FUNCTION faker.generate_bio(p_locale VARCHAR DEFAULT 'en_US', p_seed INTEGER DEFAULT 0)
RETURNS TEXT AS $$
BEGIN
    RETURN faker.blazing_fast_markov_text(p_locale, p_seed, 12, 30);
END;
$$ LANGUAGE plpgsql;
