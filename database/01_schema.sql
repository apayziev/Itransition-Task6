-- Database Schema
CREATE SCHEMA IF NOT EXISTS faker;

-- Locales table
CREATE TABLE IF NOT EXISTS faker.locales (
    id SERIAL PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,  -- e.g., 'en_US', 'de_DE'
    name VARCHAR(100) NOT NULL,         -- e.g., 'English (USA)', 'German (Germany)'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- First names
CREATE TABLE IF NOT EXISTS faker.first_names (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
    gender CHAR(1),  -- 'M', 'F', or NULL for neutral
    CONSTRAINT fk_first_names_locale FOREIGN KEY (locale) REFERENCES faker.locales(code)
);
CREATE INDEX IF NOT EXISTS idx_first_names_locale ON faker.first_names(locale);

-- Last names
CREATE TABLE IF NOT EXISTS faker.last_names (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT fk_last_names_locale FOREIGN KEY (locale) REFERENCES faker.locales(code)
);
CREATE INDEX IF NOT EXISTS idx_last_names_locale ON faker.last_names(locale);

-- Titles (Mr., Mrs., Dr., etc.)
CREATE TABLE IF NOT EXISTS faker.titles (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    title VARCHAR(50) NOT NULL,
    gender CHAR(1),  -- 'M', 'F', or NULL for neutral
    CONSTRAINT fk_titles_locale FOREIGN KEY (locale) REFERENCES faker.locales(code)
);
CREATE INDEX IF NOT EXISTS idx_titles_locale ON faker.titles(locale);

-- Cities
CREATE TABLE IF NOT EXISTS faker.cities (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    name VARCHAR(200) NOT NULL,
    CONSTRAINT fk_cities_locale FOREIGN KEY (locale) REFERENCES faker.locales(code)
);
CREATE INDEX IF NOT EXISTS idx_cities_locale ON faker.cities(locale);

-- Street names
CREATE TABLE IF NOT EXISTS faker.streets (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    name VARCHAR(200) NOT NULL,
    CONSTRAINT fk_streets_locale FOREIGN KEY (locale) REFERENCES faker.locales(code)
);
CREATE INDEX IF NOT EXISTS idx_streets_locale ON faker.streets(locale);

-- Street suffixes (Street, Avenue, Road, etc.)
CREATE TABLE IF NOT EXISTS faker.street_suffixes (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    suffix VARCHAR(50) NOT NULL,
    CONSTRAINT fk_street_suffixes_locale FOREIGN KEY (locale) REFERENCES faker.locales(code)
);
CREATE INDEX IF NOT EXISTS idx_street_suffixes_locale ON faker.street_suffixes(locale);

-- States/Regions
CREATE TABLE IF NOT EXISTS faker.states (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    name VARCHAR(100) NOT NULL,
    abbreviation VARCHAR(10),
    CONSTRAINT fk_states_locale FOREIGN KEY (locale) REFERENCES faker.locales(code)
);
CREATE INDEX IF NOT EXISTS idx_states_locale ON faker.states(locale);

-- Postal code formats
CREATE TABLE IF NOT EXISTS faker.postal_formats (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    format VARCHAR(20) NOT NULL,  -- e.g., '#####' for USA, '##### ' for Germany
    CONSTRAINT fk_postal_formats_locale FOREIGN KEY (locale) REFERENCES faker.locales(code)
);
CREATE INDEX IF NOT EXISTS idx_postal_formats_locale ON faker.postal_formats(locale);

-- Phone number formats
CREATE TABLE IF NOT EXISTS faker.phone_formats (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    format VARCHAR(50) NOT NULL,  -- e.g., '(###) ###-####', '+1 ### ### ####'
    CONSTRAINT fk_phone_formats_locale FOREIGN KEY (locale) REFERENCES faker.locales(code)
);
CREATE INDEX IF NOT EXISTS idx_phone_formats_locale ON faker.phone_formats(locale);

-- Email domains
CREATE TABLE IF NOT EXISTS faker.email_domains (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    domain VARCHAR(100) NOT NULL,
    CONSTRAINT fk_email_domains_locale FOREIGN KEY (locale) REFERENCES faker.locales(code)
);
CREATE INDEX IF NOT EXISTS idx_email_domains_locale ON faker.email_domains(locale);

-- Eye colors
CREATE TABLE IF NOT EXISTS faker.eye_colors (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    color VARCHAR(50) NOT NULL,
    CONSTRAINT fk_eye_colors_locale FOREIGN KEY (locale) REFERENCES faker.locales(code)
);
CREATE INDEX IF NOT EXISTS idx_eye_colors_locale ON faker.eye_colors(locale);

-- Address formats (for different address structures)
CREATE TABLE IF NOT EXISTS faker.address_formats (
    id SERIAL PRIMARY KEY,
    locale VARCHAR(10) NOT NULL,
    format VARCHAR(500) NOT NULL,  -- Template like '{street_number} {street_name}, {city}, {state} {postal}'
    CONSTRAINT fk_address_formats_locale FOREIGN KEY (locale) REFERENCES faker.locales(code)
);
CREATE INDEX IF NOT EXISTS idx_address_formats_locale ON faker.address_formats(locale);
