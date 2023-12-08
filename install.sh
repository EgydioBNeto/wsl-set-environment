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

# Constants
ZSHRC_PATH="$HOME/.zshrc"

# Update and upgrade
sudo apt-get update || handle_error "Failed to update packages."
sudo apt-get upgrade || handle_error "Failed to upgrade packages."

# Set zsh theme
sed -i 's/ZSH_THEME=.*/ZSH_THEME="jonathan"/' "$ZSHRC_PATH"

# Aliases
echo "
# Alias start
alias c='clear'
alias ping='ping -c 5'
alias k='kubectl'
alias tf='terraform'
alias av='aws-vault'
alias gh='history|grep'
alias avu='unset AWS_VAULT'
alias avp='printenv | grep AWS'
alias avls='aws-vault list'
alias avl='aws-vault login --region us-east-1'
alias cat='bat'
alias dig='dog'
alias ports='netstat -tulpn'
alias lsa='exa --long --all --header --no-icons'
alias ls='exa --long --header --no-icons'
alias chat='shell-genie ask'
alias help='tldr'
alias nano='micro'
alias find='fdfind'
" >> "$ZSHRC_PATH"
echo '
ave() {
  local profile="$1"
  aws-vault exec "$profile" --no-session
}
# Alias end
' >> "$ZSHRC_PATH"

# Install Zinit
export PATH="/usr/local/bin:$PATH"
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)" || handle_error "Failed to install Zinit."

# Configure zinit
echo "
# Zinit start
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
# Zinit end
" >> "$ZSHRC_PATH"

zinit self-update

echo "Zinit setup completed."

# Install Programs apt-get
prerequisites=("gcc-11" "wget" "ca-certificates" "gpg" "apt-transport-https" "fd-find" "python3-pip" "unzip" "build-essential")

for package in "${prerequisites[@]}"; do
  if ! command_exists "$package"; then
    sudo apt-get install -y "$package"
  else
    echo "$package já está instalado."
  fi
done

# Install aws-cli
if ! command_exists "aws"; then
  echo "AWS CLI não está instalado. Instalando..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  echo "AWS CLI instalado com sucesso. Versão:"
  rm -rf awscliv2.zip
  /usr/local/bin/aws --version
  source "$ZSHRC_PATH"
else
  echo "AWS CLI já está instalado. Versão:"
  aws --version
fi

# Install Homebrew
if ! command_exists "brew"; then
  echo "Homebrew não está instalado. Instalando..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$ZSHRC_PATH"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  brew install gcc
else
  echo "Homebrew já está instalado. Versão:"
  brew --version
fi

# Install Programs brew
prerequisitesBrew=("docker" "docker-compose" "kubernetes-cli" "kubectx" "terraform" "asdf" "tldr" "micro" "pre-commit" "terraform-docs" "k9s" "bat" "dog" "openvpn" "exa" "pipx")

for package in "${prerequisitesBrew[@]}"; do
  if ! command_exists "$package"; then
    brew install "$package"
  else
    echo "$package já está instalado."
  fi
done
# Install aws-vault
if ! command_exists "aws-vault"; then
  echo "AWS Vault não está instalado. Instalando..."
  brew install aws-vault
  echo "export AWS_VAULT_BACKEND=file" >> "$ZSHRC_PATH"
  echo "export AWS_VAULT_PASS_PASSWORD_STORE_DIR=/root/.password-store/aws-vault " >> "$ZSHRC_PATH"
else
  echo "aws-vault já está instalado."
fi

# Install VSCode
if ! command_exists "code"; then
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
  sudo apt-get install code
else
  echo "VSCode já está instalado."
fi

# Install shell-genie
if ! command_exists "shell-genie"; then
  pipx install shell-genie
  echo "export PATH=\$PATH:~/.local/bin" >> "$ZSHRC_PATH"
  brew update --auto-update
  shell-genie init
else 
  echo "shell-genie já está instalado."
fi

echo "Programs setup completed."
