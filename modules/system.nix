# This file contains general system settings for NixOS WSL2.
# System configuration, Nix library collection and The unstable channel packages.
{ pkgs, lib, ... }:
{
  # Enable better Nix commands for interaction. Enable NixOS experimental flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.zsh.enable = true; # Enable in the system to have ZSH as a shell.

  security.sudo.enable = true; # Enable sudo command in the system.
  security.sudo.wheelNeedsPassword = true; # Every wheel user 'with sudo privileges' will be prompted to use the password.

  time.timeZone = "America/El_Salvador";

  # Install PostgreSQL CLI tools system-wide.
  environment.systemPackages = with pkgs; [
    postgresql
    engram
  ];

  # Enable and configure PostgreSQL service.
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;
  };

  # ARM64 emulation enable.
  # Only enable emulated aarch64 when the host platform is different from aarch64.
  # The binfmt registration code asserts that you must not register the same
  # system as the host (it's unnecessary and triggers an assertion), so keep
  # this conditional to avoid that failure when building on aarch64 hosts.
  boot.binfmt.emulatedSystems = lib.optional (pkgs.stdenv.hostPlatform.system != "aarch64-linux") [ "aarch64-linux" ];

  # Enable Docker.
  virtualisation.docker.enable = true;

  # NixOS version configuration state always to the latest.
  system.stateVersion = "25.05";
}
