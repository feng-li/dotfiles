#! /usr/bin/env bash


# Get current dir path for this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo $DIR

rm -rf $HOME/.dotfiles
ln -sf $DIR $HOME/.dotfiles
echo dotfiles setup: 'dotfiles' is softlinked to  $HOME/.dotfiles


# Emacs
ln -sf $DIR/.emacs.d $HOME
mv $HOME/.emacs $HOME/.emacs_bak
echo dotfiles setup: 'dotfiles/emacs.d/' is softlinked to  $HOME/.emacs.d/

echo Enabling emacs daemon via systemctl
systemctl enable --user emacs

echo Starting emacs daemon via systemctl
systemctl start --user emacs

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

ln -sf $DIR/.lintr $HOME
echo dotfiles setup: 'dotfiles/.lintr' is softlinked to  $HOME/.lintr


ln -sf $DIR/flake8 $HOME/.config/flake8
echo dotfiles setup: 'dotfiles/flake8' is softlinked to  $HOME/.config/flake8

exit 0;
