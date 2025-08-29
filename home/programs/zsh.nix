{ ... }:

{
  programs.zsh = {
    enable = true; # Enable ZSH here too, it is also enabled in the 'configuration.nix' file.
  
    # Inline shell customizations (functions, exports, prompts, etc.).
    initContent = ''
      # Function to update and rebuild the system using flakes.
      update() {
        sudo nixos-rebuild switch --flake ~/nix-config/#nixos "$@"
      }
  
      # Set the default editor to Neovim.
    export EDITOR=nvim
    '';
  };
}
