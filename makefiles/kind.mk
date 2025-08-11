# Kind (Kubernetes in Docker) commands
.PHONY: kind-create kind-delete kind-list kind-export-kubeconfig kind-load-image kind-status _show-kind-commands

# Help section for kind commands
_show-kind-commands:
	@echo "  ☸️  Kind (Kubernetes) Commands:"
	@echo "     kind-create         Create a new kind cluster"
	@echo "     kind-delete         Delete a kind cluster"
	@echo "     kind-list           List all kind clusters"
	@echo "     kind-export-kubeconfig Export kubeconfig for a cluster"
	@echo "     kind-load-image     Load Docker image into cluster"
	@echo "     kind-status         Show status of all kind clusters"
	@echo "     kind-start-all      Start all kind clusters"
	@echo "     kind-stop-all       Stop all kind clusters"
	@echo "     kind-cleanup        Clean up kind resources"
	@echo "     kind-logs           Show cluster logs"
	@echo ""

# Default kind cluster name
KIND_CLUSTER_NAME ?= kind

# Create a new kind cluster
kind-create:
	@if [ -z "$(CLUSTER_NAME)" ]; then \
		echo "❌ Please specify cluster name: gmake kind-create CLUSTER_NAME=my-cluster"; \
		exit 1; \
	fi
	@echo "🚀 Creating kind cluster: $(CLUSTER_NAME)"
	@kind create cluster --name $(CLUSTER_NAME)
	@echo "✅ Cluster $(CLUSTER_NAME) created successfully"
	@echo "💡 Export kubeconfig with: gmake kind-export-kubeconfig CLUSTER_NAME=$(CLUSTER_NAME)"

# Delete a kind cluster
kind-delete:
	@if [ -z "$(CLUSTER_NAME)" ]; then \
		echo "❌ Please specify cluster name: gmake kind-delete CLUSTER_NAME=my-cluster"; \
		exit 1; \
	fi
	@echo "🗑️  Deleting kind cluster: $(CLUSTER_NAME)"
	@kind delete cluster --name $(CLUSTER_NAME)
	@echo "✅ Cluster $(CLUSTER_NAME) deleted successfully"

# List all kind clusters
kind-list:
	@echo "📋 Kind clusters:"
	@kind get clusters 2>/dev/null || echo "No clusters found"

# Export kubeconfig for a specific kind cluster
kind-export-kubeconfig:
	@if [ -z "$(CLUSTER_NAME)" ]; then \
		echo "❌ Please specify cluster name: gmake kind-export-kubeconfig CLUSTER_NAME=my-cluster"; \
		exit 1; \
	fi
	@echo "📁 Exporting kubeconfig for cluster: $(CLUSTER_NAME)"
	@mkdir -p ~/.kube/kind
	@kind get kubeconfig --name $(CLUSTER_NAME) > ~/.kube/kind/config.$(CLUSTER_NAME)
	@echo "✅ Kubeconfig exported to: ~/.kube/kind/config.$(CLUSTER_NAME)"
	@echo "💡 Use it with: export KUBECONFIG=~/.kube/kind/config.$(CLUSTER_NAME)"

# Load Docker image into kind cluster
kind-load-image:
	@if [ -z "$(CLUSTER_NAME)" ] || [ -z "$(IMAGE)" ]; then \
		echo "❌ Please specify cluster name and image:"; \
		echo "   gmake kind-load-image CLUSTER_NAME=my-cluster IMAGE=my-image:tag"; \
		exit 1; \
	fi
	@echo "📦 Loading image $(IMAGE) into cluster $(CLUSTER_NAME)"
	@kind load docker-image $(IMAGE) --name $(CLUSTER_NAME)
	@echo "✅ Image loaded successfully"

# Show status of all kind clusters
kind-status:
	@echo "📊 Kind clusters status:"
	@if [ -z "$$(kind get clusters 2>/dev/null)" ]; then \
		echo "No kind clusters found"; \
	else \
		for cluster in $$(kind get clusters); do \
			echo "\n🏗️  Cluster: $$cluster"; \
			echo "   Config: ~/.kube/kind/config.$$cluster"; \
			if [ -f ~/.kube/kind/config.$$cluster ]; then \
				echo "   Kubeconfig: ✅ Exported"; \
			else \
				echo "   Kubeconfig: ❌ Not exported"; \
			fi; \
			echo "   Nodes:"; \
			docker ps --filter "name=$$cluster" --format "     {{.Names}} ({{.Status}})" 2>/dev/null || echo "     No nodes found"; \
		done; \
	fi

# Start all kind clusters (containers)
kind-start-all:
	@echo "▶️  Starting all kind cluster containers..."
	@docker ps -a --filter "label=io.x-k8s.kind.cluster" --format "{{.Names}}" | xargs -I {} docker start {}
	@echo "✅ All kind clusters started"

# Stop all kind clusters (containers)
kind-stop-all:
	@echo "⏹️  Stopping all kind cluster containers..."
	@docker ps --filter "label=io.x-k8s.kind.cluster" --format "{{.Names}}" | xargs -I {} docker stop {}
	@echo "✅ All kind clusters stopped"

# Clean up kind resources
kind-cleanup:
	@echo "🧹 Cleaning up kind resources..."
	@docker system prune -f --filter "label=io.x-k8s.kind.cluster"
	@echo "✅ Kind resources cleaned up"

# Show kind cluster logs
kind-logs:
	@if [ -z "$(CLUSTER_NAME)" ]; then \
		echo "❌ Please specify cluster name: gmake kind-logs CLUSTER_NAME=my-cluster"; \
		exit 1; \
	fi
	@echo "📋 Logs for cluster: $(CLUSTER_NAME)"
	@docker logs $(CLUSTER_NAME)-control-plane 2>/dev/null || echo "No logs available for cluster $(CLUSTER_NAME)"

# Create kind cluster with custom config
kind-create-with-config:
	@if [ -z "$(CLUSTER_NAME)" ] || [ -z "$(CONFIG_FILE)" ]; then \
		echo "❌ Please specify cluster name and config file:"; \
		echo "   gmake kind-create-with-config CLUSTER_NAME=my-cluster CONFIG_FILE=./kind-config.yaml"; \
		exit 1; \
	fi
	@echo "🚀 Creating kind cluster: $(CLUSTER_NAME) with config: $(CONFIG_FILE)"
	@kind create cluster --name $(CLUSTER_NAME) --config $(CONFIG_FILE)
	@echo "✅ Cluster $(CLUSTER_NAME) created successfully with custom config"