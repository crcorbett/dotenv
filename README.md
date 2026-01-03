# Cooper's Dotfiles

Reproducible development environment using Nix flakes, home-manager, and nix-darwin.

## Overview

Two configurations:

| Config | Platform | Use Case | Command |
|--------|----------|----------|---------|
| `cooper@linux` | Linux x86_64 | VMs, servers (headless) | `home-manager switch --flake .#cooper@linux` |
| `coopers-macbook-pro` | macOS ARM | Workstation (full setup) | `darwin-rebuild switch --flake .#coopers-macbook-pro` |

## Quick Start

### Prerequisites

Install Nix with flakes:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### New Linux VM

```bash
git clone https://github.com/crcorbett/dotenv.git ~/dotenv
cd ~/dotenv

nix run home-manager -- switch --flake .#cooper@linux

./scripts/setup-tailscale.sh --ssh

cp .secrets.example ~/.secrets
# Edit ~/.secrets with your API keys
```

### New macOS Workstation

```bash
git clone https://github.com/crcorbett/dotenv.git ~/dotenv
cd ~/dotenv

nix run nix-darwin -- switch --flake .#coopers-macbook-pro

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
│   ├── core.nix              # Shared: CLI tools, dotfiles, mosh
│   ├── workstation.nix       # macOS: fonts, app configs (Ghostty/Zed/Cursor)
│   ├── p10k.zsh              # Powerlevel10k theme
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
├── nixos/
│   └── configuration.nix     # NixOS system config (if needed)
│
├── configs/                  # Workstation app configs (macOS)
│   ├── zed/
│   │   ├── settings.json
│   │   └── keymap.json
│   └── cursor/
│       └── settings.json
│
├── scripts/
│   ├── setup-tailscale.sh    # Tailscale install + auth
│   └── exit_node_setup.sh    # Configure VM as exit node
│
├── APPS.md                   # Manual app installation list
├── .secrets.example          # Template for secrets file
└── README.md
```

## What's Included

### Both Platforms (core.nix)

- **Shell**: zsh + oh-my-zsh + Powerlevel10k
- **Tools**: git, gh, ripgrep, fd, fzf, eza, zoxide, delta, lazygit, neovim
- **Network**: mosh (low-latency SSH for high-latency connections)
- **Git**: 1Password SSH commit signing

### macOS Workstation (workstation.nix + darwin/system.nix)

- **Fonts**: Nerd Fonts (Meslo, JetBrains Mono)
- **App configs**: Ghostty, Zed, Cursor
- **System prefs**: Dock autohide, dark mode, text replacements
- **Services**: Tailscale, Touch ID for sudo

## Secrets

API keys and tokens are stored in `~/.secrets` (not in repo):

```bash
cp .secrets.example ~/.secrets
vim ~/.secrets
```

The zshrc automatically sources this file if it exists.

## Tailscale

### Linux VM (Client)

```bash
./scripts/setup-tailscale.sh --ssh
```

Opens a URL - authenticate with Google.

### Linux VM (Exit Node)

To configure a VM as a Tailscale exit node (VPN endpoint):

```bash
./scripts/setup-tailscale.sh --exit-node
./scripts/exit_node_setup.sh
```

Then approve the exit node in [Tailscale admin console](https://login.tailscale.com/admin/machines).

The exit node script configures:
- IP forwarding (IPv4 + IPv6)
- UDP GRO optimization for better throughput
- Persistence across reboots

### macOS

Tailscale is enabled via nix-darwin. After first run:

```bash
tailscale up --ssh
```

### Using an Exit Node

From any Tailscale device:

```bash
tailscale up --exit-node=<exit-node-ip>
```

## Mosh (Mobile Shell)

For high-latency connections (e.g., UK → Australia), use mosh instead of SSH:

```bash
mosh user@hostname
```

Mosh provides local echo and handles connection interruptions gracefully.

## Shell Aliases

| Alias | Command |
|-------|---------|
| `ll` | `ls -la` |
| `gs` | `git status` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `lg` | `lazygit` |
| `vim`, `v` | `nvim` |

## Text Replacements (macOS)

| Type | Expands To |
|------|------------|
| `@@` | coopercorbett@gmail.com |
| `@&` | cooper.corbett@tilt.legal |
| `omw` | On my way! |

## Updating Nix Packages

```bash
cd ~/dotenv
nix flake update
darwin-rebuild switch --flake .#coopers-macbook-pro  # or home-manager for Linux
```

## Adding Packages

Edit the appropriate file:

- **All platforms**: `home/core.nix` → `home.packages`
- **macOS only**: `home/workstation.nix` → `home.packages`
- **macOS system**: `darwin/system.nix` → `environment.systemPackages`

## Git Commit Signing

All commits are automatically signed using SSH keys stored in 1Password. No special commands needed — `git commit` just works.

### Architecture

```
gitconfig (base)
├── commit.gpgsign = true             # Auto-sign all commits
├── user.signingkey = ssh-ed25519...  # Public key
├── gpg.format = ssh
│
├── [includeIf "gitdir:/Users/"]      # macOS
│   └── gitconfig-macos
│       └── program = /Applications/1Password.app/.../op-ssh-sign
│
└── [includeIf "gitdir:/home/"]       # Linux
    └── gitconfig-linux
        └── program = ~/.local/bin/op-ssh-sign-headless
```

### macOS (Desktop)

Uses 1Password desktop app's built-in `op-ssh-sign` binary. Requires:
- 1Password desktop app installed
- SSH agent enabled in 1Password settings
- SSH key added to 1Password

### Linux Headless VMs

Uses a custom script (`op-ssh-sign-headless`) that fetches the SSH key from 1Password CLI on-demand. The private key only exists in memory during signing.

**Setup:**

1. Sign in to 1Password CLI ([manual sign-in docs](https://developer.1password.com/docs/cli/sign-in-manually)):
   ```bash
   op account add --address my.1password.com --email you@example.com
   eval $(op signin)
   ```

2. Verify it works:
   ```bash
   op vault list  # Should show your vaults
   ```

The signing script (`~/.local/bin/op-ssh-sign-headless`) is automatically installed by home-manager.

**How it works:**
```
git commit
  → op-ssh-sign-headless
    → fetches private key from 1Password (op CLI)
    → signs commit with ssh-keygen
    → deletes key from disk immediately
  → signed commit created
```

**Requirements:**
- 1Password CLI signed in (`op signin`)
- 1Password item named "Github commit signing" in "Development" vault

### GitHub Setup

For commits to show as "Verified" on GitHub:

1. Go to [GitHub SSH Keys](https://github.com/settings/keys)
2. Click **New SSH key**
3. Set **Key type: Signing Key** (not Authentication)
4. Paste your public key
5. Ensure your commit email matches a verified email on your GitHub account

### Troubleshooting

| Issue | Solution |
|-------|----------|
| "Unverified" on GitHub | Add key as **Signing Key** (not just Authentication) in GitHub settings |
| "Permission denied" on gitconfig | Edit source in `~/dotenv/home/dotfiles/`, rebuild with `home-manager switch` |
| Signing fails on Linux | Check `OP_SERVICE_ACCOUNT_TOKEN` is set: `op vault list` |
| "Couldn't get agent socket" | The headless script handles this — ensure you're using the latest version |

## License

Personal configuration - feel free to fork and adapt.
