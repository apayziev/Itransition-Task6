# SQL Faker Library Documentation

A PostgreSQL-based library for generating fake user data with full reproducibility. All data generation is implemented as SQL stored procedures.

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Core Concepts](#core-concepts)
5. [Random Utility Functions](#random-utility-functions)
6. [Generator Functions](#generator-functions)
7. [Main Procedures](#main-procedures)
8. [High-Performance Procedures](#high-performance-procedures)
9. [Algorithms](#algorithms)
10. [Performance](#performance)
11. [Markov Chain Text Generation](#markov-chain-text-generation-optional)
12. [Extensibility](#extensibility)

---

## Overview

This library provides a "Faker" implementation entirely in SQL (PostgreSQL PL/pgSQL). Key features:

- **Reproducibility**: Same seed always produces same data
- **Locale Support**: Currently supports `en_US` and `de_DE`
- **Extensible Design**: Single tables with locale field
- **Statistical Distributions**: Normal distribution for physical attributes, uniform distribution for coordinates
- **High Performance**: Optimized version achieves **~40,000-45,000 users/second**
- **Markov Chain Text**: Locale-specific random text generation (optional feature)

---

## Installation

### Prerequisites
- PostgreSQL 12 or higher

### Setup

```bash
# Run SQL files in order
psql -U postgres -d your_database -f database/01_schema.sql
psql -U postgres -d your_database -f database/02_seed_data.sql
psql -U postgres -d your_database -f database/03_random_utils.sql
psql -U postgres -d your_database -f database/04_generators.sql
psql -U postgres -d your_database -f database/05_main_procedure.sql
psql -U postgres -d your_database -f database/06_optimized_generators.sql  # High-performance version
```

---

## Quick Start

```sql
-- Generate 10 fake users (standard)
SELECT * FROM faker.generate_users('en_US', 12345, 0, 10);

-- Generate 10 fake users (high-performance, ~28x faster)
SELECT * FROM faker.fast_generate_users('en_US', 12345, 0, 10);

-- Generate 10000 users for benchmarking (~40,000+ users/sec)
SELECT * FROM faker.fast_generate_users_batch('en_US', 12345, 10000);

-- Generate Markov chain text (optional feature)
SELECT faker.generate_bio('en_US', 42);
SELECT faker.generate_bio('de_DE', 100);
```

---

## Core Concepts

### Reproducibility

The library ensures that identical inputs always produce identical outputs:

```sql
-- These will ALWAYS return the same results
SELECT * FROM faker.fast_generate_users('en_US', 12345, 0, 10);
SELECT * FROM faker.fast_generate_users('en_US', 12345, 0, 10);
```

### Seed Computation

Each user's data is determined by:
- **Base seed**: User-provided seed value
- **Batch index**: Which batch (0-indexed)
- **Item index**: Position within batch

```
Global index = batch_index × batch_size + item_index
Computed seed = f(base_seed, global_index)
```

### Locale Support

All lookup tables include a `locale` field:

```sql
-- Same function works for different locales
SELECT faker.generate_first_name('en_US', 'M');  -- Returns: "John"
SELECT faker.generate_first_name('de_DE', 'M');  -- Returns: "Hans"
```

---

## Random Utility Functions

### `faker.seed_random(seed_value)`

Sets the random seed for reproducible results.

| Parameter | Type | Description |
|-----------|------|-------------|
| `seed_value` | DOUBLE PRECISION | Seed value (0 to 1) |

```sql
SELECT faker.seed_random(0.5);
SELECT random();  -- Always returns same value: 0.798156...
```

---

### `faker.compute_seed(base_seed, index1, index2)`

Computes a deterministic seed from multiple indices.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `base_seed` | INTEGER | - | User-provided seed |
| `index1` | INTEGER | 0 | First index (batch) |
| `index2` | INTEGER | 0 | Second index (item) |

**Algorithm**: Uses golden ratio multiplication for good distribution:
```
seed = frac((base_seed × φ + index1 × (1-φ) + index2 × 0.123456789) × 1000)
```

Where φ (phi) = 0.618033988749895 (golden ratio conjugate)

---

### `faker.random_int(min_val, max_val)`

Generates a random integer in range [min, max].

```sql
SELECT faker.seed_random(0.5);
SELECT faker.random_int(1, 100);  -- Returns: 80
```

---

### `faker.random_float(min_val, max_val)`

Generates a random float in range [min, max).

```sql
SELECT faker.seed_random(0.5);
SELECT faker.random_float(0.0, 100.0);  -- Returns: 79.8156...
```

---

### `faker.random_normal(mean, stddev)`

Generates a normally distributed random number.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `mean` | DOUBLE PRECISION | 0 | Mean of distribution |
| `stddev` | DOUBLE PRECISION | 1 | Standard deviation |

**Algorithm**: Box-Muller Transform (see [Algorithms](#box-muller-transform))

```sql
SELECT faker.seed_random(0.5);
SELECT faker.random_normal(170, 10);  -- Height: mean 170cm, stddev 10cm
```

---

### `faker.random_boolean(probability)`

Returns TRUE with given probability.

```sql
SELECT faker.seed_random(0.5);
SELECT faker.random_boolean(0.3);  -- 30% chance of TRUE
```

---

### `faker.random_element(elements)`

Selects a random element from an array.

```sql
SELECT faker.seed_random(0.5);
SELECT faker.random_element(ARRAY['a', 'b', 'c', 'd']);  -- Returns one element
```

---

### `faker.format_string(template)`

Replaces `#` with digits and `?` with letters.

```sql
SELECT faker.seed_random(0.5);
SELECT faker.format_string('###-???-####');  -- e.g., "798-abc-1234"
```

---

### `faker.random_latitude()` / `faker.random_longitude()`

Generates coordinates uniformly distributed on Earth's surface.

**Algorithm**: See [Uniform Sphere Distribution](#uniform-sphere-distribution)

```sql
SELECT faker.seed_random(0.5);
SELECT faker.random_latitude();   -- Range: -90 to 90
SELECT faker.random_longitude();  -- Range: -180 to 180
```

---

## Generator Functions

### `faker.generate_full_name(locale, include_title, include_middle)`

Generates a complete name with variations.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `locale` | VARCHAR | 'en_US' | Locale code |
| `include_title` | BOOLEAN | NULL | Include title (30% if NULL) |
| `include_middle` | BOOLEAN | NULL | Include middle name (40% if NULL) |

**Returns**: TABLE with columns:
- `full_name`, `first_name`, `middle_name`, `last_name`, `title`, `gender`

**Variations**:
- "John Smith"
- "John Michael Smith"  
- "Mr. John Smith"
- "Dr. John Michael Smith"

```sql
SELECT * FROM faker.generate_full_name('en_US', TRUE, TRUE);
```

---

### `faker.generate_address(locale)`

Generates a complete formatted address.

| Locale | Format Example |
|--------|---------------|
| `en_US` | "123 Oak Street, New York, NY 10001" |
| `de_DE` | "Hauptstraße 42, 10115 Berlin" |

```sql
SELECT faker.generate_address('en_US');
SELECT faker.generate_address('de_DE');
```

---

### `faker.generate_phone(locale)`

Generates a phone number in locale-specific format.

| Locale | Format Examples |
|--------|-----------------|
| `en_US` | "(555) 123-4567", "+1 555 123 4567" |
| `de_DE` | "+49 123 4567890", "0123/4567890" |

```sql
SELECT faker.generate_phone('en_US');
```

---

### `faker.generate_email(locale, first_name, last_name)`

Generates an email address based on name.

**Patterns**:
- `john.smith@gmail.com`
- `jsmith@yahoo.com`
- `john_smith123@hotmail.com`
- `j.smith@gmail.com`

```sql
SELECT faker.generate_email('en_US', 'John', 'Smith');
```

---

### `faker.generate_physical_attributes(locale, gender)`

Generates height, weight, and eye color using normal distribution.

| Attribute | Male (Mean ± SD) | Female (Mean ± SD) |
|-----------|------------------|-------------------|
| Height | 175 ± 8 cm | 162 ± 8 cm |
| Weight | 80 ± 12 kg | 65 ± 12 kg |

```sql
SELECT * FROM faker.generate_physical_attributes('en_US', 'M');
```

---

## Main Procedures

### `faker.generate_user(locale, seed, index)`

Generates a single complete user.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `locale` | VARCHAR | 'en_US' | Locale code |
| `seed` | INTEGER | 12345 | Base seed |
| `index` | INTEGER | 0 | User index |

**Returns**: Complete user record with all fields.

---

### `faker.generate_users(locale, seed, batch_index, batch_size)`

Generates a batch of users (main function for the web app).

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `locale` | VARCHAR | 'en_US' | Locale code |
| `seed` | INTEGER | 12345 | Base seed |
| `batch_index` | INTEGER | 0 | Batch number (0-indexed) |
| `batch_size` | INTEGER | 10 | Users per batch |

```sql
-- First batch of 10 users
SELECT * FROM faker.generate_users('en_US', 12345, 0, 10);

-- Second batch (users 10-19)
SELECT * FROM faker.generate_users('en_US', 12345, 1, 10);
```

---

### `faker.generate_users_batch(locale, seed, count)`

Generates a large batch at once (for benchmarking).

```sql
SELECT * FROM faker.generate_users_batch('en_US', 12345, 10000);
```

---

## High-Performance Procedures

The library includes optimized procedures that achieve **~20x speedup** over the standard versions through several key optimizations.

### Performance Comparison

| Method | 1,000 users | 10,000 users | Speed |
|--------|-------------|--------------|-------|
| Standard (`generate_users`) | ~0.6s | ~5s | ~2,000 users/sec |
| **Optimized** (`fast_generate_users`) | ~0.05s | ~0.24s | **~40,000-45,000 users/sec** |

### `faker.fast_generate_users(locale, seed, batch_index, batch_size)`

High-performance batch user generation.

```sql
-- Generate 100 users (recommended for production)
SELECT * FROM faker.fast_generate_users('en_US', 12345, 0, 100);
```

### `faker.fast_generate_users_batch(locale, seed, count)`

High-performance bulk generation for benchmarking.

```sql
-- Generate 10,000 users
SELECT * FROM faker.fast_generate_users_batch('en_US', 12345, 10000);
```

### Optimization Techniques

#### 1. Array-Based Lookups (O(1) vs O(n))

**Problem**: Standard approach uses `OFFSET` which scans rows sequentially.

```sql
-- SLOW: OFFSET scans all rows up to the offset
SELECT name FROM faker.first_names 
WHERE locale = 'en_US' 
OFFSET random_offset LIMIT 1;  -- O(n) scan!
```

**Solution**: Pre-load data into arrays for O(1) access.

```sql
-- FAST: Array index is O(1)
SELECT ARRAY_AGG(name) INTO v_names FROM faker.first_names WHERE locale = 'en_US';
v_name := v_names[1 + (random_index % array_length(v_names, 1))];
```

#### 2. Set-Based Generation (No PL/pgSQL Loops)

**Problem**: Row-by-row loops in PL/pgSQL are slow.

```sql
-- SLOW: Loop processes one row at a time
FOR i IN 0..999 LOOP
    RETURN QUERY SELECT * FROM faker.generate_user(...);
END LOOP;
```

**Solution**: Use `generate_series()` with CTEs for set-based operations.

```sql
-- FAST: Generate all data in a single query
WITH indices AS (SELECT generate_series(0, 999) AS i)
SELECT ... FROM indices;
```

#### 3. Hash-Based Deterministic Randomness

**Problem**: Need reproducible random values without repeated `setseed()` calls.

**Solution**: Use `hashtext()` for fast, deterministic pseudo-random values.

```sql
-- Deterministic random per field
ABS(hashtext(user_index::text || 'firstname' || seed::text)) % count
```

#### 4. Inline Calculations

**Problem**: Function call overhead adds up for millions of values.

**Solution**: Compute values inline in the query.

```sql
-- Box-Muller transform inline
SQRT(-2.0 * LN(r.h1)) * COS(2.0 * PI() * r.h2) * stddev + mean
```

#### 5. Z-Score Lookup Table (10x Faster Normal Distribution)

**Problem**: Box-Muller transform requires expensive `SQRT()`, `LN()`, and `COS()` operations.

**Solution**: Pre-compute 100 z-score values and use array lookup.

```sql
-- Pre-computed z-scores from -2.576 to +2.576 (99% of normal distribution)
CREATE TABLE faker.zscore_lookup (
    idx INT PRIMARY KEY,
    zscore DOUBLE PRECISION
);

-- Usage: O(1) array lookup instead of O(n) trigonometric computation
z := v_zscores[1 + (hash_val % 100)];
height := 175.0 + z * 8.0;  -- mean=175, stddev=8
```

**Benchmark**: 10x faster than Box-Muller transform.

#### 6. Latitude Lookup Table (2x Faster Sphere Distribution)

**Problem**: `ASIN()` function is expensive for uniform sphere distribution.

**Solution**: Pre-compute 100 latitude values using the arcsine projection.

```sql
-- Pre-computed latitudes for uniform sphere distribution
CREATE TABLE faker.latitude_lookup (
    idx INT PRIMARY KEY,
    latitude DOUBLE PRECISION
);

-- Values computed as: DEGREES(ASIN(2 * (i/99) - 1))
-- Maps indices 0-99 to latitudes -90° to +90° with uniform sphere distribution
```

**Benchmark**: 2x faster than inline ASIN calculation.

#### 7. Translate() for O(n) Phone Number Generation

**Problem**: Multiple REPLACE() calls create O(n×m) complexity for phone numbers.

**Solution**: Use PostgreSQL's `translate()` function for single-pass O(n) replacement.

```sql
-- SLOW: Multiple REPLACE() calls - O(n×m)
SELECT REPLACE(REPLACE(REPLACE(format, '#', d1), '#', d2), '#', d3);

-- FAST: Single translate() call - O(n)
SELECT translate(
    '(###) ###-####',
    '#######################',  -- All placeholder positions
    '5551234567890123456789'   -- All replacement digits
);
```

**Benchmark**: 15% faster than REPLACE() chain.

---

## Algorithms

### Box-Muller Transform

Used for generating normally distributed random numbers.

**Mathematical Formula**:
```
z₀ = √(-2 × ln(u₁)) × cos(2π × u₂)
z₁ = √(-2 × ln(u₁)) × sin(2π × u₂)
```

Where `u₁` and `u₂` are uniform random numbers in (0, 1).

**Result**: `result = mean + z₀ × stddev`

**Implementation**:
```sql
CREATE OR REPLACE FUNCTION faker.random_normal(mean, stddev)
RETURNS DOUBLE PRECISION AS $$
DECLARE
    u1 DOUBLE PRECISION;
    u2 DOUBLE PRECISION;
    z0 DOUBLE PRECISION;
BEGIN
    u1 := GREATEST(random(), 0.0000001);  -- Avoid ln(0)
    u2 := random();
    z0 := SQRT(-2.0 * LN(u1)) * COS(2.0 * PI() * u2);
    RETURN mean + z0 * stddev;
END;
$$ LANGUAGE plpgsql;
```

---

### Uniform Sphere Distribution

For generating coordinates uniformly distributed on Earth's surface.

**Problem**: Simple random latitude/longitude doesn't give uniform distribution because:
- Area near poles is smaller than at equator
- Equal angle increments don't equal area increments

**Solution**: Use inverse transform sampling

**Latitude** (uniform on sphere):
```
latitude = arcsin(2u - 1) × (180/π)
```
Where `u` is uniform random in [0, 1].

**Longitude** (simple uniform):
```
longitude = u × 360 - 180
```

**Implementation**:
```sql
CREATE OR REPLACE FUNCTION faker.random_latitude()
RETURNS DOUBLE PRECISION AS $$
BEGIN
    -- asin(2u - 1) gives uniform distribution on sphere
    RETURN DEGREES(ASIN(2 * random() - 1));
END;
$$ LANGUAGE plpgsql;
```

**Why this works**: The function `arcsin(2u - 1)` maps uniform [0,1] to a distribution that accounts for the spherical geometry, concentrating more samples near the equator where there's more surface area.

---

### Seed Computation

Uses golden ratio for optimal distribution:

```sql
raw_value := (base_seed × 0.618033988749895 + 
              index1 × 0.381966011250105 + 
              index2 × 0.123456789) × 1000;
RETURN raw_value - FLOOR(raw_value);  -- Fractional part
```

The golden ratio φ = (1 + √5)/2 ≈ 1.618 has the property that successive multiples are maximally spread out in the fractional part, avoiding clustering.

---

## Extensibility

### Adding a New Locale

1. Add locale to `faker.locales`:
```sql
INSERT INTO faker.locales (code, name) VALUES ('fr_FR', 'French (France)');
```

2. Add data to lookup tables:
```sql
INSERT INTO faker.first_names (locale, name, gender) VALUES
    ('fr_FR', 'Jean', 'M'),
    ('fr_FR', 'Marie', 'F'),
    -- ... more names
```

3. Add locale-specific formats:
```sql
INSERT INTO faker.phone_formats (locale, format) VALUES
    ('fr_FR', '+33 # ## ## ## ##');

INSERT INTO faker.address_formats (locale, format) VALUES
    ('fr_FR', '{street_number} {street_name}, {postal} {city}');
```

### Adding New Data Fields

1. Create generator function:
```sql
CREATE OR REPLACE FUNCTION faker.generate_company_name(p_locale VARCHAR)
RETURNS TEXT AS $$
-- Implementation
$$ LANGUAGE plpgsql;
```

2. Add to main `generate_user` function return type and implementation.

---

## Performance

### Benchmark Results (Optimized Procedures)

Tested on standard machine with PostgreSQL 14:

| Count | Time | Speed |
|-------|------|-------|
| 1,000 users | ~0.05s | ~20,000-25,000 users/sec |
| 5,000 users | ~0.14s | ~35,000-40,000 users/sec |
| 10,000 users | ~0.24s | **~40,000-45,000 users/sec** |

### Optimization Summary

| Optimization | Improvement | Technique |
|--------------|-------------|-----------|
| Array Lookups | ~5x | O(1) vs O(n) OFFSET |
| Set-Based SQL | ~3x | No PL/pgSQL loops |
| Z-Score Lookup | ~10x | Pre-computed normal distribution |
| Latitude Lookup | ~2x | Pre-computed sphere projection |
| translate() | ~15% | O(n) single-pass string replacement |
| Hash-Based Random | ~2x | Deterministic without setseed() |

### Performance Tips

1. **Use `fast_generate_users`** instead of `generate_users` for production
2. **Pre-warm the database** with a small query before large batches
3. **Index lookup tables** on the `locale` column (already done by default)
4. **Batch appropriately** - larger batches are more efficient per-user

---

## Markov Chain Text Generation (Optional)

The library includes a Markov chain text generator for producing realistic random text in multiple languages.

### Overview

Instead of "Lorem ipsum", generate natural-sounding text based on trained language patterns.

### Functions

#### `faker.generate_bio(locale, seed)`

Generates a short bio/description text.

```sql
SELECT faker.generate_bio('en_US', 42);
-- Returns: "Quality drives innovation. Our team delivers creative solutions."

SELECT faker.generate_bio('de_DE', 42);
-- Returns: "Qualität ist es Mehrwert. Wir schaffen innovative Ansätze."
```

#### `faker.blazing_fast_markov_text(locale, seed, min_words, max_words)`

High-performance Markov chain text generation with optimizations.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `locale` | VARCHAR | 'en_US' | Language code |
| `seed` | INTEGER | 42 | Seed for reproducibility |
| `min_words` | INTEGER | 5 | Minimum words before allowing end |
| `max_words` | INTEGER | 15 | Maximum words in output |

### Markov Chain Optimizations

The implementation includes three optimization tiers:

| Tier | Function | Speed | Technique |
|------|----------|-------|-----------|
| Basic | `fast_generate_markov_text` | Baseline | Integer word IDs |
| Ultra | `ultra_fast_markov_text` | +15% | Cumulative weights |
| Blazing | `blazing_fast_markov_text` | +28% | HSTORE O(1) lookups |

#### HSTORE Index Optimization

```sql
-- O(1) lookup using HSTORE instead of O(n) table scan
CREATE INDEX idx_markov_hstore ON faker.markov_cumulative 
USING GIN (hstore(ARRAY['word_id', word_id::text, 'locale', locale]));
```

### Training Data

| Locale | Transitions | Words |
|--------|-------------|-------|
| en_US | 230 | ~100 unique words |
| de_DE | 180 | ~90 unique words |

---

## License

MIT License - Free for personal and commercial use.
