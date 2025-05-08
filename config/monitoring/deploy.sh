#!/usr/bin/env bash
set -euo pipefail

# Go to the directory where the script is located
cd "$(dirname "$0")"

# ✅ Check if Helm is installed
if ! command -v helm &> /dev/null; then
    echo "❌ Helm not found. Installing it now..."
    brew install helm
    export PATH=$PATH:/opt/homebrew/bin
fi

# ✅ Add Helm repo if it does not exist
if ! helm repo list | grep -q 'https://prometheus-community.github.io/helm-charts'; then
    echo "📦 Adding Prometheus Helm repo..."
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
fi

# ✅ Update Helm Repos
echo "🔄 Updating Helm repos..."
helm repo update

# ✅ Install/Upgrade Prometheus Stack
echo "🚀 Deploying Prometheus Stack to the 'monitoring' namespace..."
helm upgrade --install kind-prometheus prometheus-community/kube-prometheus-stack \
      --namespace monitoring --create-namespace \
      -f config.yaml

echo "✅ Prometheus Stack successfully deployed!"
