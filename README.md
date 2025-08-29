# Dot-Files NixOS WSL2

Declarative [NixOS](https://nixos.org/) dot-files configuration for running NixOS on [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install). This configuration provides a development environment in a declarative manner.

## Overview

This configuration includes:

- **NixOS System Configuration**: Core system settings for WSL2.
- **Home Manager Integration**: User-specific package and dotfile management.
- **WSL2 Optimizations**: Proper integration with Windows host system thanks to [NixOS-WSL](https://github.com/nix-community/NixOS-WSL).

## Configuration Structure

```structure
nix-config/
├── flake.nix        # Main flake configuration with inputs and outputs
├── flake.lock       # Lock file for reproducible builds
├── README.md        # This documentation
├── modules/         # System-level configuration modules
│   ├── system.nix   # Core system configuration
│   └── users.nix    # User management configuration
└── home/            # Home Manager configurations
    ├── default.nix  # Main home configuration entry point
    ├── packages.nix # User package definitions
    └── programs/    # Program-specific configurations
        ├── git.nix  # Git configuration
        └── zsh.nix  # Zsh shell configuration
```

### Key Components

- **flake.nix**: Defines the flake inputs (nixpkgs, home-manager, nixos-wsl) and system configuration.
- **modules/system.nix**: Core system settings including experimental features and WSL2 configuration.
- **modules/users.nix**: User management, sudo configuration, and user definitions.
- **home/**: User-specific Home Manager configurations organized by components.

## How to Use This Configuration

### Prerequisites

- Windows 10/11 with WSL2 enabled.
- Basic understanding of Nix/NixOS concepts.

### Step 1: Install NixOS-WSL

1. Download the latest NixOS-WSL tarball from the [releases page](https://github.com/nix-community/NixOS-WSL/releases)

2. Import the tar file into WSL:

   ```powershell
   wsl --import NixOS .\NixOS\ .\nixos-wsl.tar.gz --version 2
   ```

3. Start the NixOS instance:

   ```powershell
   wsl -d NixOS
   ```

### Step 2: Clone This Configuration

1. Once inside the NixOS-WSL instance, clone this repository:

   ```shell
   git clone https://github.com/bryaneduarr/dot-files.nix.git
   cd dot-files.nix
   ```

2. When using with different user settings, update the configuration:
   - In `flake.nix`: Change `wsl.defaultUser` to your desired username.
   - In `modules/users.nix`: Update the user configuration with your details.
   - In `home/programs/git.nix`: Update Git username and email.

### Step 3: Apply the Configuration

1. Build and switch to the new configuration:

   ```shell
   sudo nixos-rebuild switch --flake ~/dot-files.nix#nixos
   ```

2. Exit and restart WSL to ensure all changes take effect:

   ```powershell
   wsl -t NixOS
   wsl -d NixOS
   ```

### Step 4: Set Up the User

1. Set a password for your user:

   ```shell
   sudo passwd bryaneduarr  # Replace with your username.
   ```

2. Switch to your user account:

   ```shell
   su bryaneduarr  # Replace with your username.
   ```

## Alias Commands Usage

### Updating the System

The configuration includes a convenient `update` function. Simply run:

```shell
update
```

This is equivalent to:

```shell
sudo nixos-rebuild switch --flake ~/dot-files.nix#nixos
```

### Adding New Packages

1. **System packages**: Add to the appropriate module in `modules/`.
2. **User packages**: Add to `home/packages.nix`.

Example of adding a new user package to `home/packages.nix`:

```nix
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Existing packages...
    git
    neovim
    # Add new package here
    firefox
  ];
}
```
