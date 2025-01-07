#! /usr/bin/env bash

set -e

python3_ver=$1
update=$2

if [ -z ${python3_ver} ];then
    echo "Python version not given!"
    exit 1;
fi


python_dist_path=$HOME/.local/python${python3_ver}
python_virtualenv_name=python${python3_ver}
python_virtualenv_path=${HOME}/.virtualenvs

miniforge_home=$HOME/.local/miniforge3

# Install minforge if mamba not available
if [[ ! -f ${miniforge_home}/bin/python3 ]]; then

    # Force download the json file
    curl -L -O "https://mirrors.tuna.tsinghua.edu.cn/github-release/conda-forge/miniforge/LatestRelease/Miniforge3-$(uname)-$(uname -m).sh"
    bash "Miniforge3-$(uname)-$(uname -m).sh" -b -u -p "${miniforge_home}"

    ln -sfv ${miniforge_home}/bin/mamba ${HOME}/.local/bin/
fi

# Install a base Python if not available
if [[ ! -f $python_dist_path/bin/python3 ]] || [[ ${update} == "update" ]]; then

    # Remove existing contents
    rm -rf $python_dist_path

    if [[ ! -d $python_dist_path ]]; then
       mkdir -p $python_dist_path
    fi

    # Install Python
    ${miniforge_home}/bin/mamba create --prefix $python_dist_path python=${python3_ver}

fi

# Install and upgrade pip and virtualenv to base environment
export PATH=${python_dist_path}/bin:$PATH
pip install virtualenv --upgrade --break-system-packages --quiet

echo -e "
Python installed to ${python_dist_path}
"
# Add python, pip, virtualenv to current ~/.local/bin
ln -sfv ${python_dist_path}/bin/python${python3_ver} ${HOME}/.local/bin/
ln -sfv ${python_dist_path}/bin/pip${python3_ver} ${HOME}/.local/bin/
ln -sfv ${python_dist_path}/bin/virtualenv ${HOME}/.local/bin/

# Install other dependences
# source $conda_path/activate dismod_mr
# pip install --upgrade pip
# pip install dismod_mr

# Jupyter notebook
pip --quiet install jupyter notebook jupyterlab-rise
echo -e "
JupyterLab, Jupyter notebook 7, RISE are installed at
    $python_dist_path
"

# Setup virtual environment for current project
virtualenv ${python_virtualenv_path}/${python_virtualenv_name} --python ${python_dist_path}/bin/python3

echo -e "
Python virtualenv setup completely. Use the following command to activate
       source ${python_virtualenv_path}/${python_virtualenv_name}/bin/activate
"

# Jupyter ipykernel for current Python
source ${python_virtualenv_path}/${python_virtualenv_name}/bin/activate

# Langueage servers and syntax checker flake8
pip --quiet install flake8

# ipykernel for virtual environment
pip --quiet install ipykernel
python -m ipykernel install --user --name ${python_virtualenv_name} --display-name ${python_virtualenv_path}/${python_virtualenv_name}

echo -e "
ipykernel for this Python virtual environment is installed.
"
