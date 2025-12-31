{ config, pkgs, ... }:

{
  home.homeDirectory = "/home/cooper";
  
  # Linux-specific packages
  home.packages = with pkgs; [
    # System monitoring
    btop
    iotop
    
    # Networking
    iproute2
    nettools
  ];
}
