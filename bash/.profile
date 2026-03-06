# Linked to by Zsh, BASH and Openbox

export LANG=en_US.UTF-8
export LC_ALL=${LANG}
unset LC_COLLATE LC_CTYPE LC_MESSAGES LC_MONETARY LC_NUMERIC LC_TIME

export TERMINAL=alacritty
export USRTERMTYPE=X
export XDG_CURRENT_DESKTOP=XFCE
export DE=xfce
export BROWSER=google-chrome
# export TERM=xterm-256color

# Enable ssh-agent on ubuntu
if pidof gnome-keyring-daemon > /dev/null 2>&1; then
    export $(gnome-keyring-daemon -s)
fi

## Paths
export PATH=$PATH:~/.bin
export PATH=$PATH:~/.vim/plugged/fzf/bin
export FZF_BASE=~/.vim/plugged/fzf

# Add all subdirs and sub-subdirs in ~/.bin to PATH
if [[ $(uname) == "Darwin" ]]; then
  export PATH=/usr/local/{bin,sbin}:$PATH
  export PATH=$PATH$( find $HOME/.bin/ -print0 | xargs -0 stat -f ':%p' )
    # export PATH=$PATH$( find $HOME/.bin/*/* -type d -printf ":%p" )
else
  export PATH=$( find $HOME/.bin/ -printf "%p:" )$PATH
  export PATH=$( find $HOME/.bin/*/* -type d -printf "%p:" )$PATH
fi

# Mac OS path helper
if [ -e /usr/lib/path_helper ]; then
  eval `/usr/libexec/path_helper -s`
fi

# rust cargo
if [[ -e "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# Nix
if [ -e /home/gauteh/.nix-profile/etc/profile.d/nix.sh ]; then . /home/gauteh/.nix-profile/etc/profile.d/nix.sh; fi

export EDITOR=nvim
if which exa > /dev/null ; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  export PAGER=bat
fi

## Aliases
alias g=gvim
alias vi=nvim
alias vim=nvim
alias rr=ranger
alias ll='ls -lh'
alias kill9="killall -9"
alias stow="stow -t ~"
alias xclipp='xargs echo -n | xclip'
alias stripcolor='sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"'
alias yank='yank -- stripclip'
alias rgi='rg -i'
alias bcf="bc -l" # gives me float divsion
alias ssh-no-key='ssh  -o PubkeyAuthentication=no'
alias spm='sudo pacman'
alias npr='npm run'
alias gvm='command g'
alias rperf='perf record --call-graph dwarf'
alias repperf='perf report -F+srcline --source'
alias chrome='google-chrome'
alias gi=gitui

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

## core files
# ulimit -c unlimited

## Environments
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

## PYENV
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# eval "$(pyenv init -)"

## Poetry
export PATH="$HOME/.poetry/bin:$PATH"

if [[ $(uname) == "Darwin" ]]; then
  alias ls="ls -G"
else
  alias ls="ls --color=auto"
fi

if which exa > /dev/null ; then
  alias ls="exa"
  alias ll="exa -lg"
fi

# Local configuration
hostname=$(hostname)
if [[ -e "${HOME}/.profile.${hostname}" ]]; then
  source "${HOME}/.profile.${hostname}"
fi

if [[ -e "${HOME}/.profile.local" ]]; then
  source "${HOME}/.profile.local"
fi

