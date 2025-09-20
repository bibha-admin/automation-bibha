#!/bin/bash

# Bibha AI - Docker Build Script
set -e

echo "================================================"
echo "🐳 Creating Bibha AI Docker Image"
echo "================================================"

# Create Dockerfile
cat > Dockerfile.bibha << 'DOCKERFILE'
FROM node:20-alpine AS builder

RUN apk add --no-cache git python3 make g++ bash

WORKDIR /app
COPY . .

RUN npm install -g pnpm && \
    pnpm install && \
    pnpm build

FROM node:20-alpine

RUN apk add --no-cache git graphicsmagick tzdata tini

WORKDIR /app

COPY --from=builder /app/packages /app/packages
COPY --from=builder /app/node_modules /app/node_modules
COPY --from=builder /app/package.json /app/package.json

ENV N8N_PORT=5678
ENV NODE_ENV=production

EXPOSE 5678

ENTRYPOINT ["tini", "--"]
CMD ["node", "packages/cli/bin/n8n"]
DOCKERFILE

# Build Docker image
docker build -t bibha-automation:fork -f Dockerfile.bibha .

echo "✅ Docker image created: bibha-automation:fork"
echo ""
echo "Run with:"
echo "docker run -d --name bibha-fork -p 5678:5678 -v ~/.n8n:/home/node/.n8n bibha-automation:fork"
