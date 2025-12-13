#!/bin/bash

# Variable to hold the environment name
VIDEO_SOURCE="sample.mp4"
VIDEO="video.mp4"

# Activate the conda environment (source it so conda activation persists)
source ./condaEnvironment.sh

# Initial setup
cd DeepFaceLab/scripts && source ./1_clear_workspace.sh && cd ..

# Copy the video to data_dst file
cp "$VIDEO" DeepFaceLab/workspace/data_dst.mp4

# Copy the video source to data_src folder
cp "$VIDEO_SOURCE" DeepFaceLab/workspace/data_src.mp4

# Extract images from the source video (png format)
cd DeepFaceLab/scripts && echo "png" | source ./2_extract_image_from_data_src.sh && cd ../..

# Extract images from the video (png format)
cd DeepFaceLab/scripts && echo "png" | source ./3_extract_image_from_data_dst.sh && cd ../..

# Extract faces from the source images (head) (1 face per image) (512 image size) (90 jepeg quality) (no debug)
cd DeepFaceLab/scripts && printf "head\n1\n512\n90\nn\n" | source ./4_data_src_extract_faces_S3FD.sh && cd ../..

# Extract faces from the destination images (head) (1 face per image) (512 image size) (90 jepeg quality) (no debug)
cd DeepFaceLab/scripts && printf "head\n1\n512\n90\nn\n" | source ./5_data_dst_extract_faces_S3FD.sh && cd ../..

# Download FFHQ pretraining dataset (if not already downloaded)
cd DeepFaceLab/scripts && source ./4.1_download_FFHQ.sh && cd ../..

# Train the model (SAEHD) - automatically stops after the timeout
cd DeepFaceLab/scripts && source env.sh && \
printf "face\n" | \
timeout --signal=SIGINT --kill-after=30 10800 $DFL_PYTHON "$DFL_SRC/main.py" train \
    --training-data-src-dir "$DFL_WORKSPACE/data_src/aligned" \
    --training-data-dst-dir "$DFL_WORKSPACE/data_dst/aligned" \
    --pretraining-data-dir "$DFL_SRC/pretrain_FFHQ" \
    --model-dir "$DFL_WORKSPACE/model" \
    --model SAEHD \
    --no-preview \
    --silent-start
cd ..

# Merge the faces into the destination images
python3 automateMerge.py

# Convert the merged images back to video (16 bitrate)
cd DeepFaceLab/scripts && echo "16" | source ./8_merged_to_mp4.sh && cd ..
