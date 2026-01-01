# Cooper's Dotfiles

Reproducible development environment using Nix flakes, home-manager, nix-darwin, and NixOS.

## Overview

This repository provides a fully declarative configuration for development machines across macOS and Linux. It uses the Nix ecosystem to ensure reproducible environments that can be deployed to new machines in minutes.

### Supported Platforms

| Platform | Configuration Type | Profile Options |
|----------|-------------------|-----------------|
| macOS (Apple Silicon) | nix-darwin + home-manager | thin, full |
| Linux (x86_64) | home-manager standalone | thin, full |
| NixOS | NixOS + home-manager | thin, full |

### Profile Comparison

| Feature | Thin | Full |
|---------|------|------|
| zsh + powerlevel10k + oh-my-zsh | Yes | Yes |
| Core tools (git, tmux, ripgrep, fd, jq) | Yes | Yes |
| Tailscale CLI | Yes | Yes |
| SSH hardened config | Yes | Yes |
| Shell aliases | Yes | Yes |
| neovim | No | Yes |
| Ghostty terminal config | No | Yes |
| fzf, bat, eza, lazygit | No | Yes |
| Nerd Fonts | No | Yes |
| Node.js tooling (nvm, pnpm, bun) | No | Yes |

## Quick Start

### Prerequisites

Install Nix with flakes enabled:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### New Linux VM (Ubuntu, Debian, etc.)

```bash
# 1. Clone this repo
git clone https://github.com/crcorbett/dotenv.git ~/dotenv
cd ~/dotenv

# 2. Apply home-manager configuration (thin profile for servers)
nix run home-manager -- switch --flake .#cooper@linux-thin

# 3. Set up Tailscale (see Tailscale section below)
./scripts/setup-tailscale.sh --ssh

# 4. Log out and back in (or run: exec bash)
```

### New macOS Machine

```bash
# 1. Clone this repo
git clone https://github.com/crcorbett/dotenv.git ~/dotenv
cd ~/dotenv

# 2. Apply nix-darwin system configuration (includes home-manager)
nix run nix-darwin -- switch --flake .#coopers-macbook-pro

# 3. Set up Tailscale
./scripts/setup-tailscale.sh
```

### Existing Machine Updates

```bash
cd ~/dotenv
git pull

# Linux (home-manager standalone)
home-manager switch --flake .#cooper@linux-thin
# or for full profile:
home-manager switch --flake .#cooper@linux-full

# macOS (nix-darwin)
darwin-rebuild switch --flake .#coopers-macbook-pro

# NixOS
sudo nixos-rebuild switch --flake .#development-vm
```

## Repository Structure

```
dotenv/
├── flake.nix                 # Main flake - defines all configurations
├── flake.lock                # Pinned dependencies
├── README.md                 # This file
│
├── home/                     # home-manager modules
│   ├── base.nix              # Shared config (zsh, tmux, git, ssh, aliases)
│   ├── thin.nix              # Minimal profile (imports base)
│   ├── full.nix              # Full dev profile (imports base + extras)
│   ├── linux.nix             # Linux-specific settings
│   ├── darwin.nix            # macOS-specific settings
│   ├── p10k.zsh              # Powerlevel10k theme config
│   └── ghostty.conf          # Ghostty terminal config
│
├── darwin/                   # nix-darwin (macOS system config)
│   └── configuration.nix     # System preferences, Tailscale, etc.
│
├── nixos/                    # NixOS (Linux system config)
│   └── configuration.nix     # Full NixOS VM/server config
│
└── scripts/                  # Helper scripts
    └── setup-tailscale.sh    # Tailscale setup for non-NixOS Linux
```

## Available Configurations

### Home Manager Configurations

Used with `home-manager switch --flake .#<name>`:

| Name | Platform | Profile | Use Case |
|------|----------|---------|----------|
| `cooper@linux-thin` | Linux x86_64 | thin | VMs, servers, containers |
| `cooper@linux-full` | Linux x86_64 | full | Linux workstations |
| `cooper@darwin-thin` | macOS ARM | thin | Minimal macOS setup |
| `cooper@darwin-full` | macOS ARM | full | macOS workstations |

### Darwin Configurations

Used with `darwin-rebuild switch --flake .#<name>`:

| Name | Description |
|------|-------------|
| `coopers-macbook-pro` | Full macOS system + home-manager (full profile) |

### NixOS Configurations

Used with `nixos-rebuild switch --flake .#<name>`:

| Name | Description |
|------|-------------|
| `development-vm` | NixOS VM with thin profile, Tailscale, hardened SSH |

## What's Included

### Shell Environment (base.nix)

- **zsh** with oh-my-zsh and powerlevel10k theme
- **Automatic shell switching**: bash execs into zsh on interactive login (for non-NixOS systems)
- **tmux** with custom keybindings (prefix: `Ctrl+A`)
- **Git** with sane defaults (rebase on pull, auto-setup remote)
- **SSH** hardened configuration with key-only auth

### Packages

**Thin profile:**
- git, gh (GitHub CLI)
- curl, wget
- htop, jq
- ripgrep, fd, tree
- tmux
- tailscale

**Full profile adds:**
- neovim (configured as default editor)
- bat (better cat)
- eza (better ls)
- fzf (fuzzy finder)
- zoxide (smarter cd)
- delta (better git diff)
- lazygit (git TUI)
- Nerd Fonts (Meslo, JetBrains Mono, Fira Code)

### Key Bindings

#### tmux
| Key | Action |
|-----|--------|
| `Ctrl+A` | Prefix (instead of Ctrl+B) |
| `Ctrl+A \|` | Split vertical |
| `Ctrl+A -` | Split horizontal |
| `Alt+Arrow` | Switch panes |
| `Ctrl+A r` | Reload config |

#### Shell Aliases
| Alias | Command |
|-------|---------|
| `ll` | `ls -la` |
| `gs` | `git status` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `ta` | `tmux attach -t` |
| `tl` | `tmux ls` |
| `tn` | `tmux new -s` |
| `lg` | `lazygit` (full profile) |
| `vim`, `v` | `nvim` (full profile) |

## Tailscale Setup

Tailscale provides secure networking between all your machines. Authentication is via **Google OAuth** - you'll be given a URL to open in your browser.

### macOS

The daemon is managed by nix-darwin, but requires manual authentication:

```bash
# After darwin-rebuild switch, run:
./scripts/setup-tailscale.sh --ssh
```

This will display a URL - open it in your browser and sign in with Google.

### Non-NixOS Linux (Ubuntu, Debian, etc.)

Use the helper script since home-manager can't manage system services:

```bash
# Standard setup with Tailscale SSH enabled
./scripts/setup-tailscale.sh --ssh

# With custom hostname
./scripts/setup-tailscale.sh --ssh --hostname my-dev-vm
```

The script will:
1. Install Tailscale if not present
2. Start the daemon
3. Display an auth URL - open it and sign in with Google
4. Connect to your tailnet

### NixOS

Tailscale is enabled in the NixOS config. After first boot:

```bash
sudo tailscale up --ssh
```

Open the displayed URL and authenticate with Google.

### Tailscale SSH

When you use `--ssh`, Tailscale SSH is enabled for passwordless access:

```bash
ssh user@hostname.tailnet-name.ts.net
```

No SSH keys needed - authentication is handled by Tailscale.

## Customization

### Adding a New Machine

1. **Linux (home-manager only)**:
   ```nix
   # In flake.nix, add to homeConfigurations:
   "user@machine-name" = home-manager.lib.homeManagerConfiguration {
     pkgs = nixpkgs.legacyPackages.x86_64-linux;
     modules = [ ./home/thin.nix ./home/linux.nix ];
   };
   ```

2. **macOS (nix-darwin)**:
   ```nix
   # In flake.nix, add to darwinConfigurations:
   "machine-name" = nix-darwin.lib.darwinSystem {
     system = "aarch64-darwin";
     modules = [
       ./darwin/configuration.nix
       home-manager.darwinModules.home-manager
       {
         home-manager.users.username = { ... }: {
           imports = [ ./home/full.nix ./home/darwin.nix ];
         };
       }
     ];
   };
   ```

3. **NixOS**:
   ```nix
   # In flake.nix, add to nixosConfigurations:
   "machine-name" = nixpkgs.lib.nixosSystem {
     system = "x86_64-linux";
     modules = [
       ./nixos/configuration.nix
       home-manager.nixosModules.home-manager
       {
         home-manager.users.username = { ... }: {
           imports = [ ./home/thin.nix ./home/linux.nix ];
         };
       }
     ];
   };
   ```

### Adding Packages

Edit the appropriate file:

- **All profiles**: `home/base.nix` → `home.packages`
- **Full profile only**: `home/full.nix` → `home.packages`
- **Linux-specific**: `home/linux.nix` → `home.packages`
- **macOS-specific**: `home/darwin.nix` → `home.packages`
- **NixOS system**: `nixos/configuration.nix` → `environment.systemPackages`
- **macOS system**: `darwin/configuration.nix` → `environment.systemPackages`

### Changing Shell Theme

Edit `home/p10k.zsh` or run `p10k configure` interactively.

### Changing Terminal Config

Edit `home/ghostty.conf` for Ghostty settings.

## Troubleshooting

### "command not found: home-manager"

Install home-manager or use nix run:

```bash
nix run home-manager -- switch --flake .#cooper@linux-thin
```

### "error: experimental Nix feature 'flakes' is disabled"

Your Nix installation doesn't have flakes enabled:

```bash
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
sudo systemctl restart nix-daemon  # Linux
sudo launchctl kickstart -k system/org.nixos.nix-daemon  # macOS
```

### Shell not switching to zsh

The `exec zsh` in `.bashrc` only runs for interactive sessions. Verify:

```bash
cat ~/.bashrc | grep "exec zsh"
```

If missing, re-run home-manager switch.

### Tailscale not connecting

```bash
# Check daemon status
sudo systemctl status tailscaled  # Linux
sudo tailscale status

# View logs
sudo journalctl -u tailscaled -f  # Linux
```

### Ghostty config not loading

On macOS, Ghostty looks for config at:
`~/Library/Application Support/com.mitchellh.ghostty/config`

The full profile symlinks this automatically.

## For AI Agents

When provisioning a new machine using this configuration:

1. **Detect the platform** (macOS ARM, Linux x86_64, NixOS)
2. **Install Nix** if not present (use Determinate installer)
3. **Clone this repo** to `~/dotenv`
4. **Run the appropriate command**:
   - Linux VM: `nix run home-manager -- switch --flake ~/dotenv#cooper@linux-thin`
   - macOS: `nix run nix-darwin -- switch --flake ~/dotenv#coopers-macbook-pro`
5. **Set up Tailscale** for network access:
   - Run: `~/dotenv/scripts/setup-tailscale.sh --ssh`
   - This displays a URL - the user must open it and authenticate with Google
6. **Verify** by checking `tailscale status` and `echo $SHELL`

The user's SSH public key is already configured in `nixos/configuration.nix`.

**Note**: Tailscale authentication requires user interaction (Google OAuth). The setup script will provide a URL that the user needs to open in their browser.
