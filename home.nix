{ config, pkgs, ... }:

{
  # Link this 'stateVersion' with the one on the 'configuration.nix' file.
  home.stateVersion = "25.05";  

  # Install all of the user packages in here.
  home.packages = with pkgs; [
    # Place all of the packages in here.
    git
    neovim
    btop
    wget
    curl
    gcc
    cmake
    fastfetch
  ];

  # Enable to bashe be the default shell.
  programs.bash.enable = true;
  
  # Function to update only with alias 'update'.
  programs.bash.initExtra = ''
    update() {
      sudo nixos-rebuild switch --flake ~/nix-config/#nixos "$@"
    }
  '';

  # Git user and email setup.
  programs.git = {
    enable = true;
    userName = "bryaneduarr";
    userEmail = "bryaneduarr@gmail.com";
  };
}
