#!/bin/bash

VIDEO_SOURCE="sample.mp4"
VIDEO="video.mp4"

# Extract the audios
ffmpeg -i "$VIDEO_SOURCE" sample.wav
ffmpeg -i "$VIDEO" video.wav

# Run scripts in parallel
set -e

pids=()

./mainVideo.sh & pids+=($!)
./mainAudio.sh & pids+=($!)

for pid in "${pids[@]}"; do
    wait $pid
done

# Merge the final video and audio
ffmpeg -i output.mp4 -i output.wav -c:v copy -c:a aac outputF.mp4
