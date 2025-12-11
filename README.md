# Fake User Generator

A web application that generates random, fake user contact information using PostgreSQL stored procedures.

## Features

- 🌍 **Multi-locale support**: English (USA) and German (Germany)
- 🎲 **Reproducible generation**: Same seed always produces same data
- 📊 **Statistical distributions**: Normal distribution for physical attributes, uniform on sphere for coordinates
- 🚀 **High performance**: ~40,000+ users/second with optimized procedures
- 📝 **Complete user profiles**: Name, address, email, phone, coordinates, physical attributes
- 🔗 **Markov chain text**: Locale-specific random text generation

## Tech Stack

- **Backend**: Python + Flask
- **Database**: PostgreSQL
- **Frontend**: Jinja2 Templates + CSS

## Quick Start

### Prerequisites

- Python 3.8+
- PostgreSQL 12+

### Local Development

```bash
# Clone the repository
git clone https://github.com/yourusername/fake-user-generator.git
cd fake-user-generator

# Run setup script
chmod +x scripts/setup_local.sh
./scripts/setup_local.sh

# Start the application
source venv/bin/activate
python run.py
```

Open http://localhost:5000 in your browser.

### Manual Setup

1. Create database and run migrations:
```bash
createdb faker_db
psql -d faker_db -f database/01_schema.sql
psql -d faker_db -f database/02_seed_data.sql
psql -d faker_db -f database/03_random_utils.sql
psql -d faker_db -f database/04_generators.sql
psql -d faker_db -f database/05_main_procedure.sql
```

2. Install Python dependencies:
```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

3. Configure environment:
```bash
cp .env.example .env
# Edit .env with your database credentials
```

4. Run the application:
```bash
python run.py
```

## Project Structure

```
fake-user-generator/
├── app/
│   ├── __init__.py
│   ├── database.py      # Database connection utilities
│   ├── factory.py       # Flask app factory
│   └── routes.py        # API routes
├── database/
│   ├── 01_schema.sql    # Table definitions
│   ├── 02_seed_data.sql # Lookup data
│   ├── 03_random_utils.sql   # Random functions
│   ├── 04_generators.sql     # Data generators
│   ├── 05_main_procedure.sql # Main procedure
│   ├── 06_optimized_generators.sql # High-performance version
│   └── 07_markov_chain.sql   # Markov text generation
├── templates/
│   ├── base.html
│   └── index.html
├── static/
│   └── css/style.css
├── scripts/
│   ├── setup_local.sh
│   ├── deploy_production.sh
│   └── benchmark.py
├── docs/
│   └── STORED_PROCEDURES.md
├── config.py
├── run.py
├── requirements.txt
└── README.md
```

## Usage

### Web Interface

1. Select a locale (English/USA or German/Germany)
2. Enter a seed value for reproducibility
3. Choose batch size (10, 20, 50, or 100)
4. Click "Generate" to create users
5. Use "Next Batch" / "Previous Batch" to navigate

### API

```bash
# Generate users via API
curl -X POST http://localhost:5000/api/generate \
  -H "Content-Type: application/json" \
  -d '{"locale": "en_US", "seed": 12345, "batch_index": 0, "batch_size": 10}'

# Run benchmark
curl -X POST http://localhost:5000/api/benchmark \
  -H "Content-Type: application/json" \
  -d '{"locale": "en_US", "seed": 12345, "count": 1000}'
```

### Direct SQL

```sql
-- Generate 10 users (high-performance)
SELECT * FROM faker.fast_generate_users('en_US', 12345, 0, 10);

-- Bulk generation for benchmarking
SELECT * FROM faker.fast_generate_users_batch('en_US', 12345, 10000);

-- Generate Markov chain text
SELECT faker.generate_bio('en_US', 42);
```

## Generated Data

Each user includes:

| Field | Description |
|-------|-------------|
| `full_name` | Full name with optional title/middle name |
| `first_name` | First name |
| `middle_name` | Middle name (optional) |
| `last_name` | Last name |
| `email` | Email address |
| `phone` | Phone number (locale-formatted) |
| `address` | Full address (locale-formatted) |
| `latitude` | Geographic latitude (-90 to 90) |
| `longitude` | Geographic longitude (-180 to 180) |
| `height_cm` | Height in centimeters (normal distribution) |
| `weight_kg` | Weight in kilograms (normal distribution) |
| `eye_color` | Eye color |

## Benchmarking

```bash
# Run benchmark script
python scripts/benchmark.py --count 1000 --locale en_US --runs 3
```

## Documentation

See [docs/STORED_PROCEDURES.md](docs/STORED_PROCEDURES.md) for detailed documentation of all stored procedures and algorithms.

## Deployment

### Production (Contabo VPS)

```bash
# On your VPS
sudo ./scripts/deploy_production.sh
```

See the deployment script for detailed setup instructions.

## License

MIT License
