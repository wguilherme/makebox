#!/bin/bash
# Git repository health checker
# Usage: ./git-repo-health.sh [projects_directory]

PROJECTS_DIR=${1:-"$HOME/git"}
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🏥 Git Repository Health Check${NC}"
echo "=================================="

if [ ! -d "$PROJECTS_DIR" ]; then
    echo -e "${RED}❌ Projects directory not found: $PROJECTS_DIR${NC}"
    exit 1
fi

total_repos=0
clean_repos=0
dirty_repos=0
behind_repos=0
ahead_repos=0

# Find all git repositories
while IFS= read -r -d '' git_dir; do
    repo_path=$(dirname "$git_dir")
    cd "$repo_path" || continue
    
    total_repos=$((total_repos + 1))
    repo_name=$(basename "$repo_path")
    
    echo -e "\n${BLUE}📁 $repo_name${NC} ($(pwd))"
    
    # Check if repository is clean
    if [ -z "$(git status --porcelain)" ]; then
        echo -e "  ${GREEN}✅ Working tree clean${NC}"
        clean_repos=$((clean_repos + 1))
    else
        echo -e "  ${YELLOW}⚠️  Working tree dirty:${NC}"
        git status --porcelain | head -5 | sed 's/^/    /'
        dirty_repos=$((dirty_repos + 1))
    fi
    
    # Check current branch
    current_branch=$(git branch --show-current)
    echo -e "  🌿 Branch: ${YELLOW}$current_branch${NC}"
    
    # Check if behind/ahead of remote
    if git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
        ahead=$(git rev-list --count HEAD..@{u})
        behind=$(git rev-list --count @{u}..HEAD)
        
        if [ "$ahead" -gt 0 ]; then
            echo -e "  ${RED}⬇️  $ahead commits behind remote${NC}"
            behind_repos=$((behind_repos + 1))
        fi
        
        if [ "$behind" -gt 0 ]; then
            echo -e "  ${GREEN}⬆️  $behind commits ahead of remote${NC}"
            ahead_repos=$((ahead_repos + 1))
        fi
        
        if [ "$ahead" -eq 0 ] && [ "$behind" -eq 0 ]; then
            echo -e "  ${GREEN}✅ Up to date with remote${NC}"
        fi
    else
        echo -e "  ${YELLOW}⚠️  No upstream branch set${NC}"
    fi
    
    # Show last commit
    last_commit=$(git log -1 --pretty=format:"%h %s (%cr)" 2>/dev/null)
    echo -e "  📝 Last: $last_commit"
    
done < <(find "$PROJECTS_DIR" -name ".git" -type d -print0)

# Summary
echo -e "\n${BLUE}📊 Summary${NC}"
echo "============"
echo -e "Total repositories: ${BLUE}$total_repos${NC}"
echo -e "Clean repositories: ${GREEN}$clean_repos${NC}"
echo -e "Dirty repositories: ${YELLOW}$dirty_repos${NC}"
echo -e "Behind remote: ${RED}$behind_repos${NC}"
echo -e "Ahead of remote: ${GREEN}$ahead_repos${NC}"

if [ "$dirty_repos" -gt 0 ]; then
    echo -e "\n${YELLOW}💡 Suggestion: Run 'gmake git-stash-all' to stash uncommitted changes${NC}"
fi

if [ "$behind_repos" -gt 0 ]; then
    echo -e "${YELLOW}💡 Suggestion: Run 'gmake git-pull-all' to update repositories${NC}"
fi