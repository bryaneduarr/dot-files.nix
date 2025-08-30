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

    # Using yazi plugins as custom flake.
    yazi-plugins = {
      url = "github:yazi-rs/plugins"; # Pointing to the yazi plugins GitHub repository.
      flake = false; # This repository does not have a flake.nix file.
    };

    # Using yazi flavors as custom flake.
    yazi-flavors = {
      url = "github:yazi-rs/flavors"; # Pointing to the yazi flavors GitHub repository.
      flake = false; # This repository does not have a flake.nix file.
    };
  };

  outputs = { self, nixpkgs, home-manager, nixos-wsl, yazi-plugins, yazi-flavors, ... }: {
    # This configuration is named 'nixos' and follows the standard 'nixpkgs' library to build the NixOS system.
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # Using the 'x86_64' system architecture.

      # Allow unfree packages in this flake.
      specialArgs = {
        inherit nixpkgs;
      };

      modules = [
        # Import modular system configuration here 'modules'.
        ./modules/system.nix # General system configuration for NixOS.
	      ./modules/users.nix  # User specific configuration for the NixOS.

        home-manager.nixosModules.home-manager # Import the home-manager configuration to manage user-specific configurations.

        nixos-wsl.nixosModules.default # Import the main WSL2 flake module for NixOS-WSL system.

        # Configure nixpkgs to allow unfree packages.
        ({ config, ... }: {
          nixpkgs.config.allowUnfree = true;
        })

        {
          wsl.enable = true; # Enable WSL2 in this system configuration.
          wsl.defaultUser = "bryaneduarr"; # Setting the default user at startup of any instance.

          home-manager.useGlobalPkgs = true; # Tell home-manager to use the global Nix packages that are available in the system.

          home-manager.useUserPackages = true; # Enable using user-specific packages with home-manager.

          home-manager.extraSpecialArgs = {
            inherit yazi-plugins yazi-flavors; # Pass the yazi 'yazi-plugins', and 'yazi-flavors' to the home-manager configurations.
          };

          home-manager.users.bryaneduarr = import ./home/default.nix; # Enable the configuration we have in our system to be used with home-manager.

          programs.nix-ld.enable = true; # Enables the nix-ld program, which allows running dynamically linked binaries that are not built with Nix by providing a compatible dynamic linker and libraries. This was used for Visual Studio Code to open correctly.
        }
      ];
    };
  };
}
