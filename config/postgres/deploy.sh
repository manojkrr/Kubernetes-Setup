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

# ✅ Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl not found. Installing it now..."
    brew install kubectl
    export PATH=$PATH:/opt/homebrew/bin
fi

# ✅ Add Helm repo if it does not exist
if ! helm repo list | grep -q 'https://cloudnative-pg.github.io/charts'; then
    echo "📦 Adding CloudNativePG Helm repo..."
    helm repo add cloudnative-pg https://cloudnative-pg.github.io/charts
fi

# ✅ Update Helm repositories
echo "🔄 Updating Helm repositories..."
helm repo update

# ✅ Install/Upgrade CloudNative Postgres Operator
echo "🚀 Deploying CloudNative Postgres Operator..."
helm upgrade --install cloudnative-pg cloudnative-pg/cloudnative-pg --namespace database --create-namespace

# ✅ Wait for Operator to Stabilize
echo "⏳ Waiting for the Postgres operator to stabilize..."
kubectl rollout status deployment/cloudnative-pg -n database --timeout=60s

# ✅ Apply Custom Configuration
echo "🚀 Applying Postgres configuration from config.yaml..."
kubectl apply -f config.yaml

# ✅ Confirmation
echo "✅ CloudNative Postgres successfully deployed and configured!"
