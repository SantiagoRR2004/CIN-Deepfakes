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

# Train the model (Quick96) - automatically stops after the timeout
cd DeepFaceLab/scripts && source env.sh && \
printf "face\n" | \
timeout --signal=SIGINT --kill-after=30 180 $DFL_PYTHON "$DFL_SRC/main.py" train \
    --training-data-src-dir "$DFL_WORKSPACE/data_src/aligned" \
    --training-data-dst-dir "$DFL_WORKSPACE/data_dst/aligned" \
    --pretraining-data-dir "$DFL_SRC/pretrain_CelebA" \
    --pretrained-model-dir "$DFL_SRC/pretrain_Quick96" \
    --model-dir "$DFL_WORKSPACE/model" \
    --model Quick96 \
    --no-preview \
    --silent-start && \
cd ../..

# Merge the faces into the destination images (model is "face") (no interactive) (seamless-hist-match)
# (255 Hist match threshold) (learned-prd mask mode) (0 erode mask modifier) (0 blur mask modifier)
# (0 motion blur power) (0 output face scale modifier) (skip Color transfer to predicted face)
# (sharpen mode None) (0 super resolution power) (0 image degrade by denoise power)
# (0 image degrade by bicubic rescale power) (0 Degrade color power of final image) (max num workers)
# printf "face\nn\n4\n255\n2\n0\n0\n0\n0\n\n0\n0\n0\n0\n0\n\n" |
cd DeepFaceLab/scripts && source ./7_merge_Quick96.sh && cd ..

# Convert the merged images back to video (16 bitrate)
cd DeepFaceLab/scripts && echo "16" | source ./8_merged_to_mp4.sh && cd ..
