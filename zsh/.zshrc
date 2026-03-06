# zmodload zsh/zprof

source ~/.profile

stty -ixoff

if [[ ! -e ~/.slimzsh/slim.zsh ]]; then
  echo -n "setup zsh? [y/N] "
  if read -q; then
    echo "installing slimzsh + plugins.."
    mkdir -p ~/.zsh
    mkdir -p ~/.zsh/cache

    git clone --recursive https://github.com/changs/slimzsh.git ~/.slimzsh
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh ~/.zsh/oh-my-zsh
    git clone https://github.com/lukechilds/zsh-nvm ~/.zsh/zsh-nvm
    # git clone https://github.com/davidparsson/zsh-pyenv-lazy ~/.zsh/zsh-pyenv-lazy
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
  fi
fi

fpath+=~/.zsh/zfunc

export CASE_SENSITIVE="true" # completion
source ~/.zsh/my-slim.zsh

# used by oh-my-zsh plugins (e.g. fasd)
export ZSH_CACHE_DIR="${HOME}/.zsh/cache"

zstyle ':completion:*' special-dirs true # complete to ../
# setopt menu_complete # select first item (cancel with <C-c>)
unsetopt correct_all

# line-editor in editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# auto-suggestions (SLOW)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# NVM
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
source ~/.zsh/zsh-nvm/zsh-nvm.plugin.zsh

# Tmux
export ZSH_TMUX_AUTOSTART=true
export ZSH_TMUX_AUTOCONNECT=false
source ~/.zsh/oh-my-zsh/plugins/tmux/tmux.plugin.zsh

# FZF / rg
if which rg > /dev/null ; then
  export FZF_DEFAULT_COMMAND="rg --files"
fi
export FZF_DEFAULT_OPTS="--height=10% --color fg:252,bg:233,hl:67,fg+:252,bg+:235,hl+:81 --color info:144,prompt:161,spinner:135,pointer:135,marker:118"
source ~/.vim/plugged/fzf/shell/completion.zsh
source ~/.vim/plugged/fzf/shell/key-bindings.zsh

# ranger
source ~/.zsh/ranger.zsh

if which direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi

stty -ixon

if which starship 2>&1 > /dev/null; then
  eval "$(starship init zsh)"
fi

# conda
export MAMBA_ROOT_PREFIX="$HOME/.mconda3"
# if [[ -e "$HOME/.mconda3" ]]; then
#   # >>> conda initialize >>>
#   # !! Contents within this block are managed by 'conda init' !!
#   __conda_setup="$('$HOME/.mconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#   if [ $? -eq 0 ]; then
#       eval "$__conda_setup"
#   else
#       if [ -f "$HOME/.mconda3/etc/profile.d/conda.sh" ]; then
#           . "$HOME/.mconda3/etc/profile.d/conda.sh"
#       else
#           export PATH="$HOME/.mconda3/bin:$PATH"
#       fi
#   fi
#   unset __conda_setup
#   # <<< conda initialize <<<
# fi

if [ -f "$HOME/.mconda3/etc/profile.d/mamba.sh" ]; then
    . "$HOME/.mconda3/etc/profile.d/mamba.sh"
fi

# PYENV
# export ZSH_PYENV_LAZY_VIRTUALENV
# source ~/.zsh/zsh-pyenv-lazy/pyenv-lazy.plugin.zsh

# zprof

if which jj 2>&1 > /dev/null; then
  source <(COMPLETE=zsh jj)
fi


if which zoxide 2>&1 > /dev/null; then
  eval "$(zoxide init zsh)"
else
  if [ -f "${HOME}/.local/share/zrs/z.sh" ]; then
    . "${HOME}/.local/share/zrs/z.sh"
  fi
fi
