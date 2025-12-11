#!/bin/bash
# Deployment script for Contabo/VPS server
# Usage: sudo ./scripts/deploy.sh

set -e

echo "🚀 Deploying Fake User Generator..."
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run as root: sudo ./scripts/deploy.sh"
    exit 1
fi

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "📦 Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
    echo "✅ Docker installed"
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    echo "📦 Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose installed"
fi

# Generate .env file with secure passwords
if [ ! -f .env ]; then
    echo "📝 Creating .env file with secure passwords..."
    DB_PASS=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32)
    SECRET=$(openssl rand -base64 48 | tr -dc 'a-zA-Z0-9' | head -c 64)
    cat > .env << EOF
DB_PASSWORD=$DB_PASS
SECRET_KEY=$SECRET
EOF
    echo "✅ Generated .env file"
fi

# Build and start
echo "🔨 Building and starting containers..."
docker-compose down 2>/dev/null || true
docker-compose build
docker-compose up -d

# Wait for services
echo "⏳ Waiting for services to start..."
sleep 15

# Show status
echo ""
echo "=========================================="
echo "✅ Deployment complete!"
echo "=========================================="
docker-compose ps
echo ""
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || echo "YOUR_SERVER_IP")
echo "🌐 App running at: http://$SERVER_IP"
echo ""
echo "📋 Commands:"
echo "  docker-compose logs -f        # View logs"
echo "  docker-compose restart        # Restart"
echo "  docker-compose down           # Stop"
echo "  git pull && docker-compose up -d --build  # Update"
