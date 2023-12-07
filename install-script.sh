#!/bin/bash

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


# Install Programs
prerequisites=("git" "gcc-11" "code" "wget" "ca-certificates" "gpg" "apt-transport-https", "fd-find")
for package in "${prerequisites[@]}"; do
    sudo apt install "$package" -y
done


brew install docker
brew install docker-compose
brew install kubernetes-cli
brew install kubectx
brew install terraform
brew install asdf
brew install tldr
brew install micro
brew install pre-commit
brew install terraform-docs
brew install k9s
brew install bat
brew install dog
brew install openvpn
brew install exa
brew install oath-toolkit
brew install oathtool
brew install pipx
brew update --auto-update
pipx install shell-genie
echo "export PATH=\$PATH:~/.local/bin" >> "$ZSHRC_PATH"
brew update --auto-update
shell-genie init

# End of script
echo "Programs setup completed. Please restart your terminal."
