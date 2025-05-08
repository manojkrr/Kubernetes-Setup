#!/usr/bin/env bash
set -euo pipefail

# Go to the directory where the script is located
cd "$(dirname "$0")"

# ✅ Install necessary software first
echo "🚀 Installing necessary software..."
./install-software.sh

# ✅ Install Kind Cluster
echo "🚀 Installing Kind..."
../config/kind/deploy.sh
echo "⏳ Waiting for Kind to stabilize..."
kubectl wait --for=condition=Ready nodes --all --timeout=60s

# ✅ Install Ingress
echo "🚀 Installing Ingress..."
../config/ingress/deploy.sh
echo "⏳ Waiting for Ingress to stabilize..."
kubectl wait --namespace ingress-nginx \
  --for=condition=Ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# ✅ Install Monitoring
echo "🚀 Installing Monitoring..."
../config/monitoring/deploy.sh
echo "⏳ Waiting for Monitoring to stabilize..."
kubectl wait --namespace monitoring \
  --for=condition=Ready pod \
  --selector=app.kubernetes.io/name=kube-prometheus-stack \
  --timeout=120s

# ✅ Install Postgres
echo "🚀 Installing Postgres..."
../config/postgres/deploy.sh
echo "⏳ Waiting for Postgres to stabilize..."
kubectl wait --namespace database \
  --for=condition=Ready pod \
  --selector=app.kubernetes.io/name=cloudnative-pg \
  --timeout=120s

# ✅ Populate Database
echo "🚀 Populating the database..."
./populate-db.sh

# ✅ Final confirmation
echo "✅ All services are installed and running successfully!"
