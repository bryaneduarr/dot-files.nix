# This file manages all of the user's packages.
{ pkgs, neovim-nightly-overlay, ... }:

{
  # Install all of the user packages in here.
  home.packages = with pkgs; [
    awscli2
    bat # A 'cat' clone with highlighting.
    btop
    bun
    cmake
    curl
    eza # Modern replacement for ls.
    fd
    fzf
    gcc
    git
    gnumake
    lazygit
    neovim-nightly-overlay.packages.${pkgs.system}.default # Neovim nightly build with latest features.
    nodejs_24
    opencode
    pnpm
    posting
    wget
    yazi
    tmux
  ];
}
