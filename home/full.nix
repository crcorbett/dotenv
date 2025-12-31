{ config, pkgs, lib, ... }:

# Full profile - complete development environment
{
  imports = [ ./base.nix ];

  # Additional packages for full setup
  home.packages = with pkgs; [
    # Dev tools
    bat           # better cat
    eza           # better ls
    fzf           # fuzzy finder
    zoxide        # smarter cd
    delta         # better git diff
    lazygit       # git TUI
    neovim        # editor
    
    # Fonts (for terminal - MesloLGS NF is used by p10k/ghostty)
    (nerdfonts.override { fonts = [ "Meslo" "JetBrainsMono" "FiraCode" ]; })
  ];

  # Zsh with Oh My Zsh + Powerlevel10k
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = false;  # Not enabled in your config
    syntaxHighlighting.enable = false;  # Not enabled in your config
    
    # Oh My Zsh
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];  # Minimal - matches your .zshrc
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
      
      # NVM (if installed)
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      
      # pnpm
      export PNPM_HOME="$HOME/Library/pnpm"
      case ":$PATH:" in
        *":$PNPM_HOME:"*) ;;
        *) export PATH="$PNPM_HOME:$PATH" ;;
      esac
      
      # bun
      export BUN_INSTALL="$HOME/.bun"
      export PATH="$BUN_INSTALL/bin:$PATH"
      
      # Local bin
      export PATH="$HOME/.local/bin:$PATH"
      
      # 1Password SSH agent (macOS)
      if [[ -S ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ]]; then
        export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
      fi
    '';
    
    shellAliases = {
      lg = "lazygit";
      vim = "nvim";
      v = "nvim";
    };
  };

  # Copy p10k config
  home.file.".p10k.zsh".source = ./p10k.zsh;

  # Ghostty config (macOS location)
  home.file."Library/Application Support/com.mitchellh.ghostty/config".source = ./ghostty.conf;

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
}
