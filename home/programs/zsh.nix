{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true; # Enable ZSH here too, it is also enabled in the 'configuration.nix' file.

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "jeffreytse/zsh-vi-mode"; }
        { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; }
      ];
    };
  
    # Inline shell customizations (functions, exports, prompts, etc.).
    initContent = ''
      # Function to update and rebuild the system using flakes.
      update() {
        sudo nixos-rebuild switch --flake ~/nix-config/#nixos "$@"
      }
  
      # Set the default editor to Neovim.
      export EDITOR=nvim

      # Source the Powerlevel10k theme and configuration.
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${config.home.homeDirectory}/.p10k.zsh
    '';
  };

  # Make sure the p10k package is available.
  home.packages = [
    pkgs.zsh-powerlevel10k
  ];

  # Tell where the configuration file for p10k is.
  home.file = {
    ".p10k.zsh".source = ./../.p10k.zsh;
  };
}
