# 📦 MakeBox

> 🛠️ Global Makefiles toolkit for developers - Run useful commands from anywhere without cluttering your projects

MakeBox is a collection of portable Makefiles designed to streamline your development workflow. Execute common tasks from any directory while keeping your project-specific Makefiles clean and focused.

## ✨ Features

- **Global Commands**: Run commands from anywhere in your system
- **Modular Structure**: Organized by categories (Docker, Git, Development, Utilities)
- **Non-invasive**: Works alongside your existing project Makefiles
- **Extensible**: Easy to add your own custom commands
- **Version Controlled**: Keep your commands synchronized across machines

## 🚀 Quick Start

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/makebox.git ~/makebox
```

2. Add an alias to your shell configuration:

**For zsh** (default on macOS):
```bash
echo "alias gmake='make -f ~/makebox/Makefile'" >> ~/.zshrc
source ~/.zshrc
```

**For bash**:
```bash
echo "alias gmake='make -f ~/makebox/Makefile'" >> ~/.bash_profile
source ~/.bash_profile
```

3. Test the installation:
```bash
gmake quick-test
```

If everything is working, you should see a success message. For a complete health check, run:
```bash
gmake healthcheck
```

## 📖 Usage

Run any command from anywhere in your system:

```bash
# Show all available commands
gmake help

# Docker commands
gmake docker-clean       # Clean containers and images
gmake docker-stats       # Show container statistics
gmake docker-logs        # View container logs

# Git commands
gmake git-status-all     # Check status of all repositories
gmake git-pull-all       # Pull updates for all repositories
gmake git-cleanup        # Clean merged branches

# Development commands
gmake dev-setup          # Setup development environment
gmake dev-update         # Update development tools

# Utilities
gmake ports              # Show listening ports
gmake clean-ds           # Clean .DS_Store files (macOS)
gmake flush-dns         # Flush DNS cache
```

## 📁 Project Structure

```
makebox/
├── README.md                   # This file
├── Makefile                    # Main Makefile that includes all modules
├── makefiles/                  # Modular command files
│   ├── docker.mk              # Docker-related commands
│   ├── git.mk                 # Git utilities
│   ├── development.mk         # Development environment setup
│   └── utils.mk               # General utilities
├── scripts/                    # Helper scripts (if needed)
└── .env.example               # Example environment variables
```

## 🔧 Configuration

### Environment Variables

Copy `.env.example` to `.env` and customize:

```bash
cp .env.example .env
```

Available variables:
- `PROJECTS_DIR`: Directory where your Git projects are located (default: `~/git`)
- `DOCKER_CLEANUP_DAYS`: Days to keep Docker images (default: 7)

### Adding Custom Commands

1. Create a new file in `makefiles/` or edit an existing one:

```makefile
# makefiles/custom.mk
.PHONY: my-command

my-command:
    @echo "Running my custom command..."
    # Your command here
```

2. Include it in the main `Makefile`:

```makefile
include makefiles/custom.mk
```

## 🎯 Command Categories

### 🐳 Docker
- `docker-clean` - Remove unused containers, networks, and images
- `docker-stats` - Display resource usage statistics
- `docker-logs` - Show logs from running containers
- `docker-stop-all` - Stop all running containers

### 🌿 Git
- `git-status-all` - Check status of all Git repositories
- `git-pull-all` - Pull latest changes for all repositories
- `git-cleanup` - Remove merged branches
- `git-prune` - Clean up remote-tracking references

### 💻 Development
- `dev-setup` - Install/update development tools
- `dev-update` - Update package managers and tools
- `dev-doctor` - Check development environment health

### 🔧 Utilities
- `ports` - List all listening ports
- `clean-ds` - Remove .DS_Store files (macOS)
- `clean-node` - Remove node_modules directories
- `flush-dns` - Clear DNS cache
- `backup-dotfiles` - Backup configuration files

## 🤝 Contributing

Contributions are welcome! Feel free to:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/awesome-command`)
3. Commit your changes (`git commit -m 'Add awesome command'`)
4. Push to the branch (`git push origin feature/awesome-command`)
5. Open a Pull Request

## 💡 Tips & Tricks

### Avoiding Conflicts

Always prefix your global commands to avoid conflicts with local Makefiles:
- Use descriptive prefixes: `docker-`, `git-`, `dev-`
- Or use a global prefix: `g-clean`, `g-setup`

### Running from VS Code

Add to VS Code tasks.json:
```json
{
  "label": "MakeBox: Help",
  "type": "shell",
  "command": "make -f ~/makebox/Makefile help"
}
```

### Auto-completion

For zsh auto-completion, add to your `.zshrc`:
```bash
compdef _make gmake
```

## 📝 License

MIT License - feel free to use this in your personal and commercial projects.

## 🙏 Acknowledgments

Inspired by the need to have useful commands available everywhere without polluting project-specific Makefiles.

---

**Made with ❤️ for developers who love automation**