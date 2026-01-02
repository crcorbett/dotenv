# Cooper's Dotfiles

Reproducible development environment using Nix flakes, home-manager, and nix-darwin.

## Overview

Two configurations:

| Config | Platform | Use Case | Command |
|--------|----------|----------|---------|
| `cooper@linux` | Linux x86_64 | VMs, servers (thin client) | `home-manager switch --flake .#cooper@linux` |
| `coopers-macbook-pro` | macOS ARM | Workstation (full setup) | `darwin-rebuild switch --flake .#coopers-macbook-pro` |

## Quick Start

### Prerequisites

Install Nix with flakes:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### New Linux VM

```bash
# Clone repo
git clone https://github.com/crcorbett/dotenv.git ~/dotenv
cd ~/dotenv

# Apply configuration
nix run home-manager -- switch --flake .#cooper@linux

# Set up Tailscale
./scripts/setup-tailscale.sh --ssh

# Create secrets file
cp .secrets.example ~/.secrets
# Edit ~/.secrets with your API keys
```

### New macOS Workstation

```bash
# Clone repo
git clone https://github.com/crcorbett/dotenv.git ~/dotenv
cd ~/dotenv

# Apply configuration
nix run nix-darwin -- switch --flake .#coopers-macbook-pro

# Create secrets file
cp .secrets.example ~/.secrets
# Edit ~/.secrets with your API keys

# Install apps (see APPS.md)
```

### Updating

```bash
cd ~/dotenv
git pull

# Linux
home-manager switch --flake .#cooper@linux

# macOS
darwin-rebuild switch --flake .#coopers-macbook-pro
```

## Repository Structure

```
dotenv/
├── flake.nix                 # Main entry - defines configurations
├── flake.lock                # Pinned dependencies
│
├── home/
│   ├── core.nix              # Shared config (packages, dotfiles, shell)
│   ├── workstation.nix       # Desktop app configs (macOS only)
│   └── dotfiles/
│       ├── zshrc             # Shell config
│       ├── p10k.zsh          # Powerlevel10k theme
│       ├── gitconfig         # Git config with 1Password signing
│       ├── gitconfig-macos   # macOS 1Password path
│       ├── gitconfig-linux   # Linux 1Password path
│       ├── ssh_config        # SSH config
│       └── ghostty.conf      # Terminal config
│
├── darwin/
│   └── system.nix            # macOS system preferences
│
├── configs/                  # Workstation app configs
│   ├── zed/
│   │   ├── settings.json
│   │   └── keymap.json
│   └── cursor/
│       └── settings.json
│
├── scripts/
│   └── setup-tailscale.sh    # Tailscale setup for Linux
│
├── APPS.md                   # Manual app installation list
├── .secrets.example          # Template for secrets file
└── README.md
```

## What's Included

### Both Platforms (core.nix)

- **Shell**: zsh + oh-my-zsh + Powerlevel10k
- **Tools**: git, gh, ripgrep, fd, fzf, eza, zoxide, delta, lazygit, neovim
- **Git**: 1Password SSH commit signing
- **Fonts**: Nerd Fonts (Meslo, JetBrains Mono)

### macOS Workstation (workstation.nix + darwin/system.nix)

- **App configs**: Ghostty, Zed, Cursor
- **System prefs**: Dock autohide, dark mode, text replacements
- **Services**: Tailscale, Touch ID for sudo

## Secrets

API keys and tokens are stored in `~/.secrets` (not in repo):

```bash
# Copy template
cp .secrets.example ~/.secrets

# Edit with your values
vim ~/.secrets
```

The zshrc automatically sources this file if it exists.

## Key Bindings

### Shell Aliases

| Alias | Command |
|-------|---------|
| `ll` | `ls -la` |
| `gs` | `git status` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `lg` | `lazygit` |
| `vim`, `v` | `nvim` |

### Text Replacements (macOS)

| Type | Expands To |
|------|------------|
| `@@` | coopercorbett@gmail.com |
| `@&` | cooper.corbett@tilt.legal |
| `omw` | On my way! |

## Tailscale

### Linux VM

```bash
./scripts/setup-tailscale.sh --ssh
```

Opens a URL - authenticate with Google.

### macOS

Tailscale is enabled via nix-darwin. After first run:

```bash
tailscale up --ssh
```

## Updating Nix Packages

```bash
cd ~/dotenv
nix flake update
darwin-rebuild switch --flake .#coopers-macbook-pro  # or home-manager for Linux
```

## Adding Packages

Edit the appropriate file:

- **All platforms**: `home/core.nix` → `home.packages`
- **macOS system**: `darwin/system.nix` → `environment.systemPackages`

## License

Personal configuration - feel free to fork and adapt.
