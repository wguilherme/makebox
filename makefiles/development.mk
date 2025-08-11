# Development environment setup and maintenance
.PHONY: dev-setup dev-update dev-doctor dev-ports dev-clean-cache dev-backup _show-dev-commands

# Help section for development commands
_show-dev-commands:
	@echo "  💻 Development Commands:"
	@echo "     dev-setup           Complete development environment setup"
	@echo "     dev-update          Update all development tools"
	@echo "     dev-doctor          Check environment health"
	@echo "     dev-ports           Show all listening ports"
	@echo "     dev-clean-cache     Clean development caches"
	@echo "     dev-backup          Backup development configuration"
	@echo "     dev-status          Quick development environment status"
	@echo ""

# Complete development environment setup
dev-setup:
	@echo "🚀 Setting up development environment..."
	@echo "📦 Updating Homebrew..."
	@brew update && brew upgrade
	@echo "🔧 Installing essential development tools..."
	@brew list node || brew install node
	@brew list git || brew install git
	@brew list curl || brew install curl
	@brew list jq || brew install jq
	@brew list tree || brew install tree
	@echo "✅ Development environment setup completed"

# Update all development tools
dev-update:
	@echo "🔄 Updating development tools..."
	@echo "📦 Homebrew..."
	@brew update && brew upgrade
	@echo "📱 npm packages..."
	@npm update -g
	@echo "🐍 pip packages..."
	@pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U 2>/dev/null || true
	@echo "✅ All tools updated"

# Check development environment health
dev-doctor:
	@echo "🏥 Development environment health check..."
	@echo "\n🍺 Homebrew:"
	@brew doctor 2>/dev/null && echo "✅ Homebrew is healthy" || echo "⚠️  Homebrew has issues"
	@echo "\n📱 Node.js:"
	@node --version && echo "✅ Node.js is installed" || echo "❌ Node.js not found"
	@echo "\n📦 npm:"
	@npm --version && echo "✅ npm is installed" || echo "❌ npm not found"
	@echo "\n🐍 Python:"
	@python3 --version && echo "✅ Python3 is installed" || echo "❌ Python3 not found"
	@echo "\n🔧 Git:"
	@git --version && echo "✅ Git is installed" || echo "❌ Git not found"

# Show all listening ports
dev-ports:
	@echo "🔌 Listening ports:"
	@lsof -iTCP -sTCP:LISTEN -n -P | awk 'NR==1 || /LISTEN/' | column -t

# Clean development caches
dev-clean-cache:
	@echo "🧹 Cleaning development caches..."
	@echo "📱 npm cache..."
	@npm cache clean --force 2>/dev/null || true
	@echo "🐍 pip cache..."
	@pip3 cache purge 2>/dev/null || true
	@echo "🍺 Homebrew cache..."
	@brew cleanup 2>/dev/null || true
	@echo "✅ Caches cleaned"

# Backup development configuration
dev-backup:
	@echo "💾 Backing up development configuration..."
	@mkdir -p $(HOME)/dev-backup
	@cp $(HOME)/.zshrc $(HOME)/dev-backup/.zshrc.backup 2>/dev/null || true
	@cp $(HOME)/.bash_profile $(HOME)/dev-backup/.bash_profile.backup 2>/dev/null || true
	@cp $(HOME)/.gitconfig $(HOME)/dev-backup/.gitconfig.backup 2>/dev/null || true
	@cp $(HOME)/.vimrc $(HOME)/dev-backup/.vimrc.backup 2>/dev/null || true
	@echo "✅ Configuration backed up to $(HOME)/dev-backup"

# Quick development environment status
dev-status:
	@echo "📊 Development Environment Status"
	@echo "=================================="
	@echo "💻 System: $$(uname -s) $$(uname -r)"
	@echo "🏠 Home: $(HOME)"
	@echo "📁 Current: $$(pwd)"
	@echo "🔧 Shell: $$SHELL"
	@echo "📱 Node: $$(node --version 2>/dev/null || echo 'Not installed')"
	@echo "🐍 Python: $$(python3 --version 2>/dev/null || echo 'Not installed')"
	@echo "🔧 Git: $$(git --version 2>/dev/null || echo 'Not installed')"
	@echo "🍺 Brew: $$(brew --version 2>/dev/null | head -1 || echo 'Not installed')"