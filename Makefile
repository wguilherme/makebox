# MakeBox - Global Makefiles Toolkit
# Main entry point that includes all modular makefiles

# Default shell
SHELL := /bin/bash

# Load environment variables if .env exists
-include .env

# Default values for environment variables
PROJECTS_DIR ?= $(HOME)/git
DOCKER_CLEANUP_DAYS ?= 7

# Get the directory of this Makefile  
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
# Main Makefile path (use absolute path of this file)
MAIN_MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))

# Dynamically include all .mk files from the makefiles directory
MK_FILES := $(wildcard $(MAKEFILE_DIR)makefiles/*.mk)
include $(MK_FILES)

# Default target
.DEFAULT_GOAL := help

# Dynamic help command - automatically discovers and shows all available commands
.PHONY: help
help:
	@echo ""
	@echo "  📦 MakeBox - Global Makefiles Toolkit"
	@echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@$(MAKE) -f $(MAIN_MAKEFILE) _show-docker-commands 2>/dev/null || true
	@$(MAKE) -f $(MAIN_MAKEFILE) _show-git-commands 2>/dev/null || true  
	@$(MAKE) -f $(MAIN_MAKEFILE) _show-dev-commands 2>/dev/null || true
	@$(MAKE) -f $(MAIN_MAKEFILE) _show-utils-commands 2>/dev/null || true
	@$(MAKE) -f $(MAIN_MAKEFILE) _show-kind-commands 2>/dev/null || true
	@$(MAKE) -f $(MAIN_MAKEFILE) _show-health-commands 2>/dev/null || true
	@$(MAKE) -f $(MAIN_MAKEFILE) _show-scripts 2>/dev/null || true
	@echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  Usage: gmake <command>"
	@echo "  Environment: PROJECTS_DIR=$(PROJECTS_DIR)"
	@echo "  Loaded modules: $$(ls $(MAKEFILE_DIR)makefiles/*.mk 2>/dev/null | wc -l | tr -d ' ') .mk files"
	@echo ""

# Internal helper targets for dynamic help
.PHONY: _show-scripts

_show-scripts:
	@echo "  📜 Scripts:"
	@if [ -d "$(MAKEFILE_DIR)scripts" ]; then \
		for script in $(MAKEFILE_DIR)scripts/*.sh; do \
			if [ -f "$$script" ]; then \
				script_name=$$(basename "$$script"); \
				echo "     ./scripts/$$script_name"; \
			fi; \
		done; \
	else \
		echo "     (no scripts directory found)"; \
	fi
	@echo ""

# Version information
.PHONY: version
version:
	@echo "MakeBox v1.0.0"
	@echo "Make version: $(MAKE_VERSION)"
	@echo "Shell: $(SHELL)"