#!/bin/bash

# Activate the conda environment
source ./condaEnvironmentAudio.sh

# The variables
SOURCE_FILE="video.wav"
SAMPLE_FILE="sample.wav"
OUTPUT_DIR="outputs"

echo "Running AudioCloning ..."
python AudioCloning/inference.py --source "$SOURCE_FILE" --target "$SAMPLE_FILE" --output "$OUTPUT_DIR" --diffusion-steps 50