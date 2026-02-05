# This file contains general system settings for NixOS WSL2.
# System configuration, Nix library collection and The unstable channel packages.
{ config, lib, pkgs, ... }:

{
  # Enable better Nix commands for interaction. Enable NixOS experimental flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true; # Enable in the system to have ZSH as a shell.

  security.sudo.enable = true; # Enable sudo command in the system.
  security.sudo.wheelNeedsPassword = true; # Every wheel user 'with sudo privileges' will be prompted to use the password.

  time.timeZone = "America/El_Salvador";

  # Install PostgreSQL CLI tools system-wide.
  environment.systemPackages = with pkgs; [
    postgresql
  ];

  # Enable and configure PostgreSQL service.
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;
  };

  # Enable Docker.
  virtualisation.docker.enable = true;

  # NixOS version configuration state always to the latest.
  system.stateVersion = "25.05";
}
