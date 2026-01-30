#!/bin/bash

# Activate the conda environment
source ./condaEnvironmentAudio.sh

# The variables
SOURCE_FILE="video.wav"
SAMPLE_FILE="sample.wav"
OUTPUT_DIR="outputs"

echo "Running AudioCloning ..."
python AudioCloning/inference.py --source "$SOURCE_FILE" --target "$SAMPLE_FILE" --output "$OUTPUT_DIR" --diffusion-steps 50

# Copy the final output to the main folder
cp "$OUTPUT_DIR"/vc_video_sample_1.0_50_0.7.wav ./output.wav
