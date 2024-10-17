#!/bin/bash

if [ -z "$BASH_VERSION" ]; then
    echo "This script is required to be ran with the bash shell via bash -i SCRIPT"
    exit 1
fi
if [ -z "$PS1" ]; then
    echo "This script is required to be ran interactivly via bash -i SCRIPT"
    exit 1
fi

# If you use micromamba, comment out the mamba lines and uncomment the micromamba lines

#micromamba create -f environment.yaml
#eval "$(micromamba shell hook --shell=bash)"
#micromamba activate openwpmdata

eval "$(conda shell.bash hook)"
mamba env create --yes -q -f environment.yaml
conda activate openwpmdata

pushd node
npm ci
popd