{ config, pkgs, ... }:

{
  # =============================================================================
  # Nix Settings
  # =============================================================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # =============================================================================
  # System Packages
  # =============================================================================
  environment.systemPackages = with pkgs; [
    # Core tools installed system-wide
    git
    vim
  ];

  # =============================================================================
  # macOS System Preferences
  # =============================================================================
  system.defaults = {
    # Dock
    dock = {
      autohide = true;
      show-recents = false;
      minimize-to-application = true;
    };

    # Finder
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };

    # Global
    NSGlobalDomain = {
      # Dark mode
      AppleInterfaceStyleSwitchesAutomatically = true;
      
      # Disable UI sounds
      "com.apple.sound.beep.volume" = 0.0;
      "com.apple.sound.uiaudio.enabled" = false;
      
      # Scrolling
      AppleShowScrollBars = "WhenScrolling";
      
      # Keyboard
      ApplePressAndHoldEnabled = false;  # Enable key repeat
      
      # Mouse
      "com.apple.mouse.scaling" = 1.5;
    };

    # Login window
    loginwindow = {
      GuestEnabled = false;
    };

    # Screenshots
    screencapture = {
      location = "~/Desktop";
      type = "png";
    };
  };

  # =============================================================================
  # Text Replacements
  # =============================================================================
  system.defaults.NSGlobalDomain.NSUserDictionaryReplacementItems = [
    { on = true; replace = "@@"; "with" = "coopercorbett@gmail.com"; }
    { on = true; replace = "@&"; "with" = "cooper.corbett@tilt.legal"; }
    { on = true; replace = "omw"; "with" = "On my way!"; }
  ];

  # =============================================================================
  # Services
  # =============================================================================
  services.tailscale.enable = true;

  # =============================================================================
  # Security
  # =============================================================================
  security.pam.enableSudoTouchIdAuth = true;

  # =============================================================================
  # System State Version
  # =============================================================================
  system.stateVersion = 5;
}
