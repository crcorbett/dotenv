{ config, pkgs, ... }:

# Thin profile - servers/VMs with zsh but no heavy extras
{
  imports = [ ./base.nix ];

  # Thin profile uses base zsh/p10k setup, no additional packages
}
