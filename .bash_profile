# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$HOME/.local/bin:$HOME/bin:$PATH
export PATH

# Source local development environment
# if [ -f $HOME/.dotfiles/setvars/compilers*.sh ]; then
#    source $HOME/.dotfiles/setvars/compilers*.sh
# fi

# Setup local zsh and tmux if no root access
if [ -f $HOME/.local/bin/zsh ]; then
    export SHELL=$HOME/.local/bin/zsh

    if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
        $HOME/.local/bin/tmux new -As WORKSPACE
    fi
fi
