## SAVE ORIGINAL ENVIRONMENT VARIABLE
export orig_PATH=$PATH
export orig_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
export orig_INFOPATH=$INFOPATH
export orig_MANPATH=$MANPATH
export orig_PKG_CONFIG_PATH=$PKG_CONFIG_PATH
export orig_C_INCLUDE_PATH=$C_INCLUDE_PATH
export orig_CPLUS_INCLUDE_PAT=$CPLUS_INCLUDE_PATH

## GNU Source Release Collection
## source $HOME/.opt/gsrc/setup.sh
GCC_HOME=$HOME/.local/compilers/gcc-jit-10.2.0
CMAKE_HOME=$HOME/.local/compilers/cmake-3.24.2
MKLROOT=$HOME/.local/intel/oneapi/mkl/latest
LLVM_HOME=$HOME/.local/compilers/llvm-15.0.3

## CentOS DEVTOOLSET
DEVTOOLSET=/opt/rh/devtoolset-11

my_set_dev_env(){

    ## GCC
    # GCC_HOME=$HOME/.local/compilers/gcc-9.5.0
    export PATH=${GCC_HOME}/bin:$PATH
    export LD_LIBRARY_PATH=${GCC_HOME}/lib64:${GCC_HOME}/lib:$LD_LIBRARY_PATH
    export MANPATH=${GCC_HOME}/share/man:$MANPATH
    export INFOPATH=${GCC_HOME}/share/info:$INFOPATH
    export C_INCLUDE_PATH=${GCC_HOME}/include/:$C_INCLUDE_PATH
    export CPLUS_INCLUDE_PATH=${GCC_HOME}/include/:$CPLUS_INCLUDE_PATH

    ## CMAKE
    export PATH=$CMAKE_HOME/bin:$PATH
    export MANPATH=$CMAKE_HOME/man:$MANPATH

    ## LLVM
    export PATH=$LLVM_HOME/bin:$PATH

    ## Intel MKL
    export MKL_LIB_PATH=$MKLROOT/lib/intel64
    export LD_LIBRARY_PATH=$MKL_LIB_PATH:$LD_LIBRARY_PATH
}

my_set_devtoolset_env(){
    if [[ -f ${DEVTOOLSET}/enabl ]]; then
        source ${DEVTOOLSET}/enable
    else
        echo "DEVTOOSET not found. Skipped."
    fi
}

my_unset_dev_env(){

    export PATH=$orig_PATH
    export LD_LIBRARY_PATH=$orig_LD_LIBRARY_PATH
    export INFOPATH=$orig_INFOPATH
    export MANPATH=$orig_MANPATH
    export PKG_CONFIG_PATH=$orig_PKG_CONFIG_PATH
    export C_INCLUDE_PATH=$orig_C_INCLUDE_PATH
    export CPLUS_INCLUDE_PAT=$ORGIG_CPLUS_INCLUDE_PATH

}

# Activate the dev environment
# my_set_dev_env
my_set_devtoolset_env
