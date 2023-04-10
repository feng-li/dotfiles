######################################################################
#### System settings
######################################################################
# zmodload zsh/zprof

export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

dotfiles_dir=`dirname $(readlink $HOME/.zshrc)`

if [[ -f $dotfiles_dir/dir_colors/dircolors ]]; then
    eval `dircolors $dotfiles_dir/dir_colors/dircolors`
fi

# Local version zsh
if [[ -f $HOME/.local/bin/zsh ]]; then
    SHELL=$HOME/.local/bin/zsh
fi

if [[ $TERM = dumb ]]; then
    unset zle_bracketed_paste
fi
# export TERM=xterm-256color

# SPECIAL SETTINGS ON REMOTE DEVELOPMENT ENVIRONMENT
if [[ (${SSH_TTY}) ]]; then
    # PATH=/usr/local/bin:/usr/bin:/bin
    # LD_LIBRARY_PATH=
    # if [[ -z (`gcc --version | awk '/gcc/ && ($3+0)<9.1{print "Version is lower than 9.1"}'`) ]]; then
    if [[ -f $HOME/.local/setvars/compilers.sh ]]; then
	source $HOME/.local/setvars/compilers.sh
    fi

    if [[ -d $HOME/.local/texlive/bin/x86_64-linux ]]; then
	# export PATH=$HOME/.local/texlive/bin/x86_64-linux:$PATH
    fi
    # export EMACS_SERVER_FILE=$HOME/.emacs.d/server/${HOST}_${UID}
fi

## Add a user PATH
LOCALBIN=$HOME/.local/bin:$HOME/.local/share/coursier/bin
PATH=$LOCALBIN:$PATH:
export PATH

## Add LD_LIBRARY_PATH (use comma to separate)
LOCAL_LIB=$HOME/.local/lib:$HOME/.local/lib64
LD_LIBRARY_PATH=$LOCAL_LIB:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH

## RUST
if [[ -f $HOME/.cargo/env ]]; then
    . "$HOME/.cargo/env"
fi

## JAVA
# export JAVA_HOME=/usr/lib/jvm/default-java

## Hadoop
# export HADOOP_HOME=$HOME/hadoop/
# export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar
# export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop/

# export MAHOUT_HOME=$HOME/mahout/
# export MAHOUT_CONF_DIR=$MAHOUT_HOME/conf/

## No. of threads
export OMP_NUM_THREADS=1

## Julia
## alias julia="julia -f"

## Use info to replace man if installed
if [[ -f /usr/bin/info ]]; then
    alias man=info
fi


## SET TERM for ssh
alias ssh="TERM=xterm-256color $(which ssh)"

# if [[ -z "${XDG_RUNTIME_DIR}" ]]; then
#     export XDG_RUNTIME_DIR=/run/user/$(id -ru)
# fi
## Emacs client as an editor

## Emacs lsp speed up.
export LSP_USE_PLISTS=true

## Emacs no-window only in no SSH session
alias em='emacsclient --alternate-editor="emacs -Q" -nw'

## Emacsclient no-window
alias ect='emacsclient -nw -e "(ibuffer)"'

## Emacsclient window
alias ecg='emacsclient -c -e "(ibuffer)"'

## The default editor
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t --create-frame" # $EDITOR opens in terminal
export VISUAL='emacsclient --alternate-editor="emacs -Q" -c' # $VISUAL opens in GUI mode

## Dictionary
export DICPATH=$HOME/.emacs.d/hunspell:$DICPATH

## GIT-LATEXDIFF
alias git-latexdiff="git-latexdiff --latexmk --ignore-latex-errors"

## Linux homebrew
# if [[ -f $HOME/.linuxbrew/bin/brew ]]; then

#     export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
#     export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
#     export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

#     eval "$($HOME/.linuxbrew/bin/brew shellenv)"

#     ## Use local git for brew
#     if [[ -f $HOME/.local/bin/curl ]]; then
#         export HOMEBREW_CURL_PATH=$HOME/.local/bin/curl
#     fi
#     if [[ -f $HOME/.local/bin/git ]]; then
#         export HOMEBREW_GIT_PATH=$HOME/.local/bin/git
#     fi

# fi

## Auto-TMUX invocation.  if we're in an interactive session then automatically put us
# into a tmux session.
if [ ! -d $HOME/.cache/tmux ]; then
    mkdir -p $HOME/.cache/tmux
fi
export TMUX_TMPDIR=$HOME/.cache/tmux
export TMUX=$HOME/.cache/tmux/tmux_${HOST}_${UID}

WORKSPACE_ATTACHED=$(echo `tmux ls | grep attached`)
if [[ ("$PS1" != "") && ("$WORKSPACE_ATTACHED" = "")]]; then
  export SCREEN_STARTED=1
  tmux new -A -s WORKSPACE
fi
######################################################################
## ZSH settings
######################################################################

if [ -f $dotfiles_dir/oh-my-zsh/oh-my-zsh.sh ]; then

    export FPATH=$HOME/.local/share/zsh/$ZSH_VERSION/functions:$FPATH

    # Path to your oh-my-zsh installation.
    export ZSH=$dotfiles_dir/oh-my-zsh

    export ZSH_DISABLE_COMPFIX="true"

    # Zsh profile tool
    # zmodload zsh/zprof

    # Set name of the theme to load. Optionally, if you set this to "random"
    # it'll load a random theme each time that oh-my-zsh is loaded.
    # See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
    ZSH_THEME="robbyrussell"
    # ZSH_THEME="dracula"

    # Uncomment the following line to use case-sensitive completion.
    # CASE_SENSITIVE="true"

    # Uncomment the following line to use hyphen-insensitive completion. Case
    # sensitive completion must be off. _ and - will be interchangeable.
    # HYPHEN_INSENSITIVE="true"

    # Uncomment the following line to disable bi-weekly auto-update checks.
    DISABLE_AUTO_UPDATE="true"

    # Uncomment the following line to change how often to auto-update (in days).
    # export UPDATE_ZSH_DAYS=13

    # Uncomment the following line to disable colors in ls.
    # DISABLE_LS_COLORS="true"

    # Uncomment the following line to disable auto-setting terminal title.
    # DISABLE_AUTO_TITLE="true"

    # Uncomment the following line to enable command auto-correction.
    # ENABLE_CORRECTION="true"

    # Uncomment the following line to display red dots whilst waiting for completion.
    # COMPLETION_WAITING_DOTS="true"

    # Uncomment the following line if you want to disable marking untracked files
    # under VCS as dirty. This makes repository status check for large repositories
    # much, much faster.
    # DISABLE_UNTRACKED_FILES_DIRTY="true"

    # Uncomment the following line if you want to change the command execution time
    # stamp shown in the history command output.
    # The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
    # HIST_STAMPS="mm/dd/yyyy"

    # Would you like to use another custom folder than $ZSH/custom?
    ZSH_CUSTOM=$dotfiles_dir/zsh_custom

    # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
    # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
    # Example format: plugins=(rails git textmate ruby lighthouse)
    # Add wisely, as too many plugins slow down shell startup.
    plugins=(autoswitch_virtualenv zsh-autosuggestions git $plugins zsh-syntax-highlighting)


    # Run ssh-agen when in SSH but not in SLURM,
    if [[ (${SSH_TTY})  && (-z ${SLURM_JOB_ID}) ]]; then
	 plugins=(ssh-agent $plugins)
	 # Extra files send to ssh-agent
	 zstyle :omz:plugins:ssh-agent identities fli_rsa
    fi

    # This should be the last line
    source $ZSH/oh-my-zsh.sh

    # Add local catached dir
    ZSH_CACHE_DIR="$HOME/.cache"

    # Fancy color prompt
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔ %{$fg[cyan]%}) "
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}✗ %{$fg[cyan]%}) "
    ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}("
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    AUTOSWITCH_MESSAGE_FORMAT="$(tput setaf 1)Activating (%venv_name) [%py_version]$(tput sgr0)"

    # zprof

    autoload -U colors && colors
    if [[ -z ${SSH_TTY} ]]; then
        local ret_status="%(?:%{$fg[green]%}%n@%m:%{$fg[green]%}%n@%m)"
        PROMPT='${ret_status}:%{$fg[green]%}%p%{$fg[blue]%}%c$ $(git_prompt_info)% %{$reset_color%}'
    else
        local ret_status="%(?:%{$fg[red]%}%n@%m:%{$fg[green]%}%n@%m)"
        PROMPT='${ret_status}:%{$fg[red]%}%p%{$fg[blue]%}%c$ $(git_prompt_info)% %{$reset_color%}'
    fi
else
    # autoload -U colors && colors
    # PS1="%{$fg[magenta]%}%n@%m:%{$reset_color%}%{$fg[yellow]%}%~%{$reset_color%}%{$fg[yellow]%}%B$%b%{$reset_color%} "
    PS1="%{$fg[green]%}%n@%m:%{$reset_color%}%{$fg[blue]%}%~%{$reset_color%}%{$fg[green]%}%B$%b%{$reset_color%} "
fi
