# This file manages the user's Git configuration.
{ ... }:

{
  # Git user and email setup.
  programs.git = {
    enable = true;
    userName = "bryaneduarr";
    userEmail = "bryaneduarr@gmail.com";
  };
}
