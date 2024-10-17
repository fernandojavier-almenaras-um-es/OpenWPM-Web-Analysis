#!/bin/bash

cd "$(dirname $0)"

# If you use micromamba, comment out the conda lines and uncomment the micromamba lines

#eval "$(micromamba shell hook --shell=bash)"
#micromamba activate openwpmdata

eval "$(conda shell.bash hook)"
conda activate openwpmdata

$@