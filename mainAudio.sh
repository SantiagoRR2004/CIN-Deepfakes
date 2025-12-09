#!/bin/bash

# Activate the conda environment
source ./condaEnvironmentAudio.sh

# The variables
SOURCE_FILE="video.wav"
SAMPLE_FILE="sample.wav"
OUTPUT_DIR="outputs"

# Check if checkpoints exist
if [ ! -d "OpenVoice/checkpoints" ]; then
    echo "Error: OpenVoice checkpoints not found."
    echo "Please download them and extract to OpenVoice/checkpoints"
    echo "See OpenVoice/docs/USAGE.md for instructions."
    exit 1
fi

echo "Running AudioCloning ..."
python AudioCloning/inference.py --source "$SOURCE_FILE" --target "$SAMPLE_FILE" --output "$OUTPUT_DIR" --diffusion-steps 50