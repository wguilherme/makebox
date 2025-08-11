#!/bin/bash
# Development environment validator
# Checks for common development tools and configurations

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🏥 Development Environment Validator${NC}"
echo "===================================="

total_checks=0
passed_checks=0
failed_checks=0
warnings=0

check_command() {
    local cmd=$1
    local description=$2
    local required=${3:-true}
    
    total_checks=$((total_checks + 1))
    
    if command -v "$cmd" >/dev/null 2>&1; then
        version=$($cmd --version 2>/dev/null | head -1 || echo "version unknown")
        echo -e "${GREEN}✅ $description${NC} ($version)"
        passed_checks=$((passed_checks + 1))
    else
        if [ "$required" = true ]; then
            echo -e "${RED}❌ $description not found${NC}"
            failed_checks=$((failed_checks + 1))
        else
            echo -e "${YELLOW}⚠️  $description not found (optional)${NC}"
            warnings=$((warnings + 1))
        fi
    fi
}

check_file() {
    local file=$1
    local description=$2
    local required=${3:-false}
    
    total_checks=$((total_checks + 1))
    
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $description exists${NC} ($file)"
        passed_checks=$((passed_checks + 1))
    else
        if [ "$required" = true ]; then
            echo -e "${RED}❌ $description not found${NC} ($file)"
            failed_checks=$((failed_checks + 1))
        else
            echo -e "${YELLOW}⚠️  $description not found${NC} ($file)"
            warnings=$((warnings + 1))
        fi
    fi
}

echo -e "\n${BLUE}🔧 Essential Tools${NC}"
echo "=================="
check_command "git" "Git"
check_command "curl" "cURL"
check_command "make" "Make"
check_command "vim" "Vim/Vi" false
check_command "nano" "Nano" false

echo -e "\n${BLUE}📱 Development Tools${NC}"
echo "==================="
check_command "node" "Node.js"
check_command "npm" "npm"
check_command "python3" "Python 3"
check_command "pip3" "pip3"

echo -e "\n${BLUE}🍺 Package Managers${NC}"
echo "==================="
check_command "brew" "Homebrew"
check_command "yarn" "Yarn" false
check_command "pnpm" "pnpm" false

echo -e "\n${BLUE}🐳 Containerization${NC}"
echo "=================="
check_command "docker" "Docker" false
check_command "docker-compose" "Docker Compose" false

echo -e "\n${BLUE}☁️  Cloud Tools${NC}"
echo "==============="
check_command "aws" "AWS CLI" false
check_command "gcloud" "Google Cloud CLI" false
check_command "az" "Azure CLI" false

echo -e "\n${BLUE}📝 Configuration Files${NC}"
echo "======================"
check_file "$HOME/.gitconfig" "Git configuration"
check_file "$HOME/.zshrc" "Zsh configuration"
check_file "$HOME/.bash_profile" "Bash configuration"
check_file "$HOME/.vimrc" "Vim configuration" false
check_file "$HOME/.ssh/config" "SSH configuration" false

# Check Git configuration
echo -e "\n${BLUE}🔧 Git Configuration${NC}"
echo "==================="
if command -v git >/dev/null 2>&1; then
    git_name=$(git config --global user.name 2>/dev/null)
    git_email=$(git config --global user.email 2>/dev/null)
    
    if [ -n "$git_name" ]; then
        echo -e "${GREEN}✅ Git user name set${NC}: $git_name"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${RED}❌ Git user name not set${NC}"
        echo "  Run: git config --global user.name \"Your Name\""
        failed_checks=$((failed_checks + 1))
    fi
    
    if [ -n "$git_email" ]; then
        echo -e "${GREEN}✅ Git user email set${NC}: $git_email"
        passed_checks=$((passed_checks + 1))
    else
        echo -e "${RED}❌ Git user email not set${NC}"
        echo "  Run: git config --global user.email \"your@email.com\""
        failed_checks=$((failed_checks + 1))
    fi
    
    total_checks=$((total_checks + 2))
fi

# Check SSH keys
echo -e "\n${BLUE}🔐 SSH Keys${NC}"
echo "==========="
if [ -d "$HOME/.ssh" ]; then
    ssh_keys=$(ls "$HOME"/.ssh/*.pub 2>/dev/null | wc -l)
    if [ "$ssh_keys" -gt 0 ]; then
        echo -e "${GREEN}✅ SSH public keys found${NC}: $ssh_keys"
        ls "$HOME"/.ssh/*.pub 2>/dev/null | sed 's/^/  /'
    else
        echo -e "${YELLOW}⚠️  No SSH public keys found${NC}"
        echo "  Run: ssh-keygen -t ed25519 -C \"your@email.com\""
    fi
else
    echo -e "${YELLOW}⚠️  SSH directory not found${NC}"
fi

# System information
echo -e "\n${BLUE}💻 System Information${NC}"
echo "=====================" 
echo -e "OS: ${YELLOW}$(uname -s)${NC}"
echo -e "Version: ${YELLOW}$(uname -r)${NC}"
echo -e "Architecture: ${YELLOW}$(uname -m)${NC}"
echo -e "Shell: ${YELLOW}$SHELL${NC}"
echo -e "Home: ${YELLOW}$HOME${NC}"

# Summary
echo -e "\n${BLUE}📊 Validation Summary${NC}"
echo "====================="
echo -e "Total checks: ${BLUE}$total_checks${NC}"
echo -e "Passed: ${GREEN}$passed_checks${NC}"
echo -e "Failed: ${RED}$failed_checks${NC}"
echo -e "Warnings: ${YELLOW}$warnings${NC}"

if [ $failed_checks -eq 0 ]; then
    echo -e "\n${GREEN}🎉 Development environment looks good!${NC}"
    exit 0
else
    echo -e "\n${YELLOW}⚠️  Some issues found. Please install missing tools.${NC}"
    exit 1
fi