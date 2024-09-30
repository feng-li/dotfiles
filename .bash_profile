# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$HOME/.local/bin:$HOME/bin:$PATH
export PATH


# Source local development environment
if [ -f $HOME/.dotfiles/setvars/compilers*.sh ]; then
   source $HOME/.dotfiles/setvars/compilers*.sh
fi

# Use local zsh if no root access
if [ -f $HOME/.local/bin/zsh ]; then
    export SHELL=$HOME/.local/bin/zsh

    # Start TMUX and zsh
    if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then
        $HOME/.local/bin/tmux new -As WORKSPACE
    else
        # Just start zsh
        [ -z "$ZSH_VERSION" ] && exec $SHELL -l
    fi
fi
