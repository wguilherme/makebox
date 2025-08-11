#!/bin/bash
# Advanced Docker cleanup script
# Usage: ./docker-cleanup.sh [--dry-run] [--days=7]

DRY_RUN=false
DAYS=7
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --days=*)
            DAYS="${arg#*=}"
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [--dry-run] [--days=N]"
            echo "  --dry-run    Show what would be cleaned without actually doing it"
            echo "  --days=N     Clean images older than N days (default: 7)"
            exit 0
            ;;
    esac
done

echo -e "${BLUE}🐳 Docker Cleanup Script${NC}"
echo "========================="

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}🔍 DRY RUN MODE - No changes will be made${NC}"
fi

echo -e "${BLUE}📊 Current Docker usage:${NC}"
docker system df

echo -e "\n${BLUE}🗂️  Images older than $DAYS days:${NC}"
old_images=$(docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.CreatedAt}}\t{{.Size}}" --filter "until=$(date -d "$DAYS days ago" +%Y-%m-%d)" 2>/dev/null)

if [ -n "$old_images" ]; then
    echo "$old_images"
    
    if [ "$DRY_RUN" = false ]; then
        echo -e "\n${YELLOW}⚠️  Remove these old images? (y/N)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            docker image prune -f --filter "until=$(date -d "$DAYS days ago" +%Y-%m-%d)"
            echo -e "${GREEN}✅ Old images removed${NC}"
        fi
    fi
else
    echo -e "${GREEN}✅ No old images found${NC}"
fi

echo -e "\n${BLUE}🏗️  Unused build cache:${NC}"
build_cache=$(docker builder du 2>/dev/null | tail -n +2)
if [ -n "$build_cache" ]; then
    echo "$build_cache"
    
    if [ "$DRY_RUN" = false ]; then
        echo -e "\n${YELLOW}⚠️  Clear build cache? (y/N)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            docker builder prune -f
            echo -e "${GREEN}✅ Build cache cleared${NC}"
        fi
    fi
else
    echo -e "${GREEN}✅ No build cache to clear${NC}"
fi

echo -e "\n${BLUE}📦 Unused volumes:${NC}"
unused_volumes=$(docker volume ls -qf dangling=true)
if [ -n "$unused_volumes" ]; then
    docker volume ls -f dangling=true
    
    if [ "$DRY_RUN" = false ]; then
        echo -e "\n${YELLOW}⚠️  Remove unused volumes? (y/N)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            docker volume prune -f
            echo -e "${GREEN}✅ Unused volumes removed${NC}"
        fi
    fi
else
    echo -e "${GREEN}✅ No unused volumes found${NC}"
fi

echo -e "\n${BLUE}🌐 Unused networks:${NC}"
unused_networks=$(docker network ls -qf dangling=true)
if [ -n "$unused_networks" ]; then
    docker network ls -f dangling=true
    
    if [ "$DRY_RUN" = false ]; then
        echo -e "\n${YELLOW}⚠️  Remove unused networks? (y/N)${NC}"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            docker network prune -f
            echo -e "${GREEN}✅ Unused networks removed${NC}"
        fi
    fi
else
    echo -e "${GREEN}✅ No unused networks found${NC}"
fi

if [ "$DRY_RUN" = false ]; then
    echo -e "\n${BLUE}📊 Docker usage after cleanup:${NC}"
    docker system df
fi

echo -e "\n${GREEN}✅ Docker cleanup completed${NC}"