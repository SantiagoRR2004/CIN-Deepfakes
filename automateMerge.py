#!/usr/bin/env python3
"""
Automated merger script that provides answers to interactive prompts.
This bypasses stdin pipe issues by using pexpect.
"""
import pexpect
import sys
import os

# Change to scripts directory
os.chdir("DeepFaceLab/scripts")

# Source env.sh and get environment variables
env_vars = {}
with pexpect.spawn("bash", ["-c", "source env.sh && env"], encoding="utf-8") as proc:
    proc.expect(pexpect.EOF)
    for line in proc.before.split("\n"):
        if "=" in line:
            key, value = line.split("=", 1)
            # Strip carriage returns and whitespace
            env_vars[key.strip()] = value.strip().replace("\r", "")

mainDirectory = os.path.dirname(os.getcwd())
DFL_SRC = os.path.join(mainDirectory, env_vars["DFL_SRC"])
DFL_WORKSPACE = os.path.join(mainDirectory, env_vars["DFL_WORKSPACE"])

# Build the command
cmd = (
    f"{env_vars['DFL_PYTHON']} {DFL_SRC}/main.py merge "
    f"--input-dir {DFL_WORKSPACE}/data_dst "
    f"--output-dir {DFL_WORKSPACE}/data_dst/merged "
    f"--output-mask-dir {DFL_WORKSPACE}/data_dst/merged_mask "
    f"--aligned-dir {DFL_WORKSPACE}/data_dst/aligned "
    f"--model-dir {DFL_WORKSPACE}/model "
    f"--model Quick96"
)

# Spawn the process
print(f"Running: {cmd}")
child = pexpect.spawn("bash", ["-c", cmd], encoding="utf-8", timeout=None)
child.logfile = sys.stdout

# Answer the prompts
answers = [
    "face",  # Model name
    "n",  # Use interactive merger?
    "4",  # Sharpen mode
    "255",  # Hist match threshold
    "2",  # Mask mode
    "0",  # Erode mask modifier
    "0",  # Blur mask modifier
    "0",  # Motion blur power
    "0",  # Output face scale modifier
    "",  # Color transfer (empty for default/skip)
    "0",  # Sharpen mode (None)
    "0",  # Super resolution power
    "0",  # Image degrade by denoise power
    "0",  # Image degrade by bicubic rescale power
    "0",  # Degrade color power
    "",  # Max num workers (empty for default)
]

import time

for i, answer in enumerate(answers):
    child.expect(":")
    child.sendline(answer)
    print(f" -> Sent: {answer if answer else '(empty)'}")

    # Add a small delay after the first answer (face)
    if i == 0:
        time.sleep(10)

# Wait for completion
child.expect(pexpect.EOF)
