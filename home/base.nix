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

  # Zsh with Oh My Zsh + Powerlevel10k
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;
    
    # Oh My Zsh
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    # Powerlevel10k setup
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initExtraFirst = ''
      # Enable Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';

    initExtra = ''
      # Load Powerlevel10k config
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      
      # Local bin
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };

  # Copy p10k config
  home.file.".p10k.zsh".source = ./p10k.zsh;

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

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  # Ensure zsh is used even when login shell is bash
  # On non-NixOS Linux, changing /etc/passwd requires root and shell in /etc/shells.
  # This pattern is widely used in the Nix community - bash execs into zsh on interactive start.
  # Safe on macOS where zsh is already default (this only runs if bash starts).
  programs.bash = {
    enable = true;
    initExtra = ''
      # If running interactively and zsh is available, switch to it
      if [[ $- == *i* ]] && command -v zsh &>/dev/null; then
        exec zsh
      fi
    '';
  };
}
