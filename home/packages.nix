# This file manages all of the user's packages.
{ pkgs, lib, ... }:

{
  # Install all of the user packages in here.
  home.packages = with pkgs; [
    awscli2
    bat # A 'cat' clone with highlighting.
    btop
    bun
    clang-tools
    cmake
    curl
    eza # Modern replacement for ls.
    fastfetch
    fd
    fzf
    gdb
    gcc
    git
    gnumake
    jq
    lazygit
    lsof
    neovim
    nodejs_24
    nodePackages.npm-check-updates
    openssl
    pnpm
    posting
    python3
    redis
    ripgrep
    ssm-session-manager-plugin # Session manager plugin for aws.
    uv
    valgrind
    wget
    xclip
    yazi
    tmux
    tree
  ];
}
