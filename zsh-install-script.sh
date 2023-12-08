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

# Update and upgrade
sudo apt-get update -y || handle_error "Failed to update packages."
sudo apt-get upgrade -y || handle_error "Failed to upgrade packages."

# Install prerequisites
prerequisites=("curl" "git" "zsh", "python3-pip")
for package in "${prerequisites[@]}"; do
    sudo apt-get install "$package" -y
done

# Set zsh theme
sed -i 's/ZSH_THEME=.*/ZSH_THEME="jonathan"/' ~/.zshrc

# Install Zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)" || handle_error "Failed to install Zinit."

# Configure zinit
echo "
# Zinit start
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
# Zinit end
" >> ~/.zshrc

echo "Zinit setup completed."

# Install Oh My Zsh
OH_MY_ZSH_DIR="~/.oh-my-zsh"
if [ ! -d "$OH_MY_ZSH_DIR" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y || handle_error "Failed to install Oh My Zsh."
else
  echo "Oh My Zsh is already installed."
fi

echo "ZSH setup completed."
source ~/.zshrc
