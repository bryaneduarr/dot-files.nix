# This file manages all of the user's packages.
{ pkgs, lib, ... }:
{
  # Install all of the user packages in here.
  home.packages = with pkgs; [
    awscli2
    bat # A 'cat' clone with highlighting.
    biome
    btop
    bun
    cargo
    clang-tools
    cmake
    curl
    deadnix
    docker
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
    mpv
    neovim
    nil
    nixfmt
    nodejs_25
    nodePackages.npm-check-updates
    openssl
    pnpm
    posting
    python3
    redis
    ripgrep
    socat
    ssm-session-manager-plugin # Session manager plugin for aws.
    statix
    uv
    valgrind
    wget
    xclip
    yazi
    ytm-player
    tmux
    tree
  ];

  home.activation.installBunPackages = lib.hm.dag.entryAfter ["linkGeneration"] ''
    ${pkgs.bun}/bin/bun install -g "tree-sitter-cli"
  '';
}
