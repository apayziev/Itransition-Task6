-- Main User Generation Procedure
-- Combines all generators to produce fake users with reproducibility.

-- Generate single fake user with all attributes
CREATE OR REPLACE FUNCTION faker.generate_user(
    p_locale VARCHAR DEFAULT 'en_US',
    p_seed INTEGER DEFAULT 12345,
    p_index INTEGER DEFAULT 0
)
RETURNS TABLE (
    user_index INTEGER,
    full_name TEXT,
    first_name TEXT,
    middle_name TEXT,
    last_name TEXT,
    title TEXT,
    gender CHAR,
    email TEXT,
    phone TEXT,
    address TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    height_cm DOUBLE PRECISION,
    weight_kg DOUBLE PRECISION,
    eye_color TEXT
) AS $$
DECLARE
    v_computed_seed DOUBLE PRECISION;
    v_name RECORD;
    v_physical RECORD;
    v_coords RECORD;
BEGIN
    v_computed_seed := faker.compute_seed(p_seed, p_index, 0);
    PERFORM faker.seed_random(v_computed_seed);
    
    SELECT * INTO v_name FROM faker.generate_full_name(p_locale);
    SELECT * INTO v_physical FROM faker.generate_physical_attributes(p_locale, v_name.gender);
    SELECT * INTO v_coords FROM faker.random_coordinates();
    
    RETURN QUERY SELECT
        p_index,
        v_name.full_name,
        v_name.first_name,
        v_name.middle_name,
        v_name.last_name,
        v_name.title,
        v_name.gender,
        faker.generate_email(p_locale, v_name.first_name, v_name.last_name),
        faker.generate_phone(p_locale),
        faker.generate_address(p_locale),
        v_coords.latitude,
        v_coords.longitude,
        v_physical.height_cm,
        v_physical.weight_kg,
        v_physical.eye_color;
END;
$$ LANGUAGE plpgsql;

-- Generate batch of fake users
CREATE OR REPLACE FUNCTION faker.generate_users(
    p_locale VARCHAR DEFAULT 'en_US',
    p_seed INTEGER DEFAULT 12345,
    p_batch_index INTEGER DEFAULT 0,
    p_batch_size INTEGER DEFAULT 10
)
RETURNS TABLE (
    user_index INTEGER,
    full_name TEXT,
    first_name TEXT,
    middle_name TEXT,
    last_name TEXT,
    title TEXT,
    gender CHAR,
    email TEXT,
    phone TEXT,
    address TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    height_cm DOUBLE PRECISION,
    weight_kg DOUBLE PRECISION,
    eye_color TEXT
) AS $$
DECLARE
    i INTEGER;
    global_index INTEGER;
BEGIN
    FOR i IN 0..(p_batch_size - 1) LOOP
        global_index := p_batch_index * p_batch_size + i;
        RETURN QUERY SELECT * FROM faker.generate_user(p_locale, p_seed, global_index);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Generate large batch for benchmarking
CREATE OR REPLACE FUNCTION faker.generate_users_batch(
    p_locale VARCHAR DEFAULT 'en_US',
    p_seed INTEGER DEFAULT 12345,
    p_count INTEGER DEFAULT 1000
)
RETURNS TABLE (
    user_index INTEGER,
    full_name TEXT,
    first_name TEXT,
    middle_name TEXT,
    last_name TEXT,
    title TEXT,
    gender CHAR,
    email TEXT,
    phone TEXT,
    address TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    height_cm DOUBLE PRECISION,
    weight_kg DOUBLE PRECISION,
    eye_color TEXT
) AS $$
DECLARE
    i INTEGER;
BEGIN
    FOR i IN 0..(p_count - 1) LOOP
        RETURN QUERY SELECT * FROM faker.generate_user(p_locale, p_seed, i);
    END LOOP;
END;
$$ LANGUAGE plpgsql;
