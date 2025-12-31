{ config, pkgs, lib, ... }:

# Full profile - complete development environment
{
  imports = [ ./base.nix ];

  # Additional packages for full setup
  home.packages = with pkgs; [
    # Additional dev tools
    bat           # better cat
    eza           # better ls
    fzf           # fuzzy finder
    zoxide        # smarter cd
    delta         # better git diff
    lazygit       # git TUI
    neovim        # editor
    
    # Language support
    nodejs_22
    python3
    
    # Fonts (for Ghostty)
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
  ];

  # Zsh with Oh My Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    # Oh My Zsh
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "docker"
        "kubectl"
        "fzf"
        "z"
        "history"
        "colored-man-pages"
      ];
    };

    # Additional zsh config
    initExtra = ''
      # Better history
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt SHARE_HISTORY
      
      # Use zoxide (smarter cd)
      eval "$(zoxide init zsh)"
      
      # FZF keybindings
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      
      # Better colors for ls
      alias ls='eza --icons'
      alias ll='eza -la --icons'
      alias cat='bat --style=plain'
    '';
    
    # Aliases (in addition to home.shellAliases)
    shellAliases = {
      lg = "lazygit";
      vim = "nvim";
      v = "nvim";
    };
  };

  # Set zsh as default shell indicator
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  # FZF configuration
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
    ];
  };

  # Bat (better cat)
  programs.bat = {
    enable = true;
    config = {
      theme = "TwoDark";
      style = "numbers,changes";
    };
  };

  # Ghostty terminal configuration
  xdg.configFile."ghostty/config".text = ''
    # Font
    font-family = JetBrainsMono Nerd Font
    font-size = 14
    
    # Theme - dark
    background = 1a1b26
    foreground = c0caf5
    
    # Cursor
    cursor-style = block
    cursor-style-blink = true
    
    # Window
    window-padding-x = 10
    window-padding-y = 10
    window-decoration = true
    
    # Colors (Tokyo Night inspired)
    palette = 0=#15161e
    palette = 1=#f7768e
    palette = 2=#9ece6a
    palette = 3=#e0af68
    palette = 4=#7aa2f7
    palette = 5=#bb9af7
    palette = 6=#7dcfff
    palette = 7=#a9b1d6
    palette = 8=#414868
    palette = 9=#f7768e
    palette = 10=#9ece6a
    palette = 11=#e0af68
    palette = 12=#7aa2f7
    palette = 13=#bb9af7
    palette = 14=#7dcfff
    palette = 15=#c0caf5
    
    # Keybindings
    keybind = cmd+t=new_tab
    keybind = cmd+w=close_surface
    keybind = cmd+shift+left=previous_tab
    keybind = cmd+shift+right=next_tab
    
    # Shell
    command = ${pkgs.zsh}/bin/zsh
    
    # Misc
    copy-on-select = clipboard
    confirm-close-surface = false
    mouse-hide-while-typing = true
  '';

  # Neovim basic config
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      set number
      set relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set smartindent
      set termguicolors
      set mouse=a
      set clipboard=unnamedplus
      set ignorecase
      set smartcase
      set updatetime=300
    '';
  };

  # Starship prompt (alternative to oh-my-zsh theme)
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch = {
        symbol = " ";
      };
      git_status = {
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?\${count}";
        stashed = "$\${count}";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "✘\${count}";
      };
    };
  };
}
