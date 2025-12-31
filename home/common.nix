{ config, pkgs, ... }:

{
  home.username = "cooper";
  home.stateVersion = "24.05";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Common packages
  home.packages = with pkgs; [
    # Core tools
    git
    curl
    wget
    htop
    jq
    ripgrep
    fd
    tree
    
    # Networking
    tailscale
    
    # Development
    gh  # GitHub CLI
  ];

  # Tmux configuration
  programs.tmux = {
    enable = true;
    prefix = "C-a";  # Ctrl+A instead of Ctrl+B
    terminal = "screen-256color";
    historyLimit = 10000;
    escapeTime = 0;
    baseIndex = 1;
    
    extraConfig = ''
      # Ctrl+A as prefix (unbind Ctrl+B)
      unbind C-b
      bind C-a send-prefix
      
      # Split panes with | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      
      # Switch panes with Alt+arrow (no prefix)
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      
      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
      
      # Mouse support
      set -g mouse on
      
      # Don't rename windows automatically
      set -g allow-rename off
      
      # Status bar
      set -g status-style 'bg=#333333 fg=#ffffff'
      set -g status-left '[#S] '
      set -g status-right '%Y-%m-%d %H:%M'
    '';
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Cooper Corbett";
    # userEmail should be set per-machine or via git config
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "vim";
    };
  };

  # SSH configuration
  programs.ssh = {
    enable = true;
    
    # SSH hardening defaults
    extraConfig = ''
      # Security settings
      PasswordAuthentication no
      PubkeyAuthentication yes
      IdentitiesOnly yes
      
      # Keep connections alive
      ServerAliveInterval 60
      ServerAliveCountMax 3
      
      # Use modern key exchange
      KexAlgorithms curve25519-sha256@libssh.org,curve25519-sha256
    '';
    
    # Host aliases
    matchBlocks = {
      "dev-vm" = {
        hostname = "100.126.134.39";  # Tailscale IP
        user = "cooper";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  # Shell aliases
  home.shellAliases = {
    ll = "ls -la";
    gs = "git status";
    gp = "git push";
    gl = "git pull";
    ta = "tmux attach -t";
    tl = "tmux ls";
    tn = "tmux new -s";
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };
}
