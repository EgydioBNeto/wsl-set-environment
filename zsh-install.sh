#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to handle errors
handle_error() {
  echo "Error: $1"
  exit 1
}

# Update and upgrade
sudo apt-get update -y || handle_error "Failed to update packages."
sudo apt-get upgrade -y || handle_error "Failed to upgrade packages."

# Install prerequisites
prerequisites=("curl" "git" "zsh")
for package in "${prerequisites[@]}"; do
    if ! command_exists "$package"; then
      sudo apt-get install "$package" -y
    else
      echo "$package ja está instalado."
done


# Install Oh My Zsh
OH_MY_ZSH_DIR="~/.oh-my-zsh"
if [ ! -d "$OH_MY_ZSH_DIR" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y || handle_error "Failed to install Oh My Zsh."
else
  echo "Oh My Zsh is already installed."
fi