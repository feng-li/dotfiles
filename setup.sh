#! /usr/bin/env bash

# Get current dir path for this script
dotfiles_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo  "['dotfiles' located at $dotfiles_dir]"
echo  "['dotfiles' setup:]"
cd $dotfiles_dir
# git submodule update --recursive
# git submodule foreach git checkout master
# git submodule foreach git pull

# $XDG_CONFIG_HOME files
if [ ! -d $HOME/.config ]; then
    mkdir $HOME/.config
fi
for file in $dotfiles_dir/.config/*
do
    ln -sfv $file $HOME/.config/
done

# if [ "$(realpath "$dotfiles_dir")" = "$(realpath "$HOME/.dotfiles")"  ]; then
#     echo  "Location of 'dotfiles' and $HOME/.dotfiles are the same."
# else
#     rm -rf $HOME/.dotfiles
#     ln -sf $dotfiles_dir    $HOME/.dotfiles
#     echo  "$dotfiles_dir -> $HOME/.dotfiles"
# fi

# Emacs
mv -f $HOME/.emacs.d  $HOME/.emacs.d_bak
rm -rf $HOME/.emacs
ln -sfv $dotfiles_dir/.emacs.d    $HOME/.emacs.d

# echo  Enabling emacs daemon via systemctl
# systemctl enable --user emacs
# echo  Starting emacs daemon via systemctl
# systemctl start --user emacs

ln -sfv $dotfiles_dir/.java    $HOME/.java

if [ ! -d $HOME/.local/bin/ ]; then
    mkdir -p $HOME/.local/bin
fi

# # git-latexdiff
# ln -sfv $dotfiles_dir/git-latexdiff/git-latexdiff    $HOME/.local/bin/
ln -sfv $dotfiles_dir/diff-so-fancy/diff-so-fancy $HOME/.local/bin/

ln -sf $dotfiles_dir/.inputrc    $HOME/.inputrc
ln -sfv $dotfiles_dir/.zshrc    $HOME/.zshrc

ln -sfv $dotfiles_dir/.Renviron    $HOME/.Renviron
ln -sfv $dotfiles_dir/.Rprofile    $HOME/.Rprofile
ln -sfv $dotfiles_dir/.lintr       $HOME/.lintr

if [ ! -d $HOME/.R ]; then
    mkdir $HOME/.R
fi
ln -sf $dotfiles_dir/.R/Makevars    $HOME/.R/Makevars


# Install brew
echo "Please use

/bin/bash -c $dotfiles_dir/homebrew_install/install.sh

to install homebrew.
"

exit 0;
