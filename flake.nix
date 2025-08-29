{
  description = "Main Flake Configuration";

  inputs = {
    # Using the unstable channel for nix packages.
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Manage user configurations with home-manager.
    home-manager = {
      url = "github:nix-community/home-manager"; # Pointing to home-manager GitHub repository.

      inputs.nixpkgs.follows = "nixpkgs"; # Ensure home-manager follows the same version as the 'nixpkgs' to prevent mismatches.
    };

    # NixOS-WSL flake, this provides specific configurations so NixOS runs correctly with WSL2.
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL"; # Pointing to NixOS-WSL GitHub repository.
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, ... }: {
    # This configuration is named 'nixos' and follows the standard 'nixpkgs' library to build the NixOS system.
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # Using the 'x86_64' system architecture.

      modules = [
        ./configuration.nix # Import the main 'configuration.nix' of this configuration.

        home-manager.nixosModules.home-manager # Import the home-manager configuration to manage user-specific configurations.

        nixos-wsl.nixosModules.default # Import the main WSL2 flake module for NixOS-WSL system.

        {
          wsl.enable = true; # Enable WSL2 in this system configuration.
          wsl.defaultUser = "bryaneduarr"; # Setting the default user at startup of any instance.

          home-manager.useGlobalPkgs = true; # Tell home-manager to use the global Nix packages that are available in the system.
          home-manager.useUserPackages = true; # Enable using user-specific packages with home-manager.
          home-manager.users.bryaneduarr = import ./home.nix; # Enable the configuration we have in our system to be used with home-manager.

	  programs.nix-ld.enable = true;
        }
      ];
    };
  };
}
