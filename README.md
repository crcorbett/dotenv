# dotenv

Reproducible development environment using Nix flakes.

## Quick Start

### Install Nix

```bash
# macOS/Linux
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### Use Development Shell

```bash
# Enter dev shell with all tools
nix develop

# Or run a command directly
nix develop -c tmux
```

### Apply Home Configuration

```bash
# On macOS
home-manager switch --flake .#cooper@darwin

# On Linux
home-manager switch --flake .#cooper@linux
```

### Apply System Configuration

```bash
# macOS (nix-darwin)
darwin-rebuild switch --flake .#coopers-macbook-pro

# NixOS
sudo nixos-rebuild switch --flake .#development-vm
```

## What's Included

### Tools
- tmux (with Ctrl+A prefix)
- git, gh (GitHub CLI)
- ripgrep, fd, jq
- tailscale
- htop, curl, wget

### Configurations

#### tmux
- Prefix: `Ctrl+A` (not Ctrl+B)
- Split: `Ctrl+A |` (vertical), `Ctrl+A -` (horizontal)
- Switch panes: `Alt+Arrow`
- Mouse support enabled

#### SSH
- Key-only authentication
- Hardened settings
- `dev-vm` alias for Tailscale VM (100.126.134.39)

#### Shell Aliases
- `ta` - tmux attach
- `tl` - tmux list
- `tn` - tmux new session
- `gs/gp/gl` - git status/push/pull

## Structure

```
.
├── flake.nix           # Main entry point
├── home/
│   ├── common.nix      # Shared home-manager config
│   ├── darwin.nix      # macOS-specific
│   └── linux.nix       # Linux-specific
├── darwin/
│   └── configuration.nix  # macOS system config
└── nixos/
    └── configuration.nix  # NixOS/VM config
```

## Adding New Machines

1. Add a new entry in `flake.nix` under the appropriate configuration
2. Customize host-specific settings in a new module
3. Run the appropriate rebuild command
