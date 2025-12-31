{ config, pkgs, ... }:

{
  # Nix configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages available to all users
  environment.systemPackages = with pkgs; [
    vim
    git
    tmux
    tailscale
  ];

  # Enable Tailscale
  services.tailscale.enable = true;

  # macOS system preferences
  system.defaults = {
    dock = {
      autohide = true;
      orientation = "bottom";
      show-recents = false;
    };
    
    finder = {
      AppleShowAllFiles = true;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };
  };

  # Keyboard settings
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;  # Caps Lock -> Control
  };

  # Create /etc/zshrc that loads nix-darwin environment
  programs.zsh.enable = true;

  # Used for backwards compatibility
  system.stateVersion = 4;
}
