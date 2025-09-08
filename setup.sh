#!/bin/bash

# This script provides an interactive setup for WSL2 using NixOS or Ubuntu.

set -e

# Define color codes for terminal output.
RED="\033[0;31m" # Red color for errors.
GREEN="\033[0;32m" # Green color for success messages.
YELLOW="\033[1;33m" # Yellow color for warnings and prompts.
BLUE="\033[0;34m" # Blue color for informational messages.
NC="\033[0m" # No color (reset).

# Declare global variables to store user selections and installation command.
SELECTED_ARCH="" # Stores the selected architecture (x64 or arm64).
SELECTED_CONFIG="" # Stores the selected configuration (ubuntu-x64, ubuntu-arm64, nixos-x64).
INSTALL_COMMAND="" # Stores the function name to execute for installation.

# Prints an informational message in blue.
print_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

# Prints a success message in green.
print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Prints a warning message in yellow.
print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Prints an error message in red.
print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Displays the script header and title in blue.
show_header() {
  clear
  echo -e "${BLUE}=================================================${NC}"
  echo -e "${BLUE}            Nix Configuration Setup              ${NC}"
  echo -e "${BLUE}=================================================${NC}"
  echo ""
}

# Detects the system architecture and prints the result.
detect_architecture() {
  local arch=$(uname -m) # Save the architecture.

  case $arch in
    x86_64)
      print_info "Detected architecture: x86_64 (X64)."
      ;;
    aarch64|arm64)
      print_info "Detected architecture: aarch64/arm64 (ARM64)."
      ;;
    *)
      print_warning "Not tested architecture detected: $arch."
      ;;
  esac
  echo ""
}

# Prompts the user to select the architecture (x64 or arm64).
select_architecture() {
  echo -e "${YELLOW}Select your architecture:${NC}"
  echo ""
  echo "1) X64 (x86_64) Architecture."
  echo "2) ARM64 (aarch64) Architecture."
  echo ""

  # Iterate until a valid answer is given.
  while true; do
    read -p "Enter your choice (1-2): " arch_choice
    case $arch_choice in
      1)
        SELECTED_ARCH="x64"
        print_success "Selected: X64 Architecture." # Success custom function as green.
        break
        ;;
      2)
        SELECTED_ARCH="arm64"
        print_success "Selected: ARM64 Architecture." # Success custom function as green.
        break
        ;;
      *)
        print_error "Invalid choice." # Incorrect custom function as red.
        ;;
    esac
  done
  echo ""
}

# Prompts the user to select the configuration based on the chosen architecture.
select_configuration() {
  echo -e "${YELLOW}Select your configuration:${NC}"
  echo ""

  # Based on the selected architecture we decide in this statement.
  if [[ "$SELECTED_ARCH" == "x64" ]]; then
    echo "1) WSL2 Ubuntu 24.04 with home-manager."
    echo "2) WSL2 NixOS with the current repository configuration."
    echo ""

    # Iterate until we get a correct choice from the user.
    while true; do
      read -p "Enter your choice (1-2): " config_choice
      case $config_choice in
        1)
          SELECTED_CONFIG="ubuntu-x64"
          print_success "Selected: WSL2 Ubuntu 24.04 (X64)." # Correct custom function, returns as green.
          break
          ;;
        2)
          SELECTED_CONFIG="nixos-x64"
          print_success "Selected: WSL2 NixOS (X64)." # Correct custom function, returns as green.
          break
          ;;
        *)
          print_error "Invalid choice." # Incorrect custom function, returns as red.
          ;;
      esac
    done
  # Check the statement if the architecture is ARM64.
  elif [[ "$SELECTED_ARCH" == "arm64" ]]; then
    echo "1) WSL2 Ubuntu 24.04 with home-manager and packages."
    echo ""

    # Iterate until we get a valid choice from the user.
    while true; do
      read -p "Enter your choice (1): " config_choice
      case $config_choice in
        1)
          SELECTED_CONFIG="ubuntu-arm64"
          print_success "Selected: WSL2 Ubuntu 24.04 (ARM64)." # Correct custom function, returns as green.
          break
          ;;
        *)
          print_error "Invalid choice."
          ;;
      esac
    done
  fi
  echo ""
}

# Sets the installation command variable based on the selected configuration.
generate_install_commands() {
  case $SELECTED_CONFIG in
    "ubuntu-x64")
      INSTALL_COMMAND="install_ubuntu_x64"
      ;;
    "ubuntu-arm64")
      INSTALL_COMMAND="install_ubuntu_arm64"
      ;;
    "nixos-x64")
      INSTALL_COMMAND="install_nixos_x64"
      ;;
  esac
}

# Installs Ubuntu 24.04 (X64) and configures home-manager and user environment.
install_ubuntu_x64() {
  print_info "Installing Ubuntu 24.04 (X64) with home-manager."

  # Update system packages to the latest versions.
  sudo apt update && sudo apt upgrade -y

  # Install essential packages required for Nix and development tools.
  sudo apt install -y build-essential

  # Install the Nix package manager in daemon mode.
  curl -L https://nixos.org/nix/install | sh -s -- --daemon

  # Source the Nix profile to enable Nix commands.
  . /etc/profile.d/nix.sh

  # Add and update the home-manager channel, then install home-manager.
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install

  # Ensure Neovim configuration is present in the user's config directory.
  mkdir -p ~/.config
  cp -r ./nvim ~/.config/

  # Copy Ubuntu X64 specific configuration files to home-manager config directory.
  cp -r ./system-configs/x64/* ~/.config/home-manager/
  cp ./home/.p10k.zsh ~/.config/home-manager/

  # Apply the home-manager configuration for the user.
  home-manager switch

  # Set ZSH as the default shell for the user.
  ZSH_PATH=$(which zsh)
  echo "$ZSH_PATH" | sudo tee -a /etc/shells
  chsh -s "$ZSH_PATH"

  print_success "Ubuntu 24.04 (X64) installation completed."
}

# Installs Ubuntu 24.04 (ARM64) and configures home-manager and user environment.
install_ubuntu_arm64() {
  print_info "Installing Ubuntu 24.04 (ARM64) with home-manager."

  # Update system packages to the latest versions.
  sudo apt update && sudo apt upgrade -y

  # Install essential packages required for Nix and development tools.
  sudo apt install -y build-essential

  # Install the Nix package manager in daemon mode.
  curl -L https://nixos.org/nix/install | sh -s -- --daemon

  # Source the Nix profile to enable Nix commands.
  . /etc/profile.d/nix.sh

  # Add and update the home-manager channel, then install home-manager.
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install

  # Ensure Neovim configuration is present in the user's config directory.
  mkdir -p ~/.config
  cp -r ./nvim ~/.config/

  # Apply the home-manager configuration for the user.
  home-manager switch

  # Copy Ubuntu ARM64 specific configuration files to home-manager config directory.
  mkdir -p ~/.config/home-manager
  cp -r ./system-configs/arm64/* ~/.config/home-manager/
  cp ./home/.p10k.zsh ~/.config/home-manager/

  # Apply the home-manager configuration for the user again to ensure all files are loaded.
  home-manager switch

  # Set ZSH as the default shell for the user.
  ZSH_PATH=$(which zsh)
  echo "$ZSH_PATH" | sudo tee -a /etc/shells
  chsh -s "$ZSH_PATH"

  print_success "Ubuntu 24.04 (ARM64) installation completed."
}

# Installs NixOS (X64) using the current repository configuration and switches to it.
install_nixos_x64() {
  print_info "Installing NixOS (X64) with current repository configuration."

  # Build and switch to the NixOS configuration using the flake in the current directory.
  sudo nixos-rebuild switch --flake .#nixos

  print_success "NixOS (X64) installation completed."
}

# Displays a summary of the selected architecture, configuration, and installation steps.
show_summary() {
  echo -e "${GREEN}=================================================${NC}"
  echo -e "${GREEN}           INSTALLATION SUMMARY                  ${NC}"
  echo -e "${GREEN}=================================================${NC}"
  echo ""
  echo -e "${YELLOW}Selected Architecture:${NC} $SELECTED_ARCH"
  echo -e "${YELLOW}Selected Configuration:${NC} $SELECTED_CONFIG"
  echo ""
  echo -e "${YELLOW}Installation Command:${NC}"

  case $SELECTED_CONFIG in
    "ubuntu-x64")
      echo "  - Updated system packages."
      echo "  - Installed Nix package manager."
      echo "  - Configured home-manager."
      ;;
    "ubuntu-arm64")
      echo "  - Updated system packages."
      echo "  - Installed Nix package manager."
      echo "  - Configured home-manager."
      ;;
    "nixos-x64")
      echo "  - Built NixOS configuration from flake."
      echo "  - Switched to new system configuration."
      echo "  - Applied configurations via home-manager."
      ;;
  esac
  echo ""
}

# Asks the user to confirm installation and executes the selected installation command.
confirm_installation() {
  echo -e "${YELLOW}Proceed with the installation? (y/n):${NC}"
  read -p "" confirm

  if [[ $confirm =~ ^[Yy]$ ]]; then
    echo ""
    print_info "Starting installation."
    $INSTALL_COMMAND
    echo ""
    print_info "--Restart your terminal to apply all changes--"
  else
    print_info "Installation cancelled."
    exit 0
  fi
}

# Main function.
main() {
  show_header
  detect_architecture
  select_architecture
  select_configuration
  generate_install_commands
  show_summary
  confirm_installation
}

# Executes main only if the script is run directly, not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
