# This file manages all of the user's packages.
{ pkgs, lib, ... }:
{
  # Install all of the user packages in here.
  home.packages = with pkgs; [
    awscli2
    bat # A 'cat' clone with highlighting.
    biome
    btop
    bubblewrap
    bun
    cargo
    clang-tools
    cmake
    curl
    docker
    deadnix
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
    openssh
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
    tailscale
    terraform
    tmux
    tree
  ];

  home.activation = {
    installOpencode = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      ${pkgs.bun}/bin/bun install -g "opencode-ai@latest"
    '';

    installCopilotCLI = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      ${pkgs.bun}/bin/bun install -g "@github/copilot"
    '';

    installCodexCLI = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      ${pkgs.bun}/bin/bun install -g "@openai/codex"
    '';

    installBunPackages = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      ${pkgs.bun}/bin/bun install -g "tree-sitter-cli"
      ${pkgs.bun}/bin/bun install -g "npm-check-updates"
      ${pkgs.bun}/bin/bun install -g "agent-browser"
      ${pkgs.bun}/bin/bun install -g "skills"
    '';
  };
}
