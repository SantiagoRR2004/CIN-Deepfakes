#!/bin/bash

# Variable to hold the environment name
PICTURE="image.jpg"
VIDEO="video.mp4"

# Activate the conda environment (source it so conda activation persists)
source ./condaEnvironment.sh

# Initial setup
cd DeepFaceLab/scripts && source ./1_clear_workspace.sh && cd ..

# Copy the video to data_dst file
cp "$VIDEO" DeepFaceLab/workspace/data_dst.mp4

# Copy the picture to data_src folder
cp "$PICTURE" DeepFaceLab/workspace/data_src/00001.png

# Extract images from the video
cd DeepFaceLab/scripts && source ./3_extract_image_from_data_dst.sh && cd ..

# Extract faces from the source images
cd DeepFaceLab/scripts && source ./4_data_src_extract_faces_S3FD.sh && cd ..