{ config, pkgs, ... }:

# Thin profile - minimal setup for servers/VMs
{
  imports = [ ./base.nix ];

  # Use bash (default)
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };
}
