# System configuration, Nix library collection and The unstable channel packages.
{ config, lib, pkgs, ... }:

{
  # Enable better Nix commands for interaction. Enable NixOS experimental flakes.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users = {
    # Define all of the users inside of here.
    users = {
      bryaneduarr = {
        isNormalUser = true; # Standard normal user.
        description = "Bryan Eduardo"; # Just name and second name.
        extraGroups = [ "wheel" "networkmanager" ]; # Allow this user to have 'sudo' privileges with 'wheel' and network permissions.
        group = "bryaneduarr"; # The group will be the same as the name.
        home = "/home/bryaneduarr"; # Home directory of the user.
        createHome = true; # Create a home directory if it doesn't exist.
        shell = pkgs.bash; # Default shell for the user will be 'bash'.
      };
    };
    
    # Add here all of the created groups.
    groups = {
      bryaneduarr = {}; # No options for this group.
    };
  };

  security.sudo.enable = true; # Enable sudo command in the system.
  security.sudo.wheelNeedsPassword = true; # Every wheel user 'with sudo privileges' will be prompted to use the password.

  # NixOS version configuration state always to the latest.
  system.stateVersion = "25.05";
}
