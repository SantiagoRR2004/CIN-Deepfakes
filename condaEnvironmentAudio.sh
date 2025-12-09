#!/bin/bash

# Variable to hold the environment name
ENV="audioCloning"

# Check if conda is already installed
if ! command -v conda &>/dev/null; then
    echo "Conda is not installed. Installing Anaconda..."
    wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh -O anaconda.sh
    chmod +x anaconda.sh
    # Run the installer with automated input
    ./anaconda.sh -b <<EOF

q
yes

yes
EOF
    source ~/.bashrc
else
    echo "Conda is already installed."
fi

# Check if the environment already exists
if ! conda info --envs | grep -q "^${ENV}"; then
    echo "Creating conda environment '${ENV}'..."
    conda create --yes --name ${ENV} python=3.9
else
    echo "Conda environment '${ENV}' already exists."
fi

# Initialize conda for shell usage
eval "$(conda shell.bash hook)"

conda activate ${ENV}
conda install --yes pip

# Copy requirementsAudio.txt to AudioCloning directory and install
cp requirementsAudio.txt AudioCloning/requirements.txt

cd AudioCloning
pip install -r requirements.txt
cd ..
