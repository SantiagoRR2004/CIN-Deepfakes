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

# Extract images from the video (png format)
cd DeepFaceLab/scripts && echo "png" | source ./3_extract_image_from_data_dst.sh && cd ../..

# Extract faces from the source images (whole face) (1 face per image) (512 image size) (90 jepeg quality) (no debug)
cd DeepFaceLab/scripts && printf "wf\n1\n512\n90\nn\n" | source ./4_data_src_extract_faces_S3FD.sh && cd ../..

# Extract faces from the destination images (whole face) (1 face per image) (512 image size) (90 jepeg quality) (no debug)
cd DeepFaceLab/scripts && printf "wf\n1\n512\n90\nn\n" | source ./5_data_dst_extract_faces_S3FD.sh && cd ../..
