#!/bin/bash
# ============================================================================
# Local Development Setup Script
# ============================================================================
# This script sets up the local development environment.
# Prerequisites: PostgreSQL installed and running
# ============================================================================

set -e  # Exit on error

echo "=========================================="
echo "Fake User Generator - Local Setup"
echo "=========================================="

# Configuration
DB_NAME="${DB_NAME:-faker_db}"
DB_USER="${DB_USER:-postgres}"
DB_PASSWORD="${DB_PASSWORD:-postgres}"
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Check if PostgreSQL is running
echo ""
echo "Checking PostgreSQL connection..."
if ! pg_isready -h $DB_HOST -p $DB_PORT > /dev/null 2>&1; then
    print_error "PostgreSQL is not running on $DB_HOST:$DB_PORT"
    echo "Please start PostgreSQL and try again."
    exit 1
fi
print_status "PostgreSQL is running"

# Create database if it doesn't exist
echo ""
echo "Setting up database..."
if PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -lqt | cut -d \| -f 1 | grep -qw $DB_NAME; then
    print_warning "Database '$DB_NAME' already exists"
else
    PGPASSWORD=$DB_PASSWORD createdb -h $DB_HOST -p $DB_PORT -U $DB_USER $DB_NAME
    print_status "Created database '$DB_NAME'"
fi

# Run SQL scripts in order
echo ""
echo "Running database migrations..."

SQL_DIR="$(dirname "$0")/../database"

for sql_file in "$SQL_DIR"/*.sql; do
    if [ -f "$sql_file" ]; then
        filename=$(basename "$sql_file")
        echo "  Running $filename..."
        PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$sql_file" > /dev/null 2>&1
        print_status "  $filename completed"
    fi
done

# Create Python virtual environment
echo ""
echo "Setting up Python environment..."

VENV_DIR="$(dirname "$0")/../venv"

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
    print_status "Created virtual environment"
else
    print_warning "Virtual environment already exists"
fi

# Activate and install dependencies
source "$VENV_DIR/bin/activate"
pip install --quiet --upgrade pip
pip install --quiet -r "$(dirname "$0")/../requirements.txt"
print_status "Installed Python dependencies"

# Create .env file if it doesn't exist
ENV_FILE="$(dirname "$0")/../.env"
if [ ! -f "$ENV_FILE" ]; then
    cat > "$ENV_FILE" << EOF
# Environment Configuration
FLASK_ENV=development
FLASK_DEBUG=1
SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))")
DATABASE_URL=postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME
EOF
    print_status "Created .env file"
else
    print_warning ".env file already exists"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}Setup complete!${NC}"
echo "=========================================="
echo ""
echo "To start the application:"
echo "  1. Activate virtual environment: source venv/bin/activate"
echo "  2. Run the app: python run.py"
echo "  3. Open http://localhost:5000 in your browser"
echo ""
