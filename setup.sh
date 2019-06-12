#! /usr/bin/env bash


# Get current dir path for this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo $DIR

ln -sf $DIR $HOME/.dotfiles
echo dotfiles setup: 'dotfiles' is softlinked to  $HOME/.dotfiles 

ln -sf $DIR/.emacs.d $HOME
mv $HOME/.emacs $HOME/.emacs_bak
echo dotfiles setup: 'dotfiles/emacs.d/' is softlinked to  $HOME/.emacs.d/

ln -sf $DIR/.inputrc $HOME
echo dotfiles setup: 'dotfiles/.inputrc' is softlinked to  $HOME/.inputrc

ln -sf $DIR/.zshrc $HOME
echo dotfiles setup: 'dotfiles/.zshrc' is softlinked to  $HOME/.zshrc

ln -sf $DIR/.tmux.conf $HOME
echo dotfiles setup: 'dotfiles/.tmux.conf' is softlinked to  $HOME/.tmux.conf

ln -sf $DIR/.gitconfig $HOME
echo dotfiles setup: 'dotfiles/.gitconfig' is softlinked to  $HOME/.gitconfig

ln -sf $DIR/.Renviron $HOME
echo dotfiles setup: 'dotfiles/.Renviron' is softlinked to  $HOME/.Renviron

ln -sf $DIR/.Rprofile $HOME
echo dotfiles setup: 'dotfiles/.Rprofile' is softlinked to  $HOME/.Rprofile


exit 0;

