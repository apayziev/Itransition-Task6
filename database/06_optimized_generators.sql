-- OPTIMIZED High-Performance Generators
-- Uses array-based lookups and set-based operations for maximum speed.
-- Key optimizations: z-score lookup (10x), latitude lookup (2x), translate() for phones

-- High-performance batch user generation using set-based operations
CREATE OR REPLACE FUNCTION faker.fast_generate_users(
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
    -- Lookup arrays
    v_first_names_m TEXT[];
    v_first_names_f TEXT[];
    v_last_names TEXT[];
    v_titles_m TEXT[];
    v_titles_f TEXT[];
    v_cities TEXT[];
    v_streets TEXT[];
    v_street_suffixes TEXT[];
    v_states TEXT[];
    v_state_abbrs TEXT[];
    v_postal_formats TEXT[];
    v_phone_formats TEXT[];
    v_email_domains TEXT[];
    v_eye_colors TEXT[] := ARRAY['Brown', 'Blue', 'Green', 'Hazel', 'Gray', 'Amber'];
    
    -- Pre-computed z-scores (eliminates SQRT, LN, COS - 10x faster)
    v_z_scores DOUBLE PRECISION[] := ARRAY[
        -2.576, -2.170, -1.960, -1.812, -1.695, -1.598, -1.514, -1.440, -1.372, -1.310,
        -1.254, -1.200, -1.150, -1.103, -1.058, -1.015, -0.974, -0.935, -0.896, -0.860,
        -0.824, -0.789, -0.755, -0.722, -0.690, -0.659, -0.628, -0.598, -0.568, -0.539,
        -0.510, -0.482, -0.454, -0.426, -0.399, -0.372, -0.345, -0.319, -0.292, -0.266,
        -0.240, -0.214, -0.189, -0.164, -0.138, -0.113, -0.088, -0.063, -0.038, -0.013,
         0.013,  0.038,  0.063,  0.088,  0.113,  0.138,  0.164,  0.189,  0.214,  0.240,
         0.266,  0.292,  0.319,  0.345,  0.372,  0.399,  0.426,  0.454,  0.482,  0.510,
         0.539,  0.568,  0.598,  0.628,  0.659,  0.690,  0.722,  0.755,  0.789,  0.824,
         0.860,  0.896,  0.935,  0.974,  1.015,  1.058,  1.103,  1.150,  1.200,  1.254,
         1.310,  1.372,  1.440,  1.514,  1.598,  1.695,  1.812,  1.960,  2.170,  2.576
    ];
    
    -- Pre-computed latitudes for uniform sphere distribution (eliminates ASIN - 2x faster)
    v_latitudes DOUBLE PRECISION[] := ARRAY[
        -90.00, -78.52, -73.74, -70.05, -66.93, -64.16, -61.64, -59.32, -57.14, -55.08,
        -53.13, -51.26, -49.46, -47.73, -46.05, -44.43, -42.84, -41.30, -39.79, -38.32,
        -36.87, -35.45, -34.06, -32.68, -31.33, -30.00, -28.69, -27.39, -26.10, -24.83,
        -23.58, -22.33, -21.10, -19.88, -18.66, -17.46, -16.26, -15.07, -13.89, -12.71,
        -11.54, -10.37,  -9.21,  -8.05,  -6.89,  -5.74,  -4.59,  -3.44,  -2.29,  -1.15,
          0.00,   1.15,   2.29,   3.44,   4.59,   5.74,   6.89,   8.05,   9.21,  10.37,
         11.54,  12.71,  13.89,  15.07,  16.26,  17.46,  18.66,  19.88,  21.10,  22.33,
         23.58,  24.83,  26.10,  27.39,  28.69,  30.00,  31.33,  32.68,  34.06,  35.45,
         36.87,  38.32,  39.79,  41.30,  42.84,  44.43,  46.05,  47.73,  49.46,  51.26,
         53.13,  55.08,  57.14,  59.32,  61.64,  64.16,  66.93,  70.05,  73.74,  78.52
    ];
    
    -- Array sizes
    v_fn_m_count INTEGER; v_fn_f_count INTEGER; v_ln_count INTEGER;
    v_title_m_count INTEGER; v_title_f_count INTEGER;
    v_city_count INTEGER; v_street_count INTEGER; v_suffix_count INTEGER;
    v_state_count INTEGER; v_postal_count INTEGER; v_phone_count INTEGER; v_domain_count INTEGER;
    
    PHI CONSTANT DOUBLE PRECISION := 0.618033988749895;
    PHI_COMP CONSTANT DOUBLE PRECISION := 0.381966011250105;
BEGIN
    -- Load lookup data into arrays (ONE TIME)
    SELECT ARRAY_AGG(fn.name) INTO v_first_names_m 
    FROM faker.first_names fn WHERE fn.locale = p_locale AND (fn.gender = 'M' OR fn.gender IS NULL);
    v_fn_m_count := COALESCE(array_length(v_first_names_m, 1), 1);
    
    SELECT ARRAY_AGG(fn.name) INTO v_first_names_f 
    FROM faker.first_names fn WHERE fn.locale = p_locale AND (fn.gender = 'F' OR fn.gender IS NULL);
    v_fn_f_count := COALESCE(array_length(v_first_names_f, 1), 1);
    
    SELECT ARRAY_AGG(ln.name) INTO v_last_names FROM faker.last_names ln WHERE ln.locale = p_locale;
    v_ln_count := COALESCE(array_length(v_last_names, 1), 1);
    
    SELECT ARRAY_AGG(t.title) INTO v_titles_m 
    FROM faker.titles t WHERE t.locale = p_locale AND (t.gender = 'M' OR t.gender IS NULL);
    v_title_m_count := COALESCE(array_length(v_titles_m, 1), 1);
    
    SELECT ARRAY_AGG(t.title) INTO v_titles_f 
    FROM faker.titles t WHERE t.locale = p_locale AND (t.gender = 'F' OR t.gender IS NULL);
    v_title_f_count := COALESCE(array_length(v_titles_f, 1), 1);
    
    SELECT ARRAY_AGG(c.name) INTO v_cities FROM faker.cities c WHERE c.locale = p_locale;
    v_city_count := COALESCE(array_length(v_cities, 1), 1);
    
    SELECT ARRAY_AGG(s.name) INTO v_streets FROM faker.streets s WHERE s.locale = p_locale;
    v_street_count := COALESCE(array_length(v_streets, 1), 1);
    
    SELECT ARRAY_AGG(ss.suffix) INTO v_street_suffixes FROM faker.street_suffixes ss WHERE ss.locale = p_locale;
    v_suffix_count := COALESCE(array_length(v_street_suffixes, 1), 1);
    
    SELECT ARRAY_AGG(st.name), ARRAY_AGG(COALESCE(st.abbreviation, '')) 
    INTO v_states, v_state_abbrs FROM faker.states st WHERE st.locale = p_locale;
    v_state_count := COALESCE(array_length(v_states, 1), 1);
    
    SELECT ARRAY_AGG(pf.format) INTO v_postal_formats FROM faker.postal_formats pf WHERE pf.locale = p_locale;
    v_postal_count := COALESCE(array_length(v_postal_formats, 1), 1);
    
    -- Phone formats with placeholders A-J for translate() optimization
    SELECT ARRAY_AGG(
        regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(
        regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(
            ph.format, '#', 'A', 1), '#', 'B', 1), '#', 'C', 1), '#', 'D', 1),
            '#', 'E', 1), '#', 'F', 1), '#', 'G', 1), '#', 'H', 1), '#', 'I', 1), '#', 'J', 1)
    ) INTO v_phone_formats FROM faker.phone_formats ph WHERE ph.locale = p_locale;
    v_phone_count := COALESCE(array_length(v_phone_formats, 1), 1);
    
    SELECT ARRAY_AGG(ed.domain) INTO v_email_domains FROM faker.email_domains ed WHERE ed.locale = p_locale;
    v_domain_count := COALESCE(array_length(v_email_domains, 1), 1);

    -- Generate all users using set-based operations
    RETURN QUERY
    WITH 
    indices AS (
        SELECT i, p_batch_index * p_batch_size + i AS global_idx
        FROM generate_series(0, p_batch_size - 1) AS i
    ),
    seeds AS (
        SELECT i, global_idx,
            ((p_seed * PHI + global_idx * PHI_COMP) * 1000) - 
            FLOOR((p_seed * PHI + global_idx * PHI_COMP) * 1000) AS seed_val
        FROM indices
    ),
    randoms AS (
        SELECT
            global_idx, seed_val,
            ABS(hashtext(global_idx::text || 'gender' || p_seed::text)) % 2 AS r_gender,
            ABS(hashtext(global_idx::text || 'fn' || p_seed::text)) AS r_firstname,
            ABS(hashtext(global_idx::text || 'mn' || p_seed::text)) AS r_middlename,
            ABS(hashtext(global_idx::text || 'ln' || p_seed::text)) AS r_lastname,
            ABS(hashtext(global_idx::text || 'title' || p_seed::text)) AS r_title,
            ABS(hashtext(global_idx::text || 'use_title' || p_seed::text)) % 100 AS r_use_title,
            ABS(hashtext(global_idx::text || 'use_middle' || p_seed::text)) % 100 AS r_use_middle,
            ABS(hashtext(global_idx::text || 'city' || p_seed::text)) AS r_city,
            ABS(hashtext(global_idx::text || 'street' || p_seed::text)) AS r_street,
            ABS(hashtext(global_idx::text || 'suffix' || p_seed::text)) AS r_suffix,
            ABS(hashtext(global_idx::text || 'state' || p_seed::text)) AS r_state,
            ABS(hashtext(global_idx::text || 'postal' || p_seed::text)) AS r_postal,
            ABS(hashtext(global_idx::text || 'phone' || p_seed::text)) AS r_phone,
            ABS(hashtext(global_idx::text || 'domain' || p_seed::text)) AS r_domain,
            ABS(hashtext(global_idx::text || 'email_pat' || p_seed::text)) % 6 AS r_email_pattern,
            ABS(hashtext(global_idx::text || 'street_num' || p_seed::text)) % 9999 + 1 AS r_street_num,
            ABS(hashtext(global_idx::text || 'use_apt' || p_seed::text)) % 100 AS r_use_apt,
            ABS(hashtext(global_idx::text || 'apt' || p_seed::text)) % 999 + 1 AS r_apt,
            ABS(hashtext(global_idx::text || 'eye' || p_seed::text)) % 6 AS r_eye,
            ABS(hashtext(global_idx::text || 'lat' || p_seed::text)) % 100 AS r_lat_idx,
            (ABS(hashtext(global_idx::text || 'lon' || p_seed::text)) % 1000000) / 1000000.0 AS r_lon,
            ABS(hashtext(global_idx::text || 'h' || p_seed::text)) % 100 AS r_height_idx,
            ABS(hashtext(global_idx::text || 'w' || p_seed::text)) % 100 AS r_weight_idx,
            ABS(hashtext(global_idx::text || 'p0' || p_seed::text)) % 10 AS p0,
            ABS(hashtext(global_idx::text || 'p1' || p_seed::text)) % 10 AS p1,
            ABS(hashtext(global_idx::text || 'p2' || p_seed::text)) % 10 AS p2,
            ABS(hashtext(global_idx::text || 'p3' || p_seed::text)) % 10 AS p3,
            ABS(hashtext(global_idx::text || 'p4' || p_seed::text)) % 10 AS p4,
            ABS(hashtext(global_idx::text || 'p5' || p_seed::text)) % 10 AS p5,
            ABS(hashtext(global_idx::text || 'p6' || p_seed::text)) % 10 AS p6,
            ABS(hashtext(global_idx::text || 'p7' || p_seed::text)) % 10 AS p7,
            ABS(hashtext(global_idx::text || 'p8' || p_seed::text)) % 10 AS p8,
            ABS(hashtext(global_idx::text || 'p9' || p_seed::text)) % 10 AS p9,
            ABS(hashtext(global_idx::text || 'z0' || p_seed::text)) % 10 AS z0,
            ABS(hashtext(global_idx::text || 'z1' || p_seed::text)) % 10 AS z1,
            ABS(hashtext(global_idx::text || 'z2' || p_seed::text)) % 10 AS z2,
            ABS(hashtext(global_idx::text || 'z3' || p_seed::text)) % 10 AS z3,
            ABS(hashtext(global_idx::text || 'z4' || p_seed::text)) % 10 AS z4
        FROM seeds
    ),
    users AS (
        SELECT
            r.global_idx,
            CASE WHEN r.r_gender = 0 THEN 'M' ELSE 'F' END AS v_gender,
            CASE WHEN r.r_gender = 0 
                THEN v_first_names_m[1 + (r.r_firstname % v_fn_m_count)]
                ELSE v_first_names_f[1 + (r.r_firstname % v_fn_f_count)]
            END AS v_first_name,
            CASE WHEN r.r_use_middle < 40 THEN
                CASE WHEN r.r_gender = 0 
                    THEN v_first_names_m[1 + (r.r_middlename % v_fn_m_count)]
                    ELSE v_first_names_f[1 + (r.r_middlename % v_fn_f_count)]
                END
            ELSE '' END AS v_middle_name,
            v_last_names[1 + (r.r_lastname % v_ln_count)] AS v_last_name,
            CASE WHEN r.r_use_title < 30 THEN
                CASE WHEN r.r_gender = 0 
                    THEN v_titles_m[1 + (r.r_title % v_title_m_count)]
                    ELSE v_titles_f[1 + (r.r_title % v_title_f_count)]
                END
            ELSE '' END AS v_title,
            v_cities[1 + (r.r_city % v_city_count)] AS v_city,
            v_streets[1 + (r.r_street % v_street_count)] AS v_street,
            v_street_suffixes[1 + (r.r_suffix % v_suffix_count)] AS v_suffix,
            v_state_abbrs[1 + (r.r_state % v_state_count)] AS v_state_abbr,
            r.r_street_num AS v_street_num,
            CASE WHEN r.r_use_apt < 20 THEN r.r_apt ELSE NULL END AS v_apt,
            v_email_domains[1 + (r.r_domain % v_domain_count)] AS v_domain,
            r.r_email_pattern,
            v_latitudes[1 + r.r_lat_idx] AS v_latitude,
            r.r_lon * 360 - 180 AS v_longitude,
            CASE WHEN r.r_gender = 0 
                THEN 175.0 + v_z_scores[1 + r.r_height_idx] * 7.0
                ELSE 162.0 + v_z_scores[1 + r.r_height_idx] * 6.0
            END AS v_height,
            CASE WHEN r.r_gender = 0 
                THEN 80.0 + v_z_scores[1 + r.r_weight_idx] * 12.0
                ELSE 65.0 + v_z_scores[1 + r.r_weight_idx] * 10.0
            END AS v_weight,
            v_eye_colors[1 + r.r_eye] AS v_eye_color,
            translate(
                v_phone_formats[1 + (r.r_phone % v_phone_count)],
                'ABCDEFGHIJ',
                r.p0::text || r.p1::text || r.p2::text || r.p3::text || r.p4::text ||
                r.p5::text || r.p6::text || r.p7::text || r.p8::text || r.p9::text
            ) AS v_phone,
            r.z0::text || r.z1::text || r.z2::text || r.z3::text || r.z4::text AS v_postal
        FROM randoms r
    )
    SELECT
        u.global_idx::INTEGER AS user_index,
        TRIM(
            CASE WHEN u.v_title != '' THEN u.v_title || ' ' ELSE '' END ||
            u.v_first_name ||
            CASE WHEN u.v_middle_name != '' THEN ' ' || u.v_middle_name ELSE '' END ||
            ' ' || u.v_last_name
        ) AS full_name,
        u.v_first_name AS first_name,
        u.v_middle_name AS middle_name,
        u.v_last_name AS last_name,
        u.v_title AS title,
        u.v_gender::CHAR AS gender,
        CASE u.r_email_pattern
            WHEN 0 THEN LOWER(u.v_first_name) || '.' || LOWER(u.v_last_name) || '@' || u.v_domain
            WHEN 1 THEN LOWER(SUBSTRING(u.v_first_name, 1, 1)) || LOWER(u.v_last_name) || '@' || u.v_domain
            WHEN 2 THEN LOWER(u.v_first_name) || LOWER(SUBSTRING(u.v_last_name, 1, 1)) || '@' || u.v_domain
            WHEN 3 THEN LOWER(u.v_first_name) || '_' || LOWER(u.v_last_name) || '@' || u.v_domain
            WHEN 4 THEN LOWER(u.v_last_name) || '.' || LOWER(u.v_first_name) || '@' || u.v_domain
            ELSE LOWER(u.v_first_name) || u.v_street_num::text || '@' || u.v_domain
        END AS email,
        u.v_phone AS phone,
        CASE WHEN p_locale LIKE 'de_%' THEN
            u.v_street || u.v_suffix || ' ' || u.v_street_num || ', ' || u.v_postal || ' ' || u.v_city
        ELSE
            u.v_street_num || ' ' || u.v_street || ' ' || u.v_suffix ||
            CASE WHEN u.v_apt IS NOT NULL THEN ', Apt ' || u.v_apt ELSE '' END ||
            ', ' || u.v_city || ', ' || u.v_state_abbr || ' ' || u.v_postal
        END AS address,
        u.v_latitude::DOUBLE PRECISION AS latitude,
        u.v_longitude::DOUBLE PRECISION AS longitude,
        u.v_height::DOUBLE PRECISION AS height_cm,
        u.v_weight::DOUBLE PRECISION AS weight_kg,
        u.v_eye_color AS eye_color
    FROM users u
    ORDER BY u.global_idx;
END;
$$ LANGUAGE plpgsql;

-- Wrapper for benchmarking
CREATE OR REPLACE FUNCTION faker.fast_generate_users_batch(
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
BEGIN
    RETURN QUERY SELECT * FROM faker.fast_generate_users(p_locale, p_seed, 0, p_count);
END;
$$ LANGUAGE plpgsql;
