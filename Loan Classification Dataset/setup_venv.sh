#!/bin/bash
echo "Setting up Python virtual environment..."

# Check if python3-venv is installed on Debian-based systems
if ! dpkg -l | grep -q python3-venv; then
    echo "Warning: python3-venv is not installed."
    echo "Please install it using: sudo apt install python3-venv"
    echo "Or run 'sudo apt install python3.14-venv' (adjust version as needed)."
fi

python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
echo "Setup complete. Activate with 'source .venv/bin/activate'"
