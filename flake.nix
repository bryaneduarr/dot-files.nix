{
  description = "Main Flake Configuration";

  inputs = {
    # Using the unstable channel for nix packages.
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # Manage user configurations with home-manager.
    home-manager = {
      url = "github:nix-community/home-manager?ref=master"; # Pointing to home-manager GitHub repository, using master branch to match nixpkgs unstable.

      inputs.nixpkgs.follows = "nixpkgs"; # Ensure home-manager follows the same version as the 'nixpkgs' to prevent mismatches.
    };

    # NixOS-WSL flake, this provides specific configurations so NixOS runs correctly with WSL2.
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL"; # Pointing to NixOS-WSL GitHub repository.
    };

    # ytm-player - YouTube Music player for the terminal.
    ytm-player = {
      url = "github:peternaame-boop/ytm-player"; # Pointing to ytm-player GitHub repository.
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure ytm-player follows the same version as 'nixpkgs'.
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

    # Using TPM (Tmux Plugin Manager) as custom flake.
    tmux-tpm = {
      url = "github:tmux-plugins/tpm"; # Pointing to the TPM GitHub repository.
      flake = false; # This repository does not have a flake.nix file.
    };

    # Engram persistent memory flake.
    engram = {
      url = "path:./flakes/engram"; # Local engram flake.
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-wsl,
      ytm-player,
      yazi-plugins,
      yazi-flavors,
      tmux-tpm,
      engram,
      ...
    }:
    {
      # This configuration is named 'nixos' and follows the standard 'nixpkgs' library to build the NixOS system.
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux"; # Change this to x86_64-linux for that architecture.

        # Allow unfree packages in this flake.
        specialArgs = {
          inherit nixpkgs;
        };

        modules = [
          # Import modular system configuration here 'modules'.
          ./modules/system.nix # General system configuration for NixOS.
          ./modules/users.nix # User specific configuration for the NixOS.

          home-manager.nixosModules.home-manager # Import the home-manager configuration to manage user-specific configurations.

          nixos-wsl.nixosModules.default # Import the main WSL2 flake module for NixOS-WSL system.

          # Configure nixpkgs to allow unfree packages and apply overlays.
          (_: {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [
              ytm-player.overlays.default
              # Override ytm-player to skip runtime dependency check
              (_: prev: {
                ytm-player = prev.ytm-player.overridePythonAttrs (_: {
                  dontCheckRuntimeDeps = true;
                });
              })
              # Engram persistent memory overlay, the one from the flake.
              (final: _: {
                engram = engram.packages.${final.stdenv.hostPlatform.system}.default;
              })
            ];
          })

          {
            wsl.enable = true; # Enable WSL2 in this system configuration.
            wsl.defaultUser = "bryaneduarr"; # Setting the default user at startup of any instance.

            home-manager = {
              useGlobalPkgs = true; # Tell home-manager to use the global Nix packages that are available in the system.

              useUserPackages = true; # Enable using user-specific packages with home-manager.

              extraSpecialArgs = {
                inherit yazi-plugins yazi-flavors tmux-tpm; # Pass to the home-manager custom plugins and configurations.
              };

              users.bryaneduarr = import ./home/default.nix; # Enable the configuration we have in our system to be used with home-manager.
            };

            programs.nix-ld.enable = true; # Enables the nix-ld program, which allows running dynamically linked binaries that are not built with Nix by providing a compatible dynamic linker and libraries. This was used for Visual Studio Code to open correctly.
          }
        ];
      };
    };
}
