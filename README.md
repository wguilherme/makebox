# 📦 MakeBox

> 🛠️ Global Makefiles toolkit for developers - Run useful commands from anywhere without cluttering your projects

MakeBox is a collection of portable Makefiles designed to streamline your development workflow. Execute common tasks from any directory while keeping your project-specific Makefiles clean and focused.

## ✨ Features

- **Global Commands**: Run commands from anywhere in your system
- **Modular Structure**: Organized by categories (Utilities, Kind/Kubernetes, Health & Testing)
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

# Utility commands
gmake clean-ds           # Clean .DS_Store files (macOS)
gmake clean-node         # Remove node_modules directories
gmake system-info        # Show system information
gmake check-port PORT=8080  # Check what process is using a port

# Kind (Kubernetes) commands
gmake kind-list          # List all kind clusters
gmake kind-export-kubeconfig CLUSTER_NAME=my-cluster  # Export kubeconfig
gmake kind-create CLUSTER_NAME=dev  # Create new cluster

# Health & Testing
gmake healthcheck        # Complete health check
gmake quick-test         # Quick installation test
```

## 📁 Project Structure

```
makebox/
├── README.md                   # This file
├── Makefile                    # Main Makefile that includes all modules
├── makefiles/                  # Modular command files
│   ├── utils.mk               # General utilities and system commands
│   ├── kind.mk                # Kubernetes Kind cluster management
│   └── healthcheck.mk         # Health checks and testing
├── scripts/                    # Helper scripts
│   ├── dev-env-validator.sh   # Development environment validation
│   ├── docker-cleanup.sh      # Advanced Docker cleanup
│   └── git-repo-health.sh     # Git repository health checker
└── .env.example               # Example environment variables
```

## 🔧 Configuration

### Environment Variables

Copy `.env.example` to `.env` and customize:

```bash
cp .env.example .env
```

Available variables:
- `PROJECTS_DIR`: Directory where your projects are located (default: `~/git`)

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

### 🔧 Utilities
- `clean-ds` - Remove .DS_Store files (macOS)
- `clean-node` - Remove node_modules directories  
- `clean-python` - Remove Python cache files
- `system-info` - Show comprehensive system information
- `network-info` - Show network information and connectivity
- `check-port` - Check what process is using a specific port
- `flush-dns` - Clear DNS cache
- `backup-dotfiles` - Backup configuration files

### ☸️ Kind (Kubernetes)
- `kind-create` - Create a new kind cluster
- `kind-delete` - Delete a kind cluster
- `kind-list` - List all kind clusters
- `kind-export-kubeconfig` - Export kubeconfig for a cluster
- `kind-load-image` - Load Docker image into cluster
- `kind-status` - Show status of all kind clusters

### 🏥 Health & Testing
- `healthcheck` - Complete health check and validation
- `quick-test` - Quick installation test
- `install-help` - Show installation instructions

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