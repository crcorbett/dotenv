{ config, pkgs, lib, ... }:

# Core configuration - shared by all machines (Linux thin + macOS workstation)
{
  home.username = "cooper";
  home.stateVersion = "24.05";

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # =============================================================================
  # Packages
  # =============================================================================
  home.packages = with pkgs; [
    # Core CLI tools
    git
    gh
    curl
    wget
    htop
    btop
    jq
    tree
    tmux
    
    # Search & navigation
    ripgrep
    fd
    fzf
    eza
    zoxide
    
    # Git tools
    delta
    lazygit
    
    # Editor
    neovim
    
    # Python tooling
    uv
    
    # Networking
    tailscale
    mosh
  ] ++ lib.optionals stdenv.isLinux [
    # Docker (macOS uses OrbStack instead)
    docker
    docker-compose
  ];

  # =============================================================================
  # Dotfiles
  # =============================================================================
  home.file = {
    ".zshrc".source = ./dotfiles/zshrc;
    ".p10k.zsh".source = ./dotfiles/p10k.zsh;
    ".gitconfig".source = ./dotfiles/gitconfig;
    ".gitconfig-macos".source = ./dotfiles/gitconfig-macos;
    ".gitconfig-linux".source = ./dotfiles/gitconfig-linux;
    ".ssh/config".source = ./dotfiles/ssh_config;
  };

  # =============================================================================
  # Zsh (for installing zsh itself)
  # =============================================================================
  programs.zsh = {
    enable = true;
    # Config is managed via dotfiles/zshrc
  };

  # =============================================================================
  # Oh My Zsh + Powerlevel10k
  # =============================================================================
  programs.zsh.oh-my-zsh = {
    enable = true;
    plugins = [ "git" ];
  };

  programs.zsh.plugins = [
    {
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
  ];

  # =============================================================================
  # Session Variables
  # =============================================================================
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # =============================================================================
  # Shell Aliases
  # =============================================================================
  home.shellAliases = {
    ll = "ls -la";
    gs = "git status";
    gp = "git push";
    gl = "git pull";
    ta = "tmux attach -t";
    tl = "tmux ls";
    tn = "tmux new -s";
    lg = "lazygit";
    vim = "nvim";
    v = "nvim";
  };

  # =============================================================================
  # Bash (for exec to zsh on Linux)
  # =============================================================================
  programs.bash = {
    enable = true;
    initExtra = ''
      # If running interactively and zsh is available, switch to it
      if [[ $- == *i* ]] && command -v zsh &>/dev/null; then
        exec zsh
      fi
    '';
  };

  # =============================================================================
  # AI Coding CLIs (installed outside Nix for auto-updates)
  # =============================================================================
  home.activation = {
    installAiClis = lib.hm.dag.entryAfter ["writeBoundary"] ''
      # Claude Code
      if ! command -v claude &>/dev/null; then
        echo "Installing Claude Code..."
        $DRY_RUN_CMD ${pkgs.curl}/bin/curl -fsSL https://claude.ai/install.sh | $DRY_RUN_CMD sh
      fi

      # OpenCode
      if ! command -v opencode &>/dev/null; then
        echo "Installing OpenCode..."
        $DRY_RUN_CMD ${pkgs.curl}/bin/curl -fsSL https://opencode.ai/install | $DRY_RUN_CMD bash
      fi

      # Codex (OpenAI) - requires npm
      if ! command -v codex &>/dev/null && command -v npm &>/dev/null; then
        echo "Installing Codex..."
        $DRY_RUN_CMD npm install -g @openai/codex
      fi
    '';
  };
}
