{ config, pkgs, ... }:

{
  home.homeDirectory = "/Users/cooper";
  
  # macOS-specific packages
  home.packages = with pkgs; [
    # macOS tools
    coreutils  # GNU coreutils
    findutils  # GNU find
  ];
}
