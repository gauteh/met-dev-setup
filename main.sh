#!/usr/bin/env bash

sudo apt-get update

sudo apt-get install git build-essential curl zsh wget tmux git ripgrep

# rust
echo "rust."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# some rust pcks
cargo install --force yazi-build
cargo install exa
cargo install zoxide

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

# latex
sudo apt-get install texlive-latex-extra texlive-latex-recommended
