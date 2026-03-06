# ~/.bashrc
#
# NOTE: take care, this one is just linked to openbox environment file.

source ~/.bash/.bashrc.common
source ~/.profile

# export PS1='\[\033[1m\][\h \W]$(__git_ps1 "(%s)") \$ \[\033[0m\]'
export PS1='\[\033[1m\][\h \W] \$ \[\033[0m\]'

if which starship 2>&1 > /dev/null; then
  eval "$(starship init bash)"
fi

if which direnv 2>&1 > /dev/null; then
  eval "$(direnv hook bash)"
fi

if [[ -e "$HOME/.mconda3" ]]; then
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$($HOME/.mconda3/bin/conda 'shell.bash' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  fi
  unset __conda_setup
  # <<< conda initialize <<<
fi

if [ -f "$HOME/.mconda3/etc/profile.d/mamba.sh" ]; then
    . "$HOME/.mconda3/etc/profile.d/mamba.sh"
fi

if [[ -e "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi


if [ -f "${HOME}/.local/share/zrs/z.sh" ]; then
  . "${HOME}/.local/share/zrs/z.sh"
fi

