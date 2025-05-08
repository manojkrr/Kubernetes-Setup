#!/usr/bin/env bash
set -euo pipefail

# Go to the directory where the script is located
cd "$(dirname "$0")"

# ✅ Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Installing it now..."
    brew install kubectl
    export PATH=$PATH:/opt/homebrew/bin
fi

# ✅ Ensure the Kubernetes cluster is running
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ Kubernetes cluster not running. Please start your cluster and try again."
    exit 1
fi

# ✅ Apply the Ingress configuration
echo "🚀 Deploying Ingress resources from config.yaml..."
kubectl apply -f config.yaml

echo "✅ Ingress successfully deployed!"
