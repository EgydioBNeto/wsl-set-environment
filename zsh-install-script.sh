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
prerequisites=("curl" "git" "zsh")

for package in "${prerequisites[@]}"; do
    sudo apt-get install "$package" -y
done


# Install Oh My Zsh
OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
if [ ! -d "$OH_MY_ZSH_DIR" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y || handle_error "Failed to install Oh My Zsh."
else
  echo "Oh My Zsh is already installed."
fi


# Install Zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)" || handle_error "Failed to install Zinit."

# Configure ZSH
ZSHRC_PATH=~/.zshrc

echo "zinit light zdharma-continuum/fast-syntax-highlighting" >> "$ZSHRC_PATH"
echo "zinit light zsh-users/zsh-autosuggestions" >> "$ZSHRC_PATH"
echo "zinit light zsh-users/zsh-completions" >> "$ZSHRC_PATH"

# Set theme
sed -i 's/ZSH_THEME=.*/ZSH_THEME="jonathan"/' "$ZSHRC_PATH"

# End of script
echo "ZSH setup completed. Please restart your terminal."
