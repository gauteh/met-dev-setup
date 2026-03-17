#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update

sudo apt-get install -y git build-essential curl zsh wget tmux git ripgrep stow direnv zoxide tig xclip xsel

# rust
echo "rust."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# some rust pcks
cargo install --force yazi-build
cargo install exa
# cargo install zoxide

# starship
mkdir -p ~/.bin/met-dev
curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.bin/met-dev -y

# mamba / python
echo "python."
wget -O Miniforge3.sh "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3.sh -b -p "${HOME}/.mconda3"
source "${HOME}/.mconda3/etc/profile.d/mamba.sh"
# mamba shell init

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
npm install -g @github/copilot
npm install -g @anthropic-ai/claude-code
npm install -g @openai/codex

# history -s "claude --dangerously-skip-permissions"
# history -s "codex --full-auto"

copilot --allow-all-tools --version

# latex
sudo apt-get install -y texlive-latex-extra texlive-latex-recommended

# set up dev env
sudo chsh -s /usr/bin/zsh gauteh

# set up nvim
mamba env create -f met-dev-setup/vim/.vim/environment.yml -y
ln -s ~/.mconda3/envs/neovim/bin/nvim ~/.bin/met-dev/

# cd $HOME
# mkdir dev/
# cd dev/
# git clone https://github.com/gauteh/met-dev-setup.git

# set up gh
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y

if which stow >/dev/null; then
	cd ~
	mkdir -p old
	mv ~/.bashrc old/ # replaced by stow bash below
	mv ~/.profile old/
fi

STOWT='stow -t /home/gauteh'
cd ~/met-dev-setup/

$STOWT conda
$STOWT cargo
$STOWT direnv
$STOWT git
$STOWT starship
$STOWT tmux
$STOWT vim
$STOWT yazi
$STOWT bash
$STOWT zsh

cd ~

# set up vim
~/.mconda3/envs/neovim/bin/nvim -c ':PlugUpdate' -c ':MasonInstall rust-analyzer basedpyright'a -c ':qa'

# current repos
mkdir dev
cd dev

git clone https://github.com/gauteh/max-m10s-rs.git
git clone https://github.com/gauteh/sfy.git
