#!/bin/bash

# Bibha AI Automation Studio - Final Build Script
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}🎨 BIBHA AI AUTOMATION STUDIO${NC}"
echo -e "${GREEN}   Final Theme Build & Deploy${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""

# Stop existing container
echo -e "${BLUE}🧹 Stopping existing containers...${NC}"
docker stop bibha-arm64 2>/dev/null || true
docker rm bibha-arm64 2>/dev/null || true

# Create final Dockerfile
cat > Dockerfile.bibha-final << 'EOF'
# Bibha AI Automation Studio - Final ARM64 Docker Image
FROM --platform=linux/arm64 n8nio/n8n:latest

USER root

# Install tools for file replacement
RUN apk add --no-cache rsync

# Copy our themed frontend build files
COPY packages/frontend/editor-ui/dist /tmp/editor-ui/
COPY packages/frontend/@n8n/design-system/dist /tmp/design-system/

# Replace n8n frontend with Bibha themed version
RUN echo "🎨 Applying Bibha AI theme..." && \
    # Replace editor-ui
    EDITOR_UI_PATH="/usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-editor-ui@file+packages+frontend+editor-ui/node_modules/n8n-editor-ui/dist" && \
    if [ -d "$EDITOR_UI_PATH" ]; then \
        echo "Found editor-ui at: $EDITOR_UI_PATH" && \
        rm -rf "$EDITOR_UI_PATH"/* && \
        cp -r /tmp/editor-ui/* "$EDITOR_UI_PATH/" && \
        echo "✅ Editor UI replaced with Bibha theme"; \
    fi && \
    # Find and replace design-system
    find /usr/local/lib/node_modules/n8n -path "*/@n8n+design-system*/dist" -type d | while read dir; do \
        echo "Replacing design-system at: $dir" && \
        rm -rf "$dir"/* && \
        cp -r /tmp/design-system/* "$dir/" && \
        echo "✅ Design system replaced"; \
    done && \
    # Also check for design-system in root node_modules
    if [ -d "/usr/local/lib/node_modules/@n8n/design-system/dist" ]; then \
        echo "Also found design-system at root level" && \
        rm -rf /usr/local/lib/node_modules/@n8n/design-system/dist/* && \
        cp -r /tmp/design-system/* /usr/local/lib/node_modules/@n8n/design-system/dist/ && \
        echo "✅ Root design-system replaced"; \
    fi && \
    # Clean up
    rm -rf /tmp/editor-ui /tmp/design-system && \
    # Fix permissions
    chown -R node:node /usr/local/lib/node_modules

USER node

ENV N8N_PORT=5678
ENV N8N_DIAGNOSTICS_ENABLED=false
ENV N8N_PERSONALIZATION_ENABLED=false

EXPOSE 5678

LABEL org.opencontainers.image.title="Bibha AI Automation Studio"
LABEL org.opencontainers.image.description="Workflow automation platform with Bibha AI green theme"
LABEL org.opencontainers.image.vendor="Bibha Digital"
EOF

# Use custom dockerignore
mv .dockerignore .dockerignore.backup 2>/dev/null || true
cp .dockerignore.bibha .dockerignore 2>/dev/null || true

# Build Docker image
echo -e "${BLUE}🐳 Building Docker image with Bibha theme...${NC}"
docker build \
    --platform linux/arm64 \
    -t bibha-final:latest \
    -f Dockerfile.bibha-final \
    . || {
    echo -e "${RED}❌ Docker build failed!${NC}"
    mv .dockerignore.backup .dockerignore 2>/dev/null || true
    exit 1
}

# Restore dockerignore
mv .dockerignore.backup .dockerignore 2>/dev/null || true

echo -e "${GREEN}✅ Docker image built${NC}"

# Run container
echo -e "${BLUE}🚀 Starting Bibha AI Automation Studio...${NC}"
docker run -d \
    --name bibha-final \
    --platform linux/arm64 \
    -p 5678:5678 \
    -v ~/.n8n:/home/node/.n8n \
    --restart unless-stopped \
    bibha-final:latest

# Wait for startup
echo -e "${YELLOW}⏳ Waiting for application to start...${NC}"
for i in {1..30}; do
    if curl -s http://localhost:5678 > /dev/null 2>&1; then
        echo ""
        echo -e "${GREEN}✅ Application started!${NC}"
        break
    fi
    echo -n "."
    sleep 2
done

# Verify theme
echo ""
echo -e "${BLUE}🔍 Verifying theme application...${NC}"
docker exec bibha-final sh -c "ls -la /usr/local/lib/node_modules/n8n/node_modules/.pnpm/n8n-editor-ui*/node_modules/n8n-editor-ui/dist | head -5" && echo -e "${GREEN}✅ Editor UI files in place${NC}"

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}✅ BIBHA AI AUTOMATION STUDIO DEPLOYED!${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo -e "${PURPLE}🌐 Access the application at:${NC} http://localhost:5678"
echo ""
echo -e "${GREEN}The theme should now show:${NC}"
echo -e "  ✅ Green buttons and UI elements (#00A76F)"
echo -e "  ✅ Bibha AI branding and logo"
echo -e "  ✅ Title: Bibha AI Automation Studio"
echo ""
echo -e "${BLUE}Commands:${NC}"
echo -e "  View logs:  docker logs -f bibha-final"
echo -e "  Stop:       docker stop bibha-final"
echo -e "  Restart:    docker restart bibha-final"
echo ""
echo -e "${GREEN}================================================${NC}"