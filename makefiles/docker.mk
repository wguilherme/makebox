# Docker commands for container management
.PHONY: docker-clean docker-stats docker-logs docker-stop-all docker-restart docker-inspect _show-docker-commands

# Help section for docker commands
_show-docker-commands:
	@echo "  🐳 Docker Commands:"
	@echo "     docker-clean        Remove unused containers and images"
	@echo "     docker-stats        Show container resource usage"
	@echo "     docker-logs         View logs from running containers"
	@echo "     docker-stop-all     Stop all running containers"
	@echo "     docker-restart      Restart all containers"
	@echo "     docker-inspect      Show detailed container information"
	@echo "     docker-info         Show Docker system information"
	@echo ""

# Remove unused containers, networks, images and volumes
docker-clean:
	@echo "🧹 Cleaning Docker containers, images, networks and volumes..."
	@docker system prune -af
	@docker volume prune -f
	@echo "✅ Docker cleanup completed"

# Show resource usage statistics for running containers
docker-stats:
	@echo "📊 Docker container statistics:"
	@docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"

# View logs from running containers (shows last 50 lines)
docker-logs:
	@echo "📋 Recent logs from running containers:"
	@for container in $$(docker ps --format "{{.Names}}"); do \
		echo "\n=== $$container ==="; \
		docker logs --tail 50 $$container 2>/dev/null || echo "No logs available"; \
	done

# Stop all running containers
docker-stop-all:
	@echo "🛑 Stopping all running containers..."
	@docker ps -q | xargs -r docker stop
	@echo "✅ All containers stopped"

# Restart all containers that were running
docker-restart:
	@echo "🔄 Restarting Docker containers..."
	@docker ps -a -q | xargs -r docker restart
	@echo "✅ Containers restarted"

# Show detailed information about containers
docker-inspect:
	@echo "🔍 Container inspection:"
	@docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

# Show Docker system information
docker-info:
	@echo "ℹ️  Docker system information:"
	@docker system df
	@echo "\n📦 Images:"
	@docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.CreatedAt}}"