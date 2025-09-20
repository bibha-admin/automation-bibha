#!/bin/bash

# Bibha AI - Build Script
set -e

echo "================================================"
echo "🔨 Building Bibha AI Automation Studio"
echo "================================================"

# Install dependencies
echo "📦 Installing dependencies..."
npm install -g pnpm
pnpm install

# Build
echo "🔨 Building..."
pnpm build

echo "✅ Build complete!"
echo ""
echo "To create Docker image, run:"
echo "./dockerize-bibha.sh"
