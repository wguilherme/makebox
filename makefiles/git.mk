# Git commands for repository management
.PHONY: git-status-all git-pull-all git-cleanup git-prune git-recent git-branches git-stash-all _show-git-commands

# Help section for git commands
_show-git-commands:
	@echo "  🌿 Git Commands:"
	@echo "     git-status-all      Check status of all repositories"
	@echo "     git-pull-all        Pull updates for all repositories"
	@echo "     git-cleanup         Remove merged branches"
	@echo "     git-prune           Clean remote-tracking references"
	@echo "     git-recent          Show recent commits across repos"
	@echo "     git-branches        Show all branches across repositories"
	@echo "     git-stash-all       Stash changes in all repositories"
	@echo "     git-new-repo        Create a new repository with standard setup"
	@echo ""

# Default projects directory (can be overridden with PROJECTS_DIR env var)
PROJECTS_DIR ?= $(HOME)/git

# Check status of all Git repositories
git-status-all:
	@echo "🔍 Checking status of all repositories in $(PROJECTS_DIR)..."
	@find $(PROJECTS_DIR) -name ".git" -type d -execdir bash -c 'pwd && echo "Branch: $$(git branch --show-current)" && git status --porcelain' \; 2>/dev/null

# Pull updates for all repositories
git-pull-all:
	@echo "⬇️  Pulling updates for all repositories in $(PROJECTS_DIR)..."
	@find $(PROJECTS_DIR) -name ".git" -type d -execdir bash -c 'pwd && git pull --ff-only' \; 2>/dev/null

# Clean merged branches (keeps main, master, develop)
git-cleanup:
	@echo "🌿 Cleaning merged branches in all repositories..."
	@find $(PROJECTS_DIR) -name ".git" -type d -execdir bash -c 'pwd && git branch --merged | grep -v "main\|master\|develop\|\*" | xargs -n 1 git branch -d' \; 2>/dev/null

# Prune remote-tracking references
git-prune:
	@echo "✂️  Pruning remote-tracking references..."
	@find $(PROJECTS_DIR) -name ".git" -type d -execdir bash -c 'pwd && git remote prune origin' \; 2>/dev/null

# Show recent commits across all repositories
git-recent:
	@echo "📅 Recent commits across all repositories:"
	@find $(PROJECTS_DIR) -name ".git" -type d -execdir bash -c 'pwd && git log --oneline -5 --decorate' \; 2>/dev/null

# Show all branches across repositories
git-branches:
	@echo "🌳 Branches across all repositories:"
	@find $(PROJECTS_DIR) -name ".git" -type d -execdir bash -c 'pwd && git branch -a' \; 2>/dev/null

# Stash changes in all repositories
git-stash-all:
	@echo "📦 Stashing changes in all repositories..."
	@find $(PROJECTS_DIR) -name ".git" -type d -execdir bash -c 'pwd && if [ -n "$$(git status --porcelain)" ]; then git stash push -m "Auto-stash $(shell date)"; fi' \; 2>/dev/null

# Create a new repository with standard setup
git-new-repo:
	@read -p "Repository name: " repo_name; \
	mkdir -p $(PROJECTS_DIR)/$$repo_name; \
	cd $(PROJECTS_DIR)/$$repo_name; \
	git init; \
	echo "# $$repo_name" > README.md; \
	echo ".DS_Store" > .gitignore; \
	echo "node_modules/" >> .gitignore; \
	echo ".env" >> .gitignore; \
	git add .; \
	git commit -m "Initial commit"; \
	echo "✅ Repository $$repo_name created in $(PROJECTS_DIR)/$$repo_name"