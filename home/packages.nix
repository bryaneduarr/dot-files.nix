# This file manages all of the user's packages.
{ pkgs, neovim-nightly-overlay, ... }:

{
  # Install all of the user packages in here.
  home.packages = with pkgs; [
    bat # A 'cat' clone with highlighting.
    btop
    bun
    cmake
    curl
    eza # Modern replacement for ls.
    fzf
    gcc
    git
    lazygit
    neovim-nightly-overlay.packages.${pkgs.system}.default # Neovim nightly build with latest features.
    nodejs_24
    pnpm
    posting
    wget
    yazi
    tmux
  ];
}
