#!/bin/bash

echo "☢️  Welcome to Docker Nuke Mode: nuclear.sh by Utsav☢️"
echo "--------------------------------------------"
echo ""
echo "⚠️  WARNING: This script will COMPLETELY WIPE your Docker environment!"
echo ""
echo "This script will:"
echo "  • Stop ALL running Docker containers"
echo "  • Delete ALL Docker containers (including stopped ones)"
echo "  • Delete ALL Docker images"
echo "  • Delete ALL Docker volumes (including data volumes)"
echo "  • Delete ALL user-defined Docker networks"
echo "  • Clear ALL Docker build cache"
echo ""
echo "🚨 THIS ACTION IS IRREVERSIBLE! 🚨"
echo "All your Docker data, images, and containers will be permanently deleted."
echo ""
read -p "Are you absolutely sure you want to proceed? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Operation cancelled. Your Docker environment is safe."
    exit 0
fi

echo ""
echo "Starting nuclear cleanup..."
echo "--------------------------------------------"
sleep 1

# Stop all running containers
echo "🛑 Stopping all running containers..."
docker stop $(docker ps -q) 2>/dev/null

# Remove all containers
echo "🗑 Removing all containers..."
docker rm -f $(docker ps -aq) 2>/dev/null

# Remove all images
echo "🎨 Removing all images..."
docker rmi -f $(docker images -aq) 2>/dev/null

# Remove all volumes
echo "📦 Removing all volumes..."
docker volume rm -f $(docker volume ls -q) 2>/dev/null

# Remove all non-default networks
echo "🌐 Removing all user-defined networks..."
docker network ls --format '{{.Name}}' \
  | grep -v -E 'bridge|host|none' \
  | xargs -r -n 1 docker network rm 2>/dev/null

# Prune builder cache
echo "🧹 Cleaning up build cache..."
docker builder prune -a -f

# Show system df to celebrate your newfound disk space
echo "📊 Space after cleanup:"
docker system df

echo "✅ Docker is now squeaky clean. Feels fresh, huh? ✨"
