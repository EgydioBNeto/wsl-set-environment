# wsl-set-environment
scripts for automating the creation of a WSL environment

sudo apt update -y
sudo apt upgrade -y
sudo apt install curl -y

bash -c "$(curl -fsSL https://raw.githubusercontent.com/EgydioBNeto/wsl-set-environment/main/zsh-install-script.sh)"

bash -c "$(curl -fsSL https://raw.githubusercontent.com/EgydioBNeto/wsl-set-environment/main/zsh-install-script.sh)"

reniciar o terminal

bash -c "$(curl -fsSL https://raw.githubusercontent.com/EgydioBNeto/wsl-set-environment/main/aws-vault-install-script.sh)"

reniciar o terminal

bash -c "$(curl -fsSL https://raw.githubusercontent.com/EgydioBNeto/wsl-set-environment/main/install-script.sh)"

reniciar o terminal

bash -c "$(curl -fsSL https://raw.githubusercontent.com/EgydioBNeto/wsl-set-environment/main/alias-config-script.sh)"

reniciar o terminal

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

sudo apt install code -y