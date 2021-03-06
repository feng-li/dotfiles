######################################################################
#### The system settings
######################################################################

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

if [[ -f $HOME/.dotfiles/dir_colors/dircolors ]]; then
    eval `dircolors $HOME/.dotfiles/dir_colors/dircolors`
fi


# Auto-screen invocation.  if we're in an interactive session then automatically put us
# into a screen(1) session.
GNOME_TERM_PID=$(echo `ps -C gnome-terminal-server -o pid=`)
WORKSPACE_ATTACHED=$(echo `tmux ls | grep attached`)
if [[ ("$PS1" != "") && ("$WORKSPACE_ATTACHED" = "")]]; then
  export SCREEN_STARTED=1
  tmux attach -d || tmux new -s WORKSPACE
  # normally, execution of this rc script ends here...
  #echo "Screen failed! continuing with normal bash startup"
fi

export TERM=xterm-256color

## Add a user PATH
LOCALBIN=$HOME/.local/bin
PATH=$LOCALBIN:$PATH:
export PATH

## Add LD_LIBRARY_PATH (use comma to seprate)
LOCAL_LIB=$HOME/.APP/lib/
USR_LOCAL_LIB=/usr/local/lib/
# LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LOCAL_LIB:$USR_LOCAL_LIB
# export LD_LIBRARY_PATH

## TEXLIVE Enviroment Variables
# if [ -d "$HOME/.texmf" ] ; then
#     export TEXMFHOME=$HOME/.texmf
#     export BIBINPUTS=./:$HOME/.texmf/bibtex/bib//:$BIBINPUTS
#     export BSTINPUTS=./:$HOME/.texmf/bibtex/bst//:$BSTINPUTS
# fi

## JAVA
# export JAVA_HOME=/usr/lib/jvm/default-java

## Hadoop
# export HADOOP_HOME=$HOME/hadoop/
# export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar
# export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop/

# export MAHOUT_HOME=$HOME/mahout/
# export MAHOUT_CONF_DIR=$MAHOUT_HOME/conf/

## No. of threads
## export OMP_NUM_THREADS=1

## Julia
## alias julia="julia -f"

## Use info to replace man if installed
if [[ -f /usr/bin/info ]]; then
    alias man=info
fi

## Emacs client as an editor

## Emacs no-window
alias emacs='emacsclient --alternate-editor="command emacs" -nw'

## Emacsclient no-window
alias ec="emacsclient -nw"

## Emacsclient window
alias ecg="emacsclient -c"

## The default editor
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"              # $EDITOR opens in terminal
export VISUAL='emacsclient --alternate-editor="command emacs" -c'         # $VISUAL opens in GUI mode

## Dictionary
export DICPATH=~/.emacs.d/hunspell:$DICPATH


######################################################################
## ZSH settings
######################################################################

# zsh syntax highlighting
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

    # Set background of cursor to avoid invisible move...
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
    ZSH_HIGHLIGHT_STYLES[cursor]='bg=white'
fi


if [ -f $HOME/.dotfiles/oh-my-zsh/oh-my-zsh.sh ]; then

   # Path to your oh-my-zsh installation.
   export ZSH=$HOME/.dotfiles/oh-my-zsh/

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
   # ZSH_CUSTOM=/path/to/new-custom-folder

   # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
   # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
   # Example format: plugins=(rails git textmate ruby lighthouse)
   # Add wisely, as too many plugins slow down shell startup.
   plugins=(git)

   source $ZSH/oh-my-zsh.sh

   # Add local catached dir
   ZSH_CACHE_DIR="$HOME/.cache"

fi

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Color prompt
# autoload -U colors && colors
# PS1="%{$fg[magenta]%}%n@%m:%{$reset_color%}%{$fg[yellow]%}%~%{$reset_color%}%{$fg[yellow]%}%B$%b%{$reset_color%} "
# PS1="%{$fg[green]%}%n@%m:%{$reset_color%}%{$fg[blue]%}%~%{$reset_color%}%{$fg[green]%}%B$%b%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔ %{$fg[cyan]%}) "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}✗ %{$fg[cyan]%}) "
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

local ret_status="%(?:%{$fg[green]%}%n@%m:%{$fg[green]%}%n@%m)"
PROMPT='${ret_status}:%{$fg[green]%}%p%{$fg[blue]%}%c$ $(git_prompt_info)% %{$reset_color%}'
