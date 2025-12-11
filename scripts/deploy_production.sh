#!/bin/bash
# ============================================================================
# Production Deployment Script for Contabo VPS
# ============================================================================
# Run this script on your Contabo VPS to deploy the application.
# Prerequisites: Ubuntu 22.04 or similar Linux distribution
# ============================================================================

set -e

echo "=========================================="
echo "Fake User Generator - Production Setup"
echo "=========================================="

# Configuration - CHANGE THESE
APP_NAME="fake-user-generator"
APP_USER="www-data"
APP_DIR="/var/www/$APP_NAME"
DOMAIN="${DOMAIN:-}"  # Set this to your domain if you have one
DB_NAME="faker_db"
DB_USER="faker_user"
DB_PASSWORD="${DB_PASSWORD:-$(openssl rand -base64 32)}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root (sudo)"
    exit 1
fi

echo ""
echo "Step 1: System Update & Dependencies"
echo "-------------------------------------"
apt update && apt upgrade -y
apt install -y python3 python3-pip python3-venv postgresql postgresql-contrib nginx certbot python3-certbot-nginx git
print_status "System packages installed"

echo ""
echo "Step 2: PostgreSQL Setup"
echo "------------------------"
# Start PostgreSQL
systemctl start postgresql
systemctl enable postgresql

# Create database and user
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';" 2>/dev/null || print_warning "User already exists"
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME OWNER $DB_USER;" 2>/dev/null || print_warning "Database already exists"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"
print_status "PostgreSQL configured"

echo ""
echo "Step 3: Application Setup"
echo "-------------------------"
# Create app directory
mkdir -p $APP_DIR
cd $APP_DIR

# Clone or copy application files
# If using git:
# git clone https://github.com/yourusername/fake-user-generator.git .

# Create virtual environment
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn
print_status "Python environment ready"

# Run database migrations
export PGPASSWORD=$DB_PASSWORD
for sql_file in database/*.sql; do
    if [ -f "$sql_file" ]; then
        psql -h localhost -U $DB_USER -d $DB_NAME -f "$sql_file"
    fi
done
print_status "Database migrations complete"

# Create .env file
cat > .env << EOF
FLASK_ENV=production
FLASK_DEBUG=0
SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))")
DATABASE_URL=postgresql://$DB_USER:$DB_PASSWORD@localhost:5432/$DB_NAME
EOF
print_status "Environment configured"

# Set permissions
chown -R $APP_USER:$APP_USER $APP_DIR

echo ""
echo "Step 4: Gunicorn Service"
echo "------------------------"
cat > /etc/systemd/system/$APP_NAME.service << EOF
[Unit]
Description=Fake User Generator
After=network.target postgresql.service

[Service]
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$APP_DIR
Environment="PATH=$APP_DIR/venv/bin"
ExecStart=$APP_DIR/venv/bin/gunicorn --workers 4 --bind unix:$APP_DIR/$APP_NAME.sock run:app

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl start $APP_NAME
systemctl enable $APP_NAME
print_status "Gunicorn service configured"

echo ""
echo "Step 5: Nginx Configuration"
echo "---------------------------"

if [ -n "$DOMAIN" ]; then
    SERVER_NAME="server_name $DOMAIN www.$DOMAIN;"
else
    SERVER_NAME="server_name _;"
fi

cat > /etc/nginx/sites-available/$APP_NAME << EOF
server {
    listen 80;
    $SERVER_NAME

    location / {
        proxy_pass http://unix:$APP_DIR/$APP_NAME.sock;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    location /static {
        alias $APP_DIR/static;
        expires 30d;
    }
}
EOF

ln -sf /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t && systemctl restart nginx
print_status "Nginx configured"

echo ""
echo "Step 6: Firewall"
echo "----------------"
ufw allow 'Nginx Full'
ufw allow OpenSSH
ufw --force enable
print_status "Firewall configured"

# SSL Certificate (if domain provided)
if [ -n "$DOMAIN" ]; then
    echo ""
    echo "Step 7: SSL Certificate"
    echo "-----------------------"
    certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos -m admin@$DOMAIN
    print_status "SSL certificate installed"
fi

echo ""
echo "=========================================="
echo -e "${GREEN}Deployment complete!${NC}"
echo "=========================================="
echo ""
if [ -n "$DOMAIN" ]; then
    echo "Your application is available at: https://$DOMAIN"
else
    echo "Your application is available at: http://YOUR_SERVER_IP"
fi
echo ""
echo "Database credentials:"
echo "  User: $DB_USER"
echo "  Password: $DB_PASSWORD"
echo ""
echo "Useful commands:"
echo "  sudo systemctl status $APP_NAME    # Check app status"
echo "  sudo systemctl restart $APP_NAME   # Restart app"
echo "  sudo journalctl -u $APP_NAME -f    # View logs"
echo ""
