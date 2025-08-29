# This file defines all system users and groups.
{ config, lib, pkgs, ... }:

{
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
        shell = pkgs.zsh; # Set the default shell for this user to ZSH.
      };
    };

    # Add here all of the created groups.
    groups = {
      bryaneduarr = {}; # No options for this group.
    };
  };
}
