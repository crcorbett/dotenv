{ config, pkgs, lib, ... }:

# Full profile - complete development environment (workstations)
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

  # Extend zsh with workstation-specific config
  programs.zsh.initExtra = lib.mkAfter ''
    # NVM (if installed)
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # pnpm (macOS path)
    export PNPM_HOME="$HOME/Library/pnpm"
    case ":$PATH:" in
      *":$PNPM_HOME:"*) ;;
      *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
    
    # bun
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    
    # 1Password SSH agent (macOS)
    if [[ -S ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ]]; then
      export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
    fi
  '';
  
  programs.zsh.shellAliases = {
    lg = "lazygit";
    vim = "nvim";
    v = "nvim";
  };

  # Ghostty config (macOS location)
  home.file."Library/Application Support/com.mitchellh.ghostty/config".source = ./ghostty.conf;

  # Override editor to neovim
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
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
