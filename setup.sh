#! /usr/bin/env bash

# Get current dir path for this script
dotfiles_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo  "['dotfiles' located at $dotfiles_dir]"
echo  "['dotfiles' setup:]"
cd $dotfiles_dir
# git submodule update --recursive
# git submodule foreach git checkout master
# git submodule foreach git pull

if [ "$(realpath "$dotfiles_dir")" = "$(realpath "$HOME/.dotfiles")"  ]; then
    echo  "Location of 'dotfiles' and $HOME/.dotfiles are the same."
else
    rm -rf $HOME/.dotfiles
    ln -sf $dotfiles_dir    $HOME/.dotfiles
    echo  "$dotfiles_dir -> $HOME/.dotfiles"
fi

# Emacs
mv -f $HOME/.emacs.d  $HOME/.emacs.d_bak
rm -rf $HOME/.emacs

ln -sf $dotfiles_dir/.emacs.d    $HOME/.emacs.d
echo  "$dotfiles_dir/emacs.d/ -> $HOME/.emacs.d/"

# echo  Enabling emacs daemon via systemctl
# systemctl enable --user emacs

# echo  Starting emacs daemon via systemctl
# systemctl start --user emacs

if [ ! -d $HOME/.local/bin/ ]; then
    mkdir -p $HOME/.local/bin
fi

# git-latexdiff
ln -sf $dotfiles_dir/git-latexdiff/git-latexdiff    $HOME/.local/bin/
echo  "$dotfiles_dir/git-latexdiff/git-latexdiff -> $HOME/.local/bin/"

ln -sf $dotfiles_dir/.latexmkrc    $HOME/.latexmkrc
echo  "$dotfiles_dir/.latexmkrc -> $HOME/.latexmkrc"

ln -sf $dotfiles_dir/.inputrc    $HOME/.inputrc
echo  "$dotfiles_dir/.inputrc -> $HOME/.inputrc"

ln -sf $dotfiles_dir/.zshrc    $HOME/.zshrc
echo  "$dotfiles_dir/.zshrc -> $HOME/.zshrc"

ln -sf $dotfiles_dir/.tmux.conf    $HOME/.tmux.conf
echo  "$dotfiles_dir/.tmux.conf -> $HOME/.tmux.conf"

ln -sf $dotfiles_dir/.gitconfig    $HOME/.gitconfig
echo  "$dotfiles_dir/.gitconfig -> $HOME/.gitconfig"

ln -sf $dotfiles_dir/.Renviron    $HOME/.Renviron
echo  "$dotfiles_dir/.Renviron -> $HOME/.Renviron"

ln -sf $dotfiles_dir/.Rprofile    $HOME/.Rprofile
echo  "$dotfiles_dir/.Rprofile -> $HOME/.Rprofile"

if [ ! -d $HOME/.R ]; then
    mkdir $HOME/.R
fi
ln -sf $dotfiles_dir/.R/Makevars    $HOME/.R/Makevars
echo  "$dotfiles_dir/.R/Makevars -> $HOME/.R/Makevars"

ln -sf $dotfiles_dir/.lintr    $HOME/.lintr
echo  "$dotfiles_dir/.lintr -> $HOME/.lintr"

if [ ! -d $HOME/.config ]; then
    mkdir $HOME/.config
fi

ln -sf $dotfiles_dir/.config/flake8     $HOME/.config/flake8
echo  "$dotfiles_dir/.config/flake8 ->  $HOME/.config/flake8"

if [ ! -d $HOME/.config/pip ]; then
    mkdir -p $HOME/.config/pip
fi
ln -sf $dotfiles_dir/.config/pip/pip.conf    $HOME/.config/pip/pip.conf
echo  "$dotfiles_dir/.config/pip/pip.conf -> $HOME/.config/pip/pip.conf"

exit 0;
