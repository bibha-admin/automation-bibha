#!/bin/bash

# Bibha AI Automation Studio - Push to Docker Hub
set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
DOCKER_HUB_REPO="bibhaadmin8888/bibha-automation"
NEW_TAG="1.112.0"
LATEST_TAG="latest"

echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}🚀 PUSHING BIBHA AI TO DOCKER HUB${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""

# Push the new version tag
echo -e "${BLUE}📤 Pushing ${DOCKER_HUB_REPO}:${NEW_TAG}...${NC}"
docker push ${DOCKER_HUB_REPO}:${NEW_TAG} || {
    echo -e "${RED}❌ Failed to push ${NEW_TAG}${NC}"
    exit 1
}
echo -e "${GREEN}✅ Successfully pushed ${NEW_TAG}${NC}"

# Push the latest tag
echo -e "${BLUE}📤 Pushing ${DOCKER_HUB_REPO}:${LATEST_TAG}...${NC}"
docker push ${DOCKER_HUB_REPO}:${LATEST_TAG} || {
    echo -e "${RED}❌ Failed to push ${LATEST_TAG}${NC}"
    exit 1
}
echo -e "${GREEN}✅ Successfully pushed ${LATEST_TAG}${NC}"

echo ""
echo -e "${GREEN}================================================${NC}"
echo -e "${GREEN}✅ DOCKER HUB PUSH COMPLETE!${NC}"
echo -e "${GREEN}================================================${NC}"
echo ""
echo -e "${PURPLE}🐳 Published Images:${NC}"
echo -e "   ${CYAN}${DOCKER_HUB_REPO}:${NEW_TAG}${NC}"
echo -e "   ${CYAN}${DOCKER_HUB_REPO}:${LATEST_TAG}${NC}"
echo ""
echo -e "${BLUE}🌐 View on Docker Hub:${NC}"
echo -e "   https://hub.docker.com/r/${DOCKER_HUB_REPO}/tags"
echo ""
echo -e "${GREEN}================================================${NC}"