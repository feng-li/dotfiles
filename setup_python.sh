#! /usr/bin/env bash

set -e

python3_ver=$1

if [ -z ${python3_ver} ];then
    echo "Python version not given!"
    exit 1;
fi


python_dist_path=$HOME/.local/python${python3_ver}
python_virtualenv_name=python${python3_ver}
python_virtualenv_path=${HOME}/.virtualenvs

# Install a base Python if not available
if [[ ! -f $python_dist_path/bin/python3 ]]; then

    if [[ ! -d $python_dist_path ]]; then
       mkdir -p $python_dist_path
    fi

    # Download Python Standalone Builds from
    # https://github.com/indygreg/python-build-standalone

    cd $python_dist_path

    curl -L https://api.github.com/repos/indygreg/python-build-standalone/releases/latest -o latest.json

    browser_download_url=$(grep -oP '"browser_download_url": "\K[^"]+x86_64-unknown-linux-gnu[^"]+pgo[^"]+lto[^"]+zst' latest.json | grep -m 1 -e "${python3_ver}")
    python_pkg=$(basename ${browser_download_url})

    curl -L ${browser_download_url} -o ${python_pkg}

    # Only unzip the python directory and extract to current dist path
    tar -I zstd -axvf $python_pkg python/install --strip-components=2
    cd -
fi

# Install and upgrade pip and virtualenv to base environment
export PATH=${python_dist_path}/bin:$PATH
pip install pip virtualenv --upgrade --break-system-packages

# Setup virtual environment for current project
virtualenv ${python_virtualenv_path}/${python_virtualenv_name} --python ${python_dist_path}/bin/python3
echo ${python_virtualenv_name} > .venv
chmod 600 .venv

# Message
echo -e "
Python environment setup completely. Use the following command to activate
       source ${python_virtualenv_path}/${python_virtualenv_name}/bin/activate
"

# Install other dependences
# source $conda_path/activate dismod_mr
# pip install --upgrade pip
# pip install dismod_mr

# Jupyter notebook
# pip install ipykernel
# python -m ipykernel install --name=Python3.6-PyMC2.3.8 --user
