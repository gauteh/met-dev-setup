#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update

sudo apt-get install -y git build-essential curl zsh wget tmux git ripgrep stow direnv

# rust
echo "rust."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# some rust pcks
cargo install --force yazi-build
cargo install exa
cargo install zoxide

# starship
mkdir -p ~/.bin/met-dev
curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.bin/met-dev -y

# mamba / python
echo "python."
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3.sh -b -p "${HOME}/conda"
source "${HOME}/conda/etc/profile.d/mamba.sh"
mamba shell init

# nvm
echo "install nvm, node"
echo "--- nvm"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# sourcing is the usual way to do it, but does not work within the script (probably because of bashrc interactive session check)
# source ~/.bashrc
# load nvm explicitly!
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
echo "--- node"
nvm install node
nvm install -g @github/copilot

copilot --allow-all-tools --version

# latex
sudo apt-get install -y texlive-latex-extra texlive-latex-recommended

# set up dev env
sudo chsh -s /usr/bin/zsh

cd $HOME
# mkdir dev/
# cd dev/
# git clone https://github.com/gauteh/met-dev-setup.git

alias stow='stow -t /home/gauteh'
cd met-dev-setup/

stow cargo
stow direnv
stow git
stow starship
stow tmux
stow vim
stow yazi
stow bash
stow zsh

