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
sed -i 's/ZSH_THEME=.*/ZSH_THEME="dstufft"/' "$ZSHRC_PATH"

# Aliases
echo "
# Alias start
alias c='clear'
alias ping='ping -c 5'
alias k='kubectl'
alias tf='terraform'
alias av='aws-vault'
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
alias win='explorer.exe .'
alias dropoff='wsl.exe --shutdown'
alias vagrant='vagrant.exe'
alias vbm='VBoxManage.exe'
alias notepad='notepad.exe'
gitlog = ! git log --oneline --color | emojify | less -r
" >> "$ZSHRC_PATH"
echo '
ave() {
  local profile="$1"
  aws-vault exec "$profile" --no-session
}
# Alias end
' >> "$ZSHRC_PATH"

# Tmux
echo "setw -g mouse on" >> ~/.tmux.conf
echo "set -g status-bg whit" >> ~/.tmux.conf

# SSH config
echo "
TCPKeepAlive=yes
ServerAliveInterval=15
ServerAliveCountMax=6
Compression=yes
ControlMaster auto
ControlPath /tmp/%r@%h:%p
ControlPersist yes
" >> ~/.ssh/config

mkdir ~/ssh-keys

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
prerequisites=("gcc-11" "wget" "ca-certificates" "gpg" "apt-transport-https" "fd-find" "python3-pip" "unzip" "build-essential" "jq")

for package in "${prerequisites[@]}"; do
  if ! command_exists "$package"; then
    sudo apt-get install -y "$package"
  else
    echo "$package is already installed."
  fi
done

# Create symlink for python3
sudo ln -s /home/linuxbrew/.linuxbrew/bin/python3 /usr/local/bin/python

# mfa-cli install
python3 -c "$(curl -fsSL https://raw.githubusercontent.com/EgydioBNeto/mfa-cli/main/install.py)"

# Install aws-cli
if ! command_exists "aws"; then
  echo "AWS CLI is not installed. Installing..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  echo "AWS CLI installed successfully. Version:"
  rm -rf awscliv2.zip
  /usr/local/bin/aws --version
  source "$ZSHRC_PATH"
else
  echo "AWS CLI is already installed. Version:"
  aws --version
fi

# Install Homebrew
if ! command_exists "brew"; then
  echo "Homebrew is not installed. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$ZSHRC_PATH"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  brew install gcc
else
  echo "Homebrew is already installed. Version:"
  brew --version
fi

# Install Programs brew
prerequisitesBrew=("docker" "docker-compose" "kubernetes-cli" "kubectx" "terraform" "ansible" "gh" "pulumi" "curlie" "asdf" "tldr" "micro" "pre-commit" "terraform-docs" "k9s" "bat" "dog" "openvpn" "exa" "pipx" "tmux" "hr" "emojify" "coreutils" "xo/xo/usql" "helm" "vault-cli")

for package in "${prerequisitesBrew[@]}"; do
  if ! command_exists "$package"; then
    brew install "$package"
  else
    echo "$package is already installed."
  fi
done

# Install Programs pip
prerequisitesPip=("when-changed")

for package in "${prerequisitesPip[@]}"; do
  if ! command_exists "$package"; then
    pip install https://github.com/joh/when-changed/archive/master.zip
  else
    echo "$package is already installed."
  fi
done

# Install aws-vault
if ! command_exists "aws-vault"; then
  echo "AWS Vault is not installed. Installing..."
  brew install aws-vault
  echo "export AWS_VAULT_BACKEND=file" >> "$ZSHRC_PATH"
  echo "export AWS_VAULT_PASS_PASSWORD_STORE_DIR=/root/.password-store/aws-vault " >> "$ZSHRC_PATH"
else
  echo "aws-vault is already installed."
fi

# Install shell-genie
if ! command_exists "shell-genie"; then
  pipx install shell-genie
  echo "export PATH=\$PATH:~/.local/bin" >> "$ZSHRC_PATH"
  brew update --auto-update
  shell-genie init
else 
  echo "shell-genie is already installed."
fi

echo "Programs setup completed."
