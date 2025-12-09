import os
import torch
import argparse
import sys

# Add OpenVoice to path if needed, though pip install -e . should handle it
sys.path.append(os.path.join(os.getcwd(), "OpenVoice"))

from openvoice import se_extractor
from openvoice.api import BaseSpeakerTTS, ToneColorConverter


def main():
    parser = argparse.ArgumentParser(description="OpenVoice Voice Cloning")
    parser.add_argument(
        "--reference_file",
        type=str,
        default="mydataset/video.wav",
        help="Path to the reference wav file",
    )
    parser.add_argument(
        "--text",
        type=str,
        default="This is a generated audio using OpenVoice.",
        help="Text to speak",
    )
    parser.add_argument(
        "--output_dir", type=str, default="outputs", help="Output directory"
    )

    args = parser.parse_args()

    reference_speaker = args.reference_file
    target_text = args.text
    output_dir = args.output_dir

    # Paths to checkpoints
    ckpt_base = "OpenVoice/checkpoints/base_speakers/EN"
    ckpt_converter = "OpenVoice/checkpoints/converter"

    device = "cpu"

    if not os.path.exists(reference_speaker):
        print(f"Error: Reference file '{reference_speaker}' not found.")
        return

    if not os.path.exists(ckpt_base) or not os.path.exists(ckpt_converter):
        print(
            "Error: Checkpoints not found. Please download them and place them in 'OpenVoice/checkpoints'."
        )
        print("See OpenVoice/docs/USAGE.md for details.")
        # Attempt to use V2 if V1 is missing? No, let's stick to V1 structure for now as per demo_part1
        return

    os.makedirs(output_dir, exist_ok=True)

    print("Loading models...")
    try:
        base_speaker_tts = BaseSpeakerTTS(f"{ckpt_base}/config.json", device=device)
        base_speaker_tts.load_ckpt(f"{ckpt_base}/checkpoint.pth")

        tone_color_converter = ToneColorConverter(
            f"{ckpt_converter}/config.json", device=device
        )
        tone_color_converter.load_ckpt(f"{ckpt_converter}/checkpoint.pth")
    except Exception as e:
        print(f"Error loading models: {e}")
        return

    source_se = torch.load(f"{ckpt_base}/en_default_se.pth").to(device)

    print(f"Extracting tone color from {reference_speaker}...")
    try:
        target_se, audio_name = se_extractor.get_se(
            reference_speaker, tone_color_converter, target_dir="processed", vad=True
        )
    except Exception as e:
        print(f"Error extracting tone color: {e}")
        return

    print(f"Generating audio for text: '{target_text}'")
    src_path = f"{output_dir}/tmp.wav"
    base_speaker_tts.tts(
        target_text, src_path, speaker="default", language="English", speed=1.0
    )

    save_path = f"{output_dir}/output_cloned.wav"
    print(f"Converting tone color and saving to {save_path}...")
    tone_color_converter.convert(
        audio_src_path=src_path,
        src_se=source_se,
        tgt_se=target_se,
        output_path=save_path,
        message="@MyShell",
    )
    print("Done.")


if __name__ == "__main__":
    main()
