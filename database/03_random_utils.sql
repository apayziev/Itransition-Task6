-- Random Utility Functions for Fake User Generator
-- Core random number generation functions with seed support.

-- Sets the random seed for reproducible results
CREATE OR REPLACE FUNCTION faker.seed_random(seed_value DOUBLE PRECISION)
RETURNS VOID AS $$
BEGIN
    PERFORM setseed(seed_value);
END;
$$ LANGUAGE plpgsql;

-- Computes deterministic seed using golden ratio multiplication
CREATE OR REPLACE FUNCTION faker.compute_seed(
    base_seed INTEGER,
    index1 INTEGER DEFAULT 0,
    index2 INTEGER DEFAULT 0
)
RETURNS DOUBLE PRECISION AS $$
DECLARE
    golden_ratio CONSTANT DOUBLE PRECISION := 0.618033988749895;
    phi_complement CONSTANT DOUBLE PRECISION := 0.381966011250105;
    offset_factor CONSTANT DOUBLE PRECISION := 0.123456789;
    raw_value DOUBLE PRECISION;
BEGIN
    raw_value := (base_seed * golden_ratio + index1 * phi_complement + index2 * offset_factor) * 1000;
    RETURN raw_value - FLOOR(raw_value);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Random integer in range (inclusive)
CREATE OR REPLACE FUNCTION faker.random_int(min_val INTEGER, max_val INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN FLOOR(random() * (max_val - min_val + 1) + min_val)::INTEGER;
END;
$$ LANGUAGE plpgsql;

-- Random float in range
CREATE OR REPLACE FUNCTION faker.random_float(
    min_val DOUBLE PRECISION,
    max_val DOUBLE PRECISION
)
RETURNS DOUBLE PRECISION AS $$
BEGIN
    RETURN random() * (max_val - min_val) + min_val;
END;
$$ LANGUAGE plpgsql;

-- Normal distribution using Box-Muller transform
CREATE OR REPLACE FUNCTION faker.random_normal(
    mean DOUBLE PRECISION DEFAULT 0,
    stddev DOUBLE PRECISION DEFAULT 1
)
RETURNS DOUBLE PRECISION AS $$
DECLARE
    u1 DOUBLE PRECISION;
    u2 DOUBLE PRECISION;
    z0 DOUBLE PRECISION;
BEGIN
    u1 := GREATEST(random(), 0.0000001);
    u2 := random();
    z0 := SQRT(-2.0 * LN(u1)) * COS(2.0 * PI() * u2);
    RETURN mean + z0 * stddev;
END;
$$ LANGUAGE plpgsql;

-- Returns TRUE with given probability (0 to 1)
CREATE OR REPLACE FUNCTION faker.random_boolean(probability DOUBLE PRECISION DEFAULT 0.5)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN random() < probability;
END;
$$ LANGUAGE plpgsql;

-- Selects random element from array
CREATE OR REPLACE FUNCTION faker.random_element(elements TEXT[])
RETURNS TEXT AS $$
DECLARE
    idx INTEGER;
BEGIN
    IF array_length(elements, 1) IS NULL THEN
        RETURN NULL;
    END IF;
    idx := faker.random_int(1, array_length(elements, 1));
    RETURN elements[idx];
END;
$$ LANGUAGE plpgsql;

-- Random digit (0-9)
CREATE OR REPLACE FUNCTION faker.random_digit()
RETURNS CHAR AS $$
BEGIN
    RETURN faker.random_int(0, 9)::TEXT;
END;
$$ LANGUAGE plpgsql;

-- Random lowercase letter
CREATE OR REPLACE FUNCTION faker.random_letter()
RETURNS CHAR AS $$
BEGIN
    RETURN CHR(faker.random_int(97, 122));
END;
$$ LANGUAGE plpgsql;

-- Replace # with digits and ? with letters in template
CREATE OR REPLACE FUNCTION faker.format_string(template TEXT)
RETURNS TEXT AS $$
DECLARE
    result TEXT := '';
    i INTEGER;
    ch CHAR;
BEGIN
    FOR i IN 1..LENGTH(template) LOOP
        ch := SUBSTRING(template FROM i FOR 1);
        IF ch = '#' THEN
            result := result || faker.random_digit();
        ELSIF ch = '?' THEN
            result := result || faker.random_letter();
        ELSE
            result := result || ch;
        END IF;
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Random latitude uniformly distributed on sphere: asin(2u - 1) * 180/π
CREATE OR REPLACE FUNCTION faker.random_latitude()
RETURNS DOUBLE PRECISION AS $$
DECLARE
    u DOUBLE PRECISION;
BEGIN
    u := random();
    RETURN DEGREES(ASIN(2 * u - 1));
END;
$$ LANGUAGE plpgsql;

-- Random longitude (-180 to 180)
CREATE OR REPLACE FUNCTION faker.random_longitude()
RETURNS DOUBLE PRECISION AS $$
BEGIN
    RETURN random() * 360 - 180;
END;
$$ LANGUAGE plpgsql;

-- Random geographic coordinates
CREATE OR REPLACE FUNCTION faker.random_coordinates()
RETURNS TABLE (latitude DOUBLE PRECISION, longitude DOUBLE PRECISION) AS $$
BEGIN
    RETURN QUERY SELECT faker.random_latitude(), faker.random_longitude();
END;
$$ LANGUAGE plpgsql;
