#!/bin/bash
# Quick deployment script for Contabo server
# Run this on your server after cloning the repository

set -e

echo "🚀 Deploying Fake User Generator..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "📦 Installing Docker..."
    curl -fsSL https://get.docker.com | sh
    systemctl enable docker
    systemctl start docker
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "📦 Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Create .env file if not exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    DB_PASS=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 32)
    SECRET=$(openssl rand -base64 48 | tr -dc 'a-zA-Z0-9' | head -c 64)
    cat > .env << EOF
DB_PASSWORD=$DB_PASS
SECRET_KEY=$SECRET
EOF
    echo "✅ Generated secure passwords in .env"
fi

# Build and start containers
echo "🔨 Building and starting containers..."
docker-compose down 2>/dev/null || true
docker-compose build --no-cache
docker-compose up -d

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 10

# Show status
echo ""
echo "✅ Deployment complete!"
echo ""
docker-compose ps
echo ""
echo "🌐 Your app is now running at: http://$(curl -s ifconfig.me):80"
echo ""
echo "📋 Useful commands:"
echo "  docker-compose logs -f      # View logs"
echo "  docker-compose restart      # Restart services"
echo "  docker-compose down         # Stop services"
echo "  docker-compose pull && docker-compose up -d  # Update"
