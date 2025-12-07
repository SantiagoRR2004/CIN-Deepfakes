#!/bin/bash

# Set the repository URL and directory
REPO_URL="https://github.com/nagadit/DeepFaceLab_Linux"
REPO_URL2="https://github.com/iperov/DeepFaceLab.git"
DIR_NAME="DeepFaceLab"

./downloadRepository.sh "$REPO_URL" "$DIR_NAME"

./downloadRepository.sh "$REPO_URL2" "$DIR_NAME/$DIR_NAME"