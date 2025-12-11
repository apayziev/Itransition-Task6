-- Data Generator Functions for Fake User Generator
-- Locale-aware functions to generate fake user data components.

-- Generate random first name from lookup table
CREATE OR REPLACE FUNCTION faker.generate_first_name(
    p_locale VARCHAR DEFAULT 'en_US',
    p_gender CHAR DEFAULT NULL
)
RETURNS TEXT AS $$
DECLARE
    result TEXT;
    total_count INTEGER;
    random_offset INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count
    FROM faker.first_names
    WHERE locale = p_locale
      AND (p_gender IS NULL OR gender = p_gender OR gender IS NULL);
    
    IF total_count = 0 THEN
        RETURN 'John';
    END IF;
    
    random_offset := faker.random_int(0, total_count - 1);
    
    SELECT name INTO result
    FROM faker.first_names
    WHERE locale = p_locale
      AND (p_gender IS NULL OR gender = p_gender OR gender IS NULL)
    OFFSET random_offset LIMIT 1;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Generate random last name from lookup table
CREATE OR REPLACE FUNCTION faker.generate_last_name(p_locale VARCHAR DEFAULT 'en_US')
RETURNS TEXT AS $$
DECLARE
    result TEXT;
    total_count INTEGER;
    random_offset INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count FROM faker.last_names WHERE locale = p_locale;
    
    IF total_count = 0 THEN
        RETURN 'Doe';
    END IF;
    
    random_offset := faker.random_int(0, total_count - 1);
    
    SELECT name INTO result FROM faker.last_names
    WHERE locale = p_locale OFFSET random_offset LIMIT 1;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Generate random title (Mr., Mrs., Dr., etc.)
CREATE OR REPLACE FUNCTION faker.generate_title(
    p_locale VARCHAR DEFAULT 'en_US',
    p_gender CHAR DEFAULT NULL
)
RETURNS TEXT AS $$
DECLARE
    result TEXT;
    total_count INTEGER;
    random_offset INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count
    FROM faker.titles
    WHERE locale = p_locale
      AND (p_gender IS NULL OR gender = p_gender OR gender IS NULL);
    
    IF total_count = 0 THEN
        RETURN '';
    END IF;
    
    random_offset := faker.random_int(0, total_count - 1);
    
    SELECT title INTO result FROM faker.titles
    WHERE locale = p_locale
      AND (p_gender IS NULL OR gender = p_gender OR gender IS NULL)
    OFFSET random_offset LIMIT 1;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Generate full name with optional title and middle name
CREATE OR REPLACE FUNCTION faker.generate_full_name(
    p_locale VARCHAR DEFAULT 'en_US',
    p_include_title BOOLEAN DEFAULT NULL,
    p_include_middle BOOLEAN DEFAULT NULL
)
RETURNS TABLE (
    full_name TEXT,
    first_name TEXT,
    middle_name TEXT,
    last_name TEXT,
    title TEXT,
    gender CHAR
) AS $$
DECLARE
    v_gender CHAR;
    v_first_name TEXT;
    v_middle_name TEXT := '';
    v_last_name TEXT;
    v_title TEXT := '';
    v_full_name TEXT;
    v_include_title BOOLEAN;
    v_include_middle BOOLEAN;
BEGIN
    v_gender := CASE WHEN faker.random_boolean(0.5) THEN 'M' ELSE 'F' END;
    v_include_title := COALESCE(p_include_title, faker.random_boolean(0.3));
    v_include_middle := COALESCE(p_include_middle, faker.random_boolean(0.4));
    
    v_first_name := faker.generate_first_name(p_locale, v_gender);
    v_last_name := faker.generate_last_name(p_locale);
    
    IF v_include_middle THEN
        v_middle_name := faker.generate_first_name(p_locale, v_gender);
    END IF;
    
    IF v_include_title THEN
        v_title := faker.generate_title(p_locale, v_gender);
    END IF;
    
    v_full_name := '';
    IF v_title != '' THEN v_full_name := v_title || ' '; END IF;
    v_full_name := v_full_name || v_first_name;
    IF v_middle_name != '' THEN v_full_name := v_full_name || ' ' || v_middle_name; END IF;
    v_full_name := v_full_name || ' ' || v_last_name;
    
    RETURN QUERY SELECT v_full_name, v_first_name, v_middle_name, v_last_name, v_title, v_gender;
END;
$$ LANGUAGE plpgsql;

-- Generate street name with suffix
CREATE OR REPLACE FUNCTION faker.generate_street(p_locale VARCHAR DEFAULT 'en_US')
RETURNS TEXT AS $$
DECLARE
    v_street_name TEXT;
    v_street_suffix TEXT;
    total_streets INTEGER;
    total_suffixes INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_streets FROM faker.streets WHERE locale = p_locale;
    SELECT name INTO v_street_name FROM faker.streets 
    WHERE locale = p_locale OFFSET faker.random_int(0, total_streets - 1) LIMIT 1;
    
    SELECT COUNT(*) INTO total_suffixes FROM faker.street_suffixes WHERE locale = p_locale;
    SELECT suffix INTO v_street_suffix FROM faker.street_suffixes 
    WHERE locale = p_locale OFFSET faker.random_int(0, total_suffixes - 1) LIMIT 1;
    
    IF p_locale LIKE 'de_%' THEN
        RETURN v_street_name || v_street_suffix;
    ELSE
        RETURN v_street_name || ' ' || v_street_suffix;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Generate city name
CREATE OR REPLACE FUNCTION faker.generate_city(p_locale VARCHAR DEFAULT 'en_US')
RETURNS TEXT AS $$
DECLARE
    result TEXT;
    total_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count FROM faker.cities WHERE locale = p_locale;
    SELECT name INTO result FROM faker.cities 
    WHERE locale = p_locale OFFSET faker.random_int(0, total_count - 1) LIMIT 1;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Generate state/region
CREATE OR REPLACE FUNCTION faker.generate_state(p_locale VARCHAR DEFAULT 'en_US')
RETURNS TABLE (name TEXT, abbreviation TEXT) AS $$
DECLARE
    total_count INTEGER;
    random_offset INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count FROM faker.states WHERE locale = p_locale;
    random_offset := faker.random_int(0, total_count - 1);
    
    RETURN QUERY 
    SELECT s.name::TEXT, s.abbreviation::TEXT 
    FROM faker.states s
    WHERE s.locale = p_locale OFFSET random_offset LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- Generate postal code based on locale format
CREATE OR REPLACE FUNCTION faker.generate_postal_code(p_locale VARCHAR DEFAULT 'en_US')
RETURNS TEXT AS $$
DECLARE
    v_format TEXT;
    total_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count FROM faker.postal_formats WHERE locale = p_locale;
    SELECT format INTO v_format FROM faker.postal_formats 
    WHERE locale = p_locale OFFSET faker.random_int(0, total_count - 1) LIMIT 1;
    
    RETURN faker.format_string(v_format);
END;
$$ LANGUAGE plpgsql;

-- Generate complete formatted address
CREATE OR REPLACE FUNCTION faker.generate_address(p_locale VARCHAR DEFAULT 'en_US')
RETURNS TEXT AS $$
DECLARE
    v_street_number TEXT;
    v_street TEXT;
    v_city TEXT;
    v_state RECORD;
    v_postal TEXT;
    v_apt TEXT;
    v_include_apt BOOLEAN;
BEGIN
    v_street_number := faker.random_int(1, 9999)::TEXT;
    v_street := faker.generate_street(p_locale);
    v_city := faker.generate_city(p_locale);
    SELECT * INTO v_state FROM faker.generate_state(p_locale);
    v_postal := faker.generate_postal_code(p_locale);
    v_include_apt := faker.random_boolean(0.2);
    v_apt := faker.random_int(1, 999)::TEXT;
    
    IF p_locale LIKE 'de_%' THEN
        RETURN v_street || ' ' || v_street_number || ', ' || v_postal || ' ' || v_city;
    ELSE
        IF v_include_apt THEN
            RETURN v_street_number || ' ' || v_street || ', Apt ' || v_apt || ', ' || 
                   v_city || ', ' || COALESCE(v_state.abbreviation, '') || ' ' || v_postal;
        ELSE
            RETURN v_street_number || ' ' || v_street || ', ' || 
                   v_city || ', ' || COALESCE(v_state.abbreviation, '') || ' ' || v_postal;
        END IF;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Generate phone number based on locale format
CREATE OR REPLACE FUNCTION faker.generate_phone(p_locale VARCHAR DEFAULT 'en_US')
RETURNS TEXT AS $$
DECLARE
    v_format TEXT;
    total_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count FROM faker.phone_formats WHERE locale = p_locale;
    SELECT format INTO v_format FROM faker.phone_formats 
    WHERE locale = p_locale OFFSET faker.random_int(0, total_count - 1) LIMIT 1;
    
    RETURN faker.format_string(v_format);
END;
$$ LANGUAGE plpgsql;

-- Generate email address based on name
CREATE OR REPLACE FUNCTION faker.generate_email(
    p_locale VARCHAR DEFAULT 'en_US',
    p_first_name TEXT DEFAULT 'john',
    p_last_name TEXT DEFAULT 'doe'
)
RETURNS TEXT AS $$
DECLARE
    v_domain TEXT;
    v_username TEXT;
    v_pattern INTEGER;
    v_first TEXT;
    v_last TEXT;
    total_count INTEGER;
BEGIN
    v_first := LOWER(REGEXP_REPLACE(p_first_name, '[^a-zA-Z]', '', 'g'));
    v_last := LOWER(REGEXP_REPLACE(p_last_name, '[^a-zA-Z]', '', 'g'));
    
    SELECT COUNT(*) INTO total_count FROM faker.email_domains WHERE locale = p_locale;
    SELECT domain INTO v_domain FROM faker.email_domains 
    WHERE locale = p_locale OFFSET faker.random_int(0, total_count - 1) LIMIT 1;
    
    v_pattern := faker.random_int(1, 6);
    
    CASE v_pattern
        WHEN 1 THEN v_username := v_first || '.' || v_last;
        WHEN 2 THEN v_username := SUBSTRING(v_first, 1, 1) || v_last;
        WHEN 3 THEN v_username := v_first || '_' || v_last || faker.random_int(1, 999)::TEXT;
        WHEN 4 THEN v_username := SUBSTRING(v_first, 1, 1) || '.' || v_last;
        WHEN 5 THEN v_username := v_first || v_last;
        ELSE v_username := v_last || '.' || v_first;
    END CASE;
    
    RETURN v_username || '@' || v_domain;
END;
$$ LANGUAGE plpgsql;

-- Generate random eye color
CREATE OR REPLACE FUNCTION faker.generate_eye_color(p_locale VARCHAR DEFAULT 'en_US')
RETURNS TEXT AS $$
DECLARE
    result TEXT;
    total_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_count FROM faker.eye_colors WHERE locale = p_locale;
    SELECT color INTO result FROM faker.eye_colors 
    WHERE locale = p_locale OFFSET faker.random_int(0, total_count - 1) LIMIT 1;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Generate physical attributes using normal distribution
CREATE OR REPLACE FUNCTION faker.generate_physical_attributes(
    p_locale VARCHAR DEFAULT 'en_US',
    p_gender CHAR DEFAULT NULL
)
RETURNS TABLE (
    height_cm DOUBLE PRECISION,
    weight_kg DOUBLE PRECISION,
    eye_color TEXT
) AS $$
DECLARE
    v_height_mean DOUBLE PRECISION;
    v_weight_mean DOUBLE PRECISION;
    v_gender CHAR;
BEGIN
    v_gender := COALESCE(p_gender, CASE WHEN faker.random_boolean(0.5) THEN 'M' ELSE 'F' END);
    
    IF v_gender = 'M' THEN
        v_height_mean := 175.0;
        v_weight_mean := 80.0;
    ELSE
        v_height_mean := 162.0;
        v_weight_mean := 65.0;
    END IF;
    
    RETURN QUERY SELECT 
        GREATEST(faker.random_normal(v_height_mean, 8.0), 140.0),
        GREATEST(faker.random_normal(v_weight_mean, 12.0), 40.0),
        faker.generate_eye_color(p_locale);
END;
$$ LANGUAGE plpgsql;
