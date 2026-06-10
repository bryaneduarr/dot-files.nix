{ pkgs, lib, ... }:
let
  activationPath = lib.makeBinPath [
    pkgs.bun
    pkgs.nodejs_latest
    pkgs.coreutils
    pkgs.bash
    pkgs.git
  ];

  bunGlobalInstall = packages: ''
    export PATH="${activationPath}:$PATH"
    export BUN_INSTALL="$HOME/.bun"

    ${lib.concatMapStringsSep "\n" (pkg: ''${pkgs.bun}/bin/bun install -g "${pkg}"'') packages}
  '';
in
{
  home.packages = with pkgs; [
    awscli2
    bat
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
    eza
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
    nil
    nixfmt
    nodejs_latest
    openssh
    openssl
    pnpm
    posting
    python3
    redis
    ripgrep
    socat
    ssm-session-manager-plugin
    statix
    uv
    valgrind
    wget
    xclip
    yazi
    tailscale
    terraform
    tmux
    tree
  ];

  home.activation = {
    installBunGlobalPackages = lib.hm.dag.entryAfter [ "linkGeneration" ] (bunGlobalInstall [
      "opencode-ai@latest"
      "@github/copilot"
      "@openai/codex"
      "tree-sitter-cli"
      "npm-check-updates"
      "agent-browser"
      "skills"
    ]);
  };
}
