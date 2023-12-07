#!/bin/bash

##Prerequisites
# 1. Install zsh
# 2. Install aws-vault
# 3. Install programs

# Function to handle errors
handle_error() {
 " echo ""Error: $1"
  exit 1
}

# Update and upgrade
sudo apt-get update -y || handle_error "Failed to update packages."
sudo apt-get upgrade -y || handle_error "Failed to upgrade packages."

# Create alias
ZSHRC_PATH="$HOME/.zshrc"

echo "alias c='clear'" >> "$ZSHRC_PATH"
echo "alias ping='ping -c 5'" >> "$ZSHRC_PATH"
echo "alias k='kubectl'" >> "$ZSHRC_PATH"
echo "alias tf='terraform'" >> "$ZSHRC_PATH"
echo "alias av='aws-vault'" >> "$ZSHRC_PATH"
echo "alias gh='history|grep'" >> "$ZSHRC_PATH"
echo "alias avu='unset AWS_VAULT'" >> "$ZSHRC_PATH"
echo "alias avp='printenv | grep AWS'" >> "$ZSHRC_PATH"
echo "alias avls='aws-vault list'" >> "$ZSHRC_PATH"
echo "alias avl='aws-vault login --region us-east-1'" >> "$ZSHRC_PATH"
echo "alias cat='bat'" >> "$ZSHRC_PATH"
echo "alias dig='dog'" >> "$ZSHRC_PATH"
echo "alias ports='netstat -tulpn'" >> "$ZSHRC_PATH"
echo "alias lsa='exa --long --all --header --no-icons'" >> "$ZSHRC_PATH"
echo "alias ls='exa --long --header --no-icons'" >> "$ZSHRC_PATH"
echo "alias chat='shell-genie ask'" >> "$ZSHRC_PATH"
echo "alias help='tldr'" >> "$ZSHRC_PATH"
echo "alias micro='nano'" >> "$ZSHRC_PATH"
echo "alias find='fdfind'" >> "$ZSHRC_PATH"
echo "ave() {
 local profile='$1'
 aws-vault exec '$profile' --no-session
}" >> "$ZSHRC_PATH"

# End of script"
echo "Alias setup completed. Please restart your terminal."
