{ config, pkgs, ... }:

# Base configuration shared by both thin and full profiles
{
  home.username = "cooper";
  home.stateVersion = "24.05";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # Core packages (minimal)
  home.packages = with pkgs; [
    git
    curl
    wget
    htop
    jq
    ripgrep
    fd
    tree
    tailscale
    gh
  ];

  # Tmux configuration
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    terminal = "screen-256color";
    historyLimit = 10000;
    escapeTime = 0;
    baseIndex = 1;
    
    extraConfig = ''
      unbind C-b
      bind C-a send-prefix
      
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
      
      set -g mouse on
      set -g allow-rename off
      
      set -g status-style 'bg=#333333 fg=#ffffff'
      set -g status-left '[#S] '
      set -g status-right '%Y-%m-%d %H:%M'
    '';
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Cooper Corbett";
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
    extraConfig = ''
      PasswordAuthentication no
      PubkeyAuthentication yes
      IdentitiesOnly yes
      ServerAliveInterval 60
      ServerAliveCountMax 3
      KexAlgorithms curve25519-sha256@libssh.org,curve25519-sha256
    '';
    matchBlocks = {
      "dev-vm" = {
        hostname = "100.126.134.39";
        user = "cooper";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  # Shell aliases (work in both bash and zsh)
  home.shellAliases = {
    ll = "ls -la";
    gs = "git status";
    gp = "git push";
    gl = "git pull";
    ta = "tmux attach -t";
    tl = "tmux ls";
    tn = "tmux new -s";
  };

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };
}
