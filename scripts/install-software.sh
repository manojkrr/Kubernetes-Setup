#!/usr/bin/env bash
set -euo pipefail

# Go to the directory where the script is located
cd "$(dirname "$0")"

# ✅ Check if all dependencies are installed
echo "🔍 Checking dependencies..."

# List of required tools
tools=("kind" "kubectl" "helm")

# Install missing tools
for tool in "${tools[@]}"; do
    if ! command -v $tool &> /dev/null; then
        echo "❌ $tool not found. Installing it now..."
        brew install $tool
        export PATH=$PATH:/opt/homebrew/bin
    else
        echo "✅ $tool is already installed."
    fi
done

echo "✅ All necessary software installed!"
