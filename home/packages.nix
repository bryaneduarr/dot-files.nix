# This file manages all of the user's packages.
{ pkgs, ... }:

{
  # Install all of the user packages in here.
  home.packages = with pkgs; [
    btop
    cmake
    curl
    gcc
    git
    neovim
    wget
  ];
}
