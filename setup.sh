#! /usr/bin/env bash

# Get current dir path for this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "dotfiles locate at $DIR"

cd $DIR
git submodule update --init --recursive

if [ "$(realpath "$DIR")" = "$(realpath "$HOME/.dotfiles")"  ]; then
    echo "Location of dotfiles and $HOME/.dotfiles are the same."
else
    rm -rf $HOME/.dotfiles
    ln -sf $DIR $HOME/.dotfiles
    echo "dotfiles setup: $DIR is softlinked to  $HOME/.dotfiles"
fi

# Emacs
mv -f $HOME/.emacs.d  $HOME/.emacs.d_bak
rm -rf $HOME/.emacs

ln -sf $DIR/.emacs.d $HOME
echo "dotfiles setup: $DIR/emacs.d/ is softlinked to  $HOME/.emacs.d/"

# echo Enabling emacs daemon via systemctl
# systemctl enable --user emacs

# echo Starting emacs daemon via systemctl
# systemctl start --user emacs

if [ ! -d $HOME/.bin ]; then
    mkdir $HOME/.bin
fi

# git-latexdiff
ln -sf $DIR/git-latexdiff/git-latexdiff $HOME/.bin/
echo "git-latexdiff is softlinked to $HOME/.bin/"

ln -sf $DIR/.inputrc $HOME
echo "dotfiles setup: $DIR/.inputrc is softlinked to  $HOME/.inputrc"

ln -sf $DIR/.zshrc $HOME
echo "dotfiles setup: $DIR/.zshrc is softlinked to  $HOME/.zshrc"

ln -sf $DIR/.tmux.conf $HOME
echo "dotfiles setup: $DIR/.tmux.conf is softlinked to  $HOME/.tmux.conf"

ln -sf $DIR/.gitconfig $HOME
echo "dotfiles setup: $DIR/.gitconfig is softlinked to  $HOME/.gitconfig"

ln -sf $DIR/.Renviron $HOME
echo "dotfiles setup: $DIR/.Renviron is softlinked to  $HOME/.Renviron"

ln -sf $DIR/.Rprofile $HOME
echo "dotfiles setup: $DIR/.Rprofile is softlinked to  $HOME/.Rprofile"

if [ ! -d $HOME/.R ]; then
    mkdir $HOME/.R
fi
ln -sf $DIR/.R/Makevars $HOME/.R/
echo "dotfiles setup: $DIR/.R/Makevars is softlinked to  $HOME/.R/Makevars"

ln -sf $DIR/.lintr $HOME
echo "dotfiles setup: $DIR/.lintr is softlinked to  $HOME/.lintr"

if [ ! -d $HOME/.config ]; then
    mkdir $HOME/.config
fi

ln -sf $DIR/flake8 $HOME/.config/flake8
echo "dotfiles setup: $DIR/flake8 is softlinked to  $HOME/.config/flake8"


if [ ! -d $HOME/.config/pip ]; then
    mkdir $HOME/.config/pip
fi

ln -sf $DIR/pip.conf $HOME/.config/pip/pip.conf
echo "dotfiles setup: $DIR/pip.conf is softlinked to  $HOME/.config/pip/pip.conf"

exit 0;
