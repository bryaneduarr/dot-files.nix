# Central point file for the home-manager for the user.
{ config, pkgs, ... }:

{
  # Link this 'stateVersion' with the one on the 'configuration.nix' file.
  home.stateVersion = "25.05";

  imports = [
    # Here is where we will install of the nix packages.
    ./packages.nix

    # Programs installed configuration will be placed here.
    ./programs/git.nix
    ./programs/zsh.nix
  ];
}
