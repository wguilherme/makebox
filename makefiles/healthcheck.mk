# Health check and test commands
.PHONY: healthcheck test-setup validate-install doctor _show-health-commands

# Help section for health/testing commands
_show-health-commands:
	@echo "  🏥 Health & Testing:"
	@echo "     healthcheck         Complete health check and validation"
	@echo "     quick-test          Quick installation test"
	@echo "     test-setup          Alias for healthcheck"
	@echo "     validate-install    Alias for healthcheck"
	@echo "     doctor              Alias for healthcheck"
	@echo "     install-help        Show installation instructions"
	@echo ""

# Main health check command - validates the entire setup
healthcheck:
	@echo ""
	@echo "🏥 MakeBox Health Check"
	@echo "======================="
	@echo ""
	@$(MAKE) -f $(MAIN_MAKEFILE) _check-makebox-setup
	@$(MAKE) -f $(MAIN_MAKEFILE) _check-alias
	@$(MAKE) -f $(MAIN_MAKEFILE) _check-dependencies
	@$(MAKE) -f $(MAIN_MAKEFILE) _check-permissions
	@$(MAKE) -f $(MAIN_MAKEFILE) _test-sample-commands
	@echo ""
	@echo "✅ Health check completed!"
	@echo "💡 Run 'gmake help' to see all available commands"

# Alias for healthcheck
test-setup: healthcheck
validate-install: healthcheck
doctor: healthcheck

# Internal: Check if MakeBox files are accessible
_check-makebox-setup:
	@echo "📁 Checking MakeBox installation..."
	@if [ -f "$(MAIN_MAKEFILE)" ]; then \
		echo "  ✅ Main Makefile found: $(MAIN_MAKEFILE)"; \
	else \
		echo "  ❌ Main Makefile not found"; \
		exit 1; \
	fi
	@if [ -d "$(MAKEFILE_DIR)makefiles" ]; then \
		echo "  ✅ Makefiles directory exists"; \
		echo "  📋 Available modules: $$(ls $(MAKEFILE_DIR)makefiles/*.mk | wc -l) files"; \
	else \
		echo "  ❌ Makefiles directory not found"; \
		exit 1; \
	fi
	@if [ -d "$(MAKEFILE_DIR)scripts" ]; then \
		echo "  ✅ Scripts directory exists"; \
		echo "  📜 Available scripts: $$(ls $(MAKEFILE_DIR)scripts/*.sh 2>/dev/null | wc -l) files"; \
	else \
		echo "  ⚠️  Scripts directory not found (optional)"; \
	fi

# Internal: Check if gmake alias is working
_check-alias:
	@echo ""
	@echo "🔗 Checking gmake alias..."
	@if grep -q "alias gmake" ~/.zshrc 2>/dev/null; then \
		echo "  ✅ gmake alias configured in ~/.zshrc"; \
		echo "  ✅ gmake alias working (healthcheck was called via gmake)"; \
	else \
		echo "  ❌ gmake alias not configured"; \
		echo "  💡 Add this to your shell config:"; \
		echo "     echo \"alias gmake='make -f $(MAIN_MAKEFILE)'\" >> ~/.zshrc"; \
		echo "     source ~/.zshrc"; \
		exit 1; \
	fi

# Internal: Check essential dependencies
_check-dependencies:
	@echo ""
	@echo "🔧 Checking essential dependencies..."
	@deps_missing=0; \
	for dep in make bash git curl; do \
		if command -v $$dep >/dev/null 2>&1; then \
			echo "  ✅ $$dep: $$($$dep --version 2>/dev/null | head -1)"; \
		else \
			echo "  ❌ $$dep: not found"; \
			deps_missing=$$((deps_missing + 1)); \
		fi; \
	done; \
	if [ $$deps_missing -gt 0 ]; then \
		echo "  ⚠️  $$deps_missing essential dependencies missing"; \
		echo "  💡 Install missing tools with: brew install <tool-name>"; \
	fi

# Internal: Check file permissions
_check-permissions:
	@echo ""
	@echo "🔒 Checking permissions..."
	@if [ -r "$(firstword $(MAKEFILE_LIST))" ]; then \
		echo "  ✅ Main Makefile is readable"; \
	else \
		echo "  ❌ Main Makefile is not readable"; \
		exit 1; \
	fi
	@script_count=0; \
	executable_count=0; \
	if [ -d "$(MAKEFILE_DIR)scripts" ]; then \
		for script in $(MAKEFILE_DIR)scripts/*.sh; do \
			if [ -f "$$script" ]; then \
				script_count=$$((script_count + 1)); \
				if [ -x "$$script" ]; then \
					executable_count=$$((executable_count + 1)); \
				fi; \
			fi; \
		done; \
		if [ $$script_count -gt 0 ]; then \
			echo "  📜 Scripts: $$executable_count/$$script_count are executable"; \
			if [ $$executable_count -ne $$script_count ]; then \
				echo "  💡 Run: chmod +x $(MAKEFILE_DIR)scripts/*.sh"; \
			fi; \
		fi; \
	else \
		echo "  ⚠️  Scripts directory not found"; \
	fi

# Internal: Test a few sample commands
_test-sample-commands:
	@echo ""
	@echo "🧪 Testing sample commands..."
	@echo "  📋 Testing 'make version':"
	@if make -f $(MAIN_MAKEFILE) version >/dev/null 2>&1; then \
		echo "    ✅ version command works"; \
	else \
		echo "    ❌ version command failed"; \
		exit 1; \
	fi
	@echo "  📋 Testing 'make help' (output suppressed):"
	@if make -f $(MAIN_MAKEFILE) help >/dev/null 2>&1; then \
		echo "    ✅ help command works"; \
	else \
		echo "    ❌ help command failed"; \
		exit 1; \
	fi
	@echo "  📋 Testing module inclusion:"
	@modules_loaded=0; \
	total_modules=6; \
	for module in docker git dev utils kind health; do \
		if make -f $(MAIN_MAKEFILE) help 2>/dev/null | grep -q "$$module"; then \
			modules_loaded=$$((modules_loaded + 1)); \
		fi; \
	done; \
	echo "    ✅ $$modules_loaded/$$total_modules modules loaded successfully"

# Quick test that can be run immediately after installation
quick-test:
	@echo "🚀 Quick MakeBox Test"
	@echo "===================="
	@echo ""
	@if grep -q "alias gmake" ~/.zshrc 2>/dev/null; then \
		echo "✅ gmake alias configured in ~/.zshrc"; \
		echo "✅ gmake alias working (you executed this command successfully!)"; \
		echo "📋 Available commands: $$(make -f $(MAIN_MAKEFILE) help 2>/dev/null | grep -c '^     [a-z]' || echo 'unknown')"; \
		echo ""; \
		echo "🎉 MakeBox is ready to use!"; \
		echo "💡 Run 'gmake help' to see all available commands"; \
		echo "💡 Run 'gmake healthcheck' for a complete health check"; \
	else \
		echo "❌ gmake alias not configured"; \
		echo ""; \
		echo "🔧 Setup required:"; \
		echo "1. Add alias: echo \"alias gmake='make -f $(MAIN_MAKEFILE)'\" >> ~/.zshrc"; \
		echo "2. Reload shell: source ~/.zshrc"; \
		echo "3. Test again: gmake quick-test"; \
	fi

# Show installation instructions
install-help:
	@echo ""
	@echo "📦 MakeBox Installation Guide"
	@echo "============================="
	@echo ""
	@echo "1. Clone the repository:"
	@echo "   git clone <repo-url> ~/makebox"
	@echo ""
	@echo "2. Add alias to your shell:"
	@echo "   echo \"alias gmake='make -f ~/makebox/Makefile'\" >> ~/.zshrc"
	@echo ""
	@echo "3. Reload your shell:"
	@echo "   source ~/.zshrc"
	@echo ""
	@echo "4. Test the installation:"
	@echo "   gmake quick-test"
	@echo ""
	@echo "5. Run full health check:"
	@echo "   gmake healthcheck"
	@echo ""
	@echo "6. See all available commands:"
	@echo "   gmake help"
	@echo ""