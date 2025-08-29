# This file contains general system settings for NixOS WSL2.
# System configuration, Nix library collection and The unstable channel packages.
{ config, lib, pkgs, ... }:

{
  # Enable better Nix commands for interaction. Enable NixOS experimental flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  programs.zsh.enable = true; # Enable in the system to have ZSH as a shell.

  security.sudo.enable = true; # Enable sudo command in the system.
  security.sudo.wheelNeedsPassword = true; # Every wheel user 'with sudo privileges' will be prompted to use the password.

  # NixOS version configuration state always to the latest.
  system.stateVersion = "25.05";
}
