#!/usr/bin/env bash
set -euo pipefail

# Go to the directory where the script is located
cd "$(dirname "$0")"

# ✅ Check if Kind is installed
if ! command -v kind &> /dev/null; then
    echo "❌ Kind not found. Installing it now..."
    brew install kind
    export PATH=$PATH:/opt/homebrew/bin
fi

# ✅ Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Installing it now..."
    brew install kubectl
    export PATH=$PATH:/opt/homebrew/bin
fi

# ✅ Create the Kind cluster if it does not exist
CLUSTER_NAME=$(grep 'name:' config.yaml | awk '{print $2}')
if kind get clusters | grep -q "$CLUSTER_NAME"; then
    echo "🌐 Cluster '$CLUSTER_NAME' already exists."
else
    echo "🚀 Creating Kind cluster '$CLUSTER_NAME'..."
    kind create cluster --config config.yaml
fi

# ✅ Set the kubectl context
kubectl cluster-info --context "kind-$CLUSTER_NAME"

echo "✅ Kind cluster '$CLUSTER_NAME' is up and running!"
