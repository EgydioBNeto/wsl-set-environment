#!/bin/bash

# Function to handle errors
handle_error() {
  echo "Error: $1"
  exit 1
}

##Constants
ZSHRC_PATH="~/.zshrc"

# Install Programs apt-get
prerequisites=("git" "gcc-11" "code" "wget" "ca-certificates" "gpg" "apt-transport-https", "fd-find", "python3-pip")
for package in "${prerequisites[@]}"; do
    sudo apt-get install "$package" -y
done

#Install Programs brew
prerequisitesBrew=("docker", "docker-compose", "kubernetes-cli", "kubectx", "terraform", "asdf", "tldr", "micro", "pre-commit", "terraform-docs", "k9s", "bat", "dog", "openvpn", "exa", "pipx")
for package in "${prerequisitesBrew[@]}"; do
    sudo brew install "$package"
done

# Install shell-genie
pipx install shell-genie
echo "export PATH=\$PATH:~/.local/bin" >> "$ZSHRC_PATH"
brew update --auto-update
shell-genie init

# End of script
echo "Programs setup completed."
