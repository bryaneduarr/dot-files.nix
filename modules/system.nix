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
  programs.fish.enable = true; # Enable fish shell at the system level.

  security.sudo.enable = true; # Enable sudo command in the system.
  security.sudo.wheelNeedsPassword = true; # Every wheel user 'with sudo privileges' will be prompted to use the password.

  time.timeZone = "America/El_Salvador";

  # Install PostgreSQL CLI tools system-wide.
  environment.systemPackages = with pkgs; [
    postgresql_18
    engram
    gentle-ai
  ];

  environment.etc."os-release".text = ''
    NAME="NixOS"
    VERSION="26.05 (Yarara)"
    ID=nixos
    ID_LIKE="ubuntu debian"
    VERSION_ID="26.05"
    PRETTY_NAME="NixOS 26.05 (Yarara)"
    HOME_URL="https://nixos.org/"
    BUG_REPORT_URL="https://github.com/NixOS/nixpkgs/issues"
  '';

  # Enable and configure PostgreSQL service.
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;
  };

  # Enable SSH.
  services.openssh.enable = true;

  # Enable Tailscale.
  services.tailscale.enable = true;

  # ARM64 emulation enable. Only enable when the host is not aarch64. Only enable if you want "emulation of aarch64".
  #  boot.binfmt.emulatedSystems = if pkgs.stdenv.hostPlatform.system != "aarch64-linux" then [ "aarch64-linux" ] else [];

  # Enable Docker.
  virtualisation.docker.enable = true;

  # NixOS version configuration state always to the latest.
  system.stateVersion = "25.05";
}
