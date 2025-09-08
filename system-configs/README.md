# System Configurations

This directory contains architecture-specific configurations for different target systems.

## Available Configurations

### x64/ (X86_64 Architecture)

Configuration for X86_64 systems that are currently tested (Tested in Windows 11):

- WSL2 Ubuntu 24.04 with home-manager
- WSL2 NixOS with flake configuration

### arm64/ (ARM64 Architecture)

Configuration for ARM64 systems running (Tested in Windows 11):

- WSL2 Ubuntu 24.04 with home-manager

## Usage

These configurations are automatically applied by the `setup.sh` script based on the selections.

The script will:

1. Detect the system architecture.
2. Copy the configuration files to your home-manager directory based on the system architecture.
3. Apply the configuration using home-manager or nixos-rebuild.

## Manual Usage

### For Ubuntu with home-manager:

```shell
# Copy configuration files
cp -r ./system-configs/x64/* ~/.config/home-manager/
cp ./home/.p10k.zsh ~/.config/home-manager/

# Apply configuration
home-manager switch
```

### For NixOS:

```shell
# Apply flake configuration
sudo nixos-rebuild switch --flake .#nixos
```

Remove './system-configs' if necessary.

