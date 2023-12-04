#!/bin/bash

#Prerequisites
# 1. Install zsh

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

# Constants
ZSHRC_PATH="$HOME/.zshrc"

# Update and upgrade
sudo apt-get update -y || handle_error "Failed to update packages."
sudo apt-get upgrade -y || handle_error "Failed to upgrade packages."

# Install prerequisites
prerequisites=("unzip", "curl", "build-essential", "wget")

for package in "${prerequisites[@]}"; do
  if ! command_exists "$package" && ! package_installed "$package"; then
    sudo apt-get install "$package" -y 
  elif ! command_exists "$package" && package_installed "$package"; then
    echo "$package is already installed."
  fi
done

##Install script

if ! command_exists "aws"; then
  echo "AWS CLI não está instalado. Instalando..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  echo "AWS CLI instalado com sucesso. Versão:"
  /usr/local/bin/aws --version
else
  echo "AWS CLI já está instalado. Versão:"
  aws --version
fi

if ! command_exists "brew"; then
  echo "AWS Brew não está instalado. Instalando..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> "$ZSHRC_PATH"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    brew install gcc
else
  echo "Brew já está instalado. Versão:"
  brew --version
fi

brew install aws-vault

echo "export AWS_VAULT_BACKEND=file" >> "$ZSHRC_PATH"
echo "export AWS_VAULT_PASS_PASSWORD_STORE_DIR=/root/.password-store/aws-vault " >> "$ZSHRC_PATH"


 
# End of script
echo "AWS-VAULT setup completed. Please restart your terminal."
