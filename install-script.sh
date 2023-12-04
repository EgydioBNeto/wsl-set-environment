#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check if a package is installed
package_installed() {
  dpkg -s "$1" >/dev/null 2>&1
}

# Function to handle errors
handle_error() {
  echo "Error: $1"
  exit 1
}

##Constants
ZSHRC_PATH="$HOME/.zshrc"

# Update and upgrade
sudo apt-get update -y || handle_error "Failed to update packages."
sudo apt-get upgrade -y || handle_error "Failed to upgrade packages."


# vscode prerequisites
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

# Just Update
sudo apt-get update -y || handle_error "Failed to update packages."

# Install Programs
 prerequisites=("git", "gcc-11", "code", "wget", "ca-certificates", "gpg", "apt-transport-https", "code")
 for package in "${prerequisites[@]}"; do
   if ! command_exists "$package" && ! package_installed "$package"; then
     sudo apt-get install "$package" -y
   elif ! command_exists "$package" && package_installed "$package"; then
     echo "$package is already installed."
   fi
 done


brew install docker
brew install docker-compose
brew install kubernetes-cli
brew install kubectx
brew install terraform
brew install asdf
brew install tldr
brew install pre-commit
brew install terraform-docs
brew install k9s
brew install bat
brew install dog
brew install openvpn
brew install exa
brew install pipx
brew update --auto-update
pipx install shell-genie
echo "export PATH=\$PATH:~/.local/bin" >> "$ZSHRC_PATH"
brew update --auto-update
shell-genie init

# End of script
echo "Programs setup completed. Please restart your terminal."
