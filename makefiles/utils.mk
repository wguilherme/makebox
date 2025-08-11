# General utility commands
.PHONY: clean-ds clean-node clean-python flush-dns backup-dotfiles system-info network-info _show-utils-commands

# Help section for utility commands
_show-utils-commands:
	@echo "  🔧 Utility Commands:"
	@echo "     clean-ds            Remove .DS_Store files (macOS)"
	@echo "     clean-node          Remove node_modules directories"
	@echo "     clean-python        Remove Python cache files"
	@echo "     flush-dns           Clear DNS cache"
	@echo "     backup-dotfiles     Backup shell configuration"
	@echo "     system-info         Show system information"
	@echo "     network-info        Show network information and connectivity"
	@echo "     find-large          Find large files and directories"
	@echo "     cleanup-suggestions Disk space cleanup suggestions"
	@echo ""

# Remove .DS_Store files recursively (macOS)
clean-ds:
	@echo "🧹 Removing .DS_Store files..."
	@find . -name ".DS_Store" -type f -delete 2>/dev/null || true
	@find $(HOME) -name ".DS_Store" -type f -delete 2>/dev/null || true
	@echo "✅ .DS_Store files removed"

# Remove node_modules directories to free up space
clean-node:
	@echo "🧹 Finding and removing node_modules directories..."
	@find . -name "node_modules" -type d -prune -exec du -sh {} \; 2>/dev/null || true
	@echo "❓ Remove all node_modules directories found above? (y/N)"
	@read -r confirm && [ "$$confirm" = "y" ] && find . -name "node_modules" -type d -prune -exec rm -rf {} \; || echo "Cancelled"

# Remove Python cache files and directories
clean-python:
	@echo "🧹 Removing Python cache files..."
	@find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	@find . -name "*.pyc" -delete 2>/dev/null || true
	@find . -name "*.pyo" -delete 2>/dev/null || true
	@find . -name "*.pyd" -delete 2>/dev/null || true
	@echo "✅ Python cache files removed"

# Flush DNS cache (macOS)
flush-dns:
	@echo "🔄 Flushing DNS cache..."
	@sudo dscacheutil -flushcache
	@sudo killall -HUP mDNSResponder
	@echo "✅ DNS cache flushed"

# Backup shell configuration files
backup-dotfiles:
	@echo "💾 Backing up dotfiles..."
	@mkdir -p $(HOME)/dotfiles-backup/$$(date +%Y%m%d-%H%M%S)
	@cp $(HOME)/.zshrc $(HOME)/dotfiles-backup/$$(date +%Y%m%d-%H%M%S)/ 2>/dev/null || true
	@cp $(HOME)/.bash_profile $(HOME)/dotfiles-backup/$$(date +%Y%m%d-%H%M%S)/ 2>/dev/null || true
	@cp $(HOME)/.gitconfig $(HOME)/dotfiles-backup/$$(date +%Y%m%d-%H%M%S)/ 2>/dev/null || true
	@cp $(HOME)/.vimrc $(HOME)/dotfiles-backup/$$(date +%Y%m%d-%H%M%S)/ 2>/dev/null || true
	@cp $(HOME)/.tmux.conf $(HOME)/dotfiles-backup/$$(date +%Y%m%d-%H%M%S)/ 2>/dev/null || true
	@echo "✅ Dotfiles backed up to $(HOME)/dotfiles-backup/"

# Show comprehensive system information
system-info:
	@echo "💻 System Information"
	@echo "===================="
	@echo "🖥️  System: $$(uname -a)"
	@echo "💾 Memory: $$(top -l 1 -s 0 | grep PhysMem)"
	@echo "💽 Disk Usage:"
	@df -h | head -2
	@echo "🌡️  CPU Info:"
	@sysctl -n machdep.cpu.brand_string 2>/dev/null || echo "CPU info not available"
	@echo "🔌 Network Interfaces:"
	@ifconfig | grep -E '^[a-z]' | cut -d: -f1 | tr '\n' ' ' && echo
	@echo "📱 Uptime: $$(uptime)"

# Show network information and connectivity
network-info:
	@echo "🌐 Network Information"
	@echo "====================="
	@echo "🔌 Active Connections:"
	@netstat -rn | head -10
	@echo "\n📡 WiFi Status:"
	@airport -I 2>/dev/null | grep -E 'SSID|state' || echo "WiFi info not available"
	@echo "\n🌍 External IP:"
	@curl -s ifconfig.me 2>/dev/null || echo "Could not determine external IP"
	@echo "\n🏠 Local IP:"
	@ifconfig | grep -E 'inet ' | grep -v 127.0.0.1 | awk '{print $$2}'

# Find large files and directories
find-large:
	@echo "📏 Finding large files and directories (>100MB)..."
	@echo "Directories:"
	@du -sh */ 2>/dev/null | sort -hr | head -10
	@echo "\nFiles:"
	@find . -type f -size +100M -exec ls -lh {} \; 2>/dev/null | head -10

# Quick disk space cleanup suggestions
cleanup-suggestions:
	@echo "💡 Disk Space Cleanup Suggestions"
	@echo "================================="
	@echo "📱 npm cache: $$(du -sh ~/.npm/_cacache 2>/dev/null | cut -f1 || echo '0B')"
	@echo "🐍 pip cache: $$(du -sh ~/Library/Caches/pip 2>/dev/null | cut -f1 || echo '0B')"
	@echo "🍺 Homebrew cache: $$(du -sh ~/Library/Caches/Homebrew 2>/dev/null | cut -f1 || echo '0B')"
	@echo "🗑️  Trash: $$(du -sh ~/.Trash 2>/dev/null | cut -f1 || echo '0B')"
	@echo "\nRun 'gmake dev-clean-cache' to clean development caches"