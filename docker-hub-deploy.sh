#!/bin/bash

# Bibha AI Automation Studio - Docker Hub Deployment Script
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Docker Hub Configuration
DOCKER_HUB_REPO="bibhaadmin8888/bibha-automation"
NEW_TAG="1.112.0"  # New version tag
LATEST_TAG="latest"

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}🐳 BIBHA AI AUTOMATION STUDIO${NC}"
echo -e "${GREEN}   Docker Hub Build & Push Script${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo -e "${CYAN}Repository: ${DOCKER_HUB_REPO}${NC}"
echo -e "${CYAN}New Tag: ${NEW_TAG}${NC}"
echo ""

# Check if user is logged into Docker Hub
echo -e "${BLUE}🔐 Checking Docker Hub login status...${NC}"
if ! docker info 2>/dev/null | grep -q "Username"; then
    echo -e "${YELLOW}⚠️  Not logged into Docker Hub${NC}"
    echo -e "${BLUE}Please login to Docker Hub:${NC}"
    docker login
fi

# Tag the existing image for Docker Hub
echo -e "${BLUE}🏷️  Tagging image for Docker Hub...${NC}"
docker tag bibha-final:latest ${DOCKER_HUB_REPO}:${NEW_TAG}
docker tag bibha-final:latest ${DOCKER_HUB_REPO}:${LATEST_TAG}

echo -e "${GREEN}✅ Images tagged successfully${NC}"
echo ""
echo -e "${PURPLE}Tagged images:${NC}"
echo "  - ${DOCKER_HUB_REPO}:${NEW_TAG}"
echo "  - ${DOCKER_HUB_REPO}:${LATEST_TAG}"

# Show the images
echo ""
docker images | grep ${DOCKER_HUB_REPO}

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}📤 READY TO PUSH TO DOCKER HUB${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo -e "${BLUE}To push to Docker Hub, run:${NC}"
echo ""
echo -e "${YELLOW}docker push ${DOCKER_HUB_REPO}:${NEW_TAG}${NC}"
echo -e "${YELLOW}docker push ${DOCKER_HUB_REPO}:${LATEST_TAG}${NC}"
echo ""
echo -e "${PURPLE}For AWS EKS deployment:${NC}"
echo -e "1. Update your Kubernetes deployment YAML:"
echo -e "   ${CYAN}image: ${DOCKER_HUB_REPO}:${NEW_TAG}${NC}"
echo ""
echo -e "2. Or use kubectl to update the image:"
echo -e "   ${CYAN}kubectl set image deployment/n8n n8n=${DOCKER_HUB_REPO}:${NEW_TAG}${NC}"
echo ""
echo -e "${GREEN}================================================${NC}"