# This file manages all of the user's packages.
{ pkgs, ... }:

{
  # Install all of the user packages in here.
  home.packages = with pkgs; [
    bat # A 'cat' clone with highlighting.
    btop
    cmake
    curl
    eza # Modern replacement for ls.
    fzf
    gcc
    git
    neovim
    wget
    yazi
  ];
}
