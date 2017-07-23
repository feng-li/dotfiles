# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac



################################################################################
## Personal configuration
################################################################################

# Auto-screen invocation. see: http://taint.org/wk/RemoteLoginAutoScreen
# if we're coming from a remote SSH connection, in an interactive session
# then automatically put us into a screen(1) session.   Only try once
# -- if $STARTED_SCREEN is set, don't try it again, to avoid looping
# if screen fails for some reason.
if [ "$PS1" != "" -a "${STARTED_SCREEN:-x}" = x -a "${SSH_TTY:-x}" != x ]
then
  STARTED_SCREEN=1 ; export STARTED_SCREEN
  screen -RR  || echo "Screen failed! continuing with normal bash startup"
fi
# [end of auto-screen snippet]


export TERM=xterm-256color

## Add a user PATH
LOCALBIN=$HOME/.bin
PATH=$LOCALBIN:$PATH:
export PATH

## Add LD_LIBRARY_PATH (use comma to seprate)
LOCAL_LIB=$HOME/.APP/lib/
USR_LOCAL_LIB=/usr/local/lib/
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LOCAL_LIB
export LD_LIBRARY_PATH

## TEXLIVE Enviroment Variables
# if [ -d "$HOME/.texmf" ] ; then
#     export TEXMFHOME=$HOME/.texmf
#     export BIBINPUTS=./:$HOME/.texmf/bibtex/bib//:$BIBINPUTS
#     export BSTINPUTS=./:$HOME/.texmf/bibtex/bst//:$BSTINPUTS
# fi

## Intel MKL
if [ -d "/opt/intel/mkl/lib/" ] ; then

    MKL_LIB_PATH=/opt/intel/mkl/lib/intel64
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MKL_LIB_PATH
    export MKL_INTERFACE_LAYER=ILP64

fi

## Load icc to PATH
if [ -f /opt/intel/bin/compilervars.sh ]; then
    . /opt/intel/bin/compilervars.sh intel64 ilp64
fi

## JAVA
export JAVA_HOME=/usr/lib/jvm/default-java

## Hadoop
export HADOOP_HOME=$HOME/hadoop/
export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop/

export MAHOUT_HOME=$HOME/mahout/
export MAHOUT_CONF_DIR=$MAHOUT_HOME/conf/

## No. of threads
export OMP_NUM_THREADS=1

## Julia
## alias julia="julia -f"

## Emacs client as an editor

## Emacs no-window
alias emacs="emacs -nw"

## Emacsclient no-window
alias ec="emacsclient -nw"

## Emacsclient window
alias ecg="emacsclient -c"

## The default editor
export EDITOR="emacsclient -nw -c"
export ALTERNATE_EDITOR=""

##

export DICPATH=~/.emacs.d/hunspell/:$DICPATH

################################################################################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm*|rxvt*) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
  fi
fi
