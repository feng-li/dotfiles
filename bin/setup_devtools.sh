#! /usr/bin/bash

## Install miniforge
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh -b -u -p "${HOME}/.local/miniforge3"

## Install Rust, cargo ...
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

## direnv
curl -sfL https://direnv.net/install.sh | bash

# Create the path to conda, mamba and activate them
source "${HOME}/.local/miniforge3/etc/profile.d/conda.sh"
source "${HOME}/.local/miniforge3/etc/profile.d/mamba.sh"

# Install necessary software
# mamba install emacs
# mamba install enchant
# mamba install git
# mamba install tmux
# mamba install ncdu
# mamba install htop
# mamba install direnv

# Compilers
# mamba install gcc gfortran clang

# Development environment
mamba install r-base
