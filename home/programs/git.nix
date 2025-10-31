# This file manages the user's Git configuration.
{ ... }:

{
  # Git user and email setup.
  programs.git.settings = {
    enable = true;
    userName = "bryaneduarr";
    userEmail = "bryaneduarr@gmail.com";
  };
}
