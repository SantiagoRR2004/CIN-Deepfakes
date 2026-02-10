# Deepfakes

## Overview

This is the code to make a demo for a subject called "Ciberseguridad Inteligente" (Intelligent Cybersecurity). The presentation that used this demo accounted for 20% of the final grade. It was made by a team of 2 people. The submission took place on Friday, the 12th of December of 2025, and earned a grade of 10 out of 10 points.

## Project Summary

The presentation focused on the topic of deepfakes, so we decided to create a deepfake video as part of our demo. The deepfake audio and video were generated separately with [`beingmechon/audio_cloning`](https://github.com/beingmechon/audio_cloning) and [`nagadit/DeepFaceLab_Linux`](https://github.com/nagadit/DeepFaceLab_Linux) repositories, respectively. We wanted to use local and open-source tools to ensure privacy and control over the data.

## Creating your own Deepfake

You can create a deepfake separately for video and audio or together using different scripts.

### Separate

#### Video

The video requires a [`sample.mp4`](../sample.mp4) and [`video.mp4`](../video.mp4) files to work. Then the script [`mainVideo.sh`](../mainVideo.sh) will generate [`output.mp4`](../output.mp4) when executed.

#### Audio

The audio requires a [`sample.wav`](../sample.wav) and [`source.wav`](../source.wav) files to work. Then the script [`mainAudio.sh`](../mainAudio.sh) will generate [`output.wav`](../output.wav) when executed.

#### Putting it all together

To combine both audio and video into a single file, you can use the following `ffmpeg` command:

```bash
ffmpeg -i output.mp4 -i output.wav -c:v copy -c:a aac outputF.mp4
```

### Together

The script [`main.sh`](../main.sh) will generate [`outputF.mp4`](../outputF.mp4) when executed. It requires the same files as the video script because it extracts audio from the video files.
