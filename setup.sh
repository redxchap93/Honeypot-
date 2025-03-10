#!/bin/bash
# Adaptive Kubernetes AI Honeypot Network Setup Script
# This script builds Docker images, imports them (if needed),
# creates Kubernetes resources, and deploys the adaptive honeypot system.

# Exit immediately if a command exits with a non-zero status
set -e

# --------------------------
# Step 1: Build SSH Honeypot Image
# --------------------------
echo "==> Building SSH Honeypot Docker image..."
cd ~/honeypot-ssh || { echo "Directory ~/honeypot-ssh not found. Please create it and add your Dockerfile."; exit 1; }
docker build -t ssh-honeypot:v1 .

# --------------------------
# Step 2: Import SSH Honeypot Image into containerd (if necessary)
# --------------------------
echo "==> Saving and importing SSH Honeypot image into containerd..."
docker save ssh-honeypot:v1 -o ssh-honeypot.tar
sudo ctr -n k8s.io images import ssh-honeypot.tar
rm ssh-honeypot.tar

# --------------------------
# Step 3: Create Kubernetes Namespace
# --------------------------
echo "==> Creating Kubernetes namespace 'honeypot-ns'..."
kubectl create namespace honeypot-ns || echo "Namespace 'honeypot-ns' already exists."

# --------------------------
# Step 4: Deploy SSH Honeypot Resources
# --------------------------
echo "==> Deploying SSH Honeypot (Deployment & Service)..."
# Adjust the path below to the location of your YAML file
kubectl apply -f /path/to/ssh-honeypot-full.yaml

# --------------------------
# Step 5: Build DeepSeek Analysis Image
# --------------------------
echo "==> Building DeepSeek Analysis Docker image..."
cd ~/ollama-deepseek || { echo "Directory ~/ollama-deepseek not found. Please create it and add your analysis.py and Dockerfile."; exit 1; }
docker build -t deepseek-analysis:v1 .

# --------------------------
# Step 6: Test DeepSeek Analysis Container Locally
# --------------------------
echo "==> Testing DeepSeek Analysis container locally (using host networking)..."
docker run --rm --network=host deepseek-analysis:v1

# --------------------------
# Step 7: Deploy DeepSeek Analysis Container in Kubernetes
# --------------------------
echo "==> Deploying DeepSeek Analysis container into Kubernetes..."
# Adjust the path below to the location of your YAML file
kubectl apply -f /path/to/deepseek-deployment.yaml

# --------------------------
# Step 8: Monitor Deployments and Pods
# --------------------------
echo "==> Listing pods in 'honeypot-ns' namespace..."
kubectl get pods -n honeypot-ns

echo "==> Listing deployments in 'honeypot-ns' namespace..."
kubectl get deployments -n honeypot-ns

# --------------------------
# Step 9: Tail Logs of DeepSeek Analysis Pod (Optional)
# --------------------------
echo "==> Tailing logs for DeepSeek Analysis pod..."
DEEPSEEK_POD=$(kubectl get pods -n honeypot-ns -l app=deepseek-ai -o jsonpath="{.items[0].metadata.name}")
if [ -n "$DEEPSEEK_POD" ]; then
    echo "DeepSeek pod: $DEEPSEEK_POD"
    kubectl logs -n honeypot-ns "$DEEPSEEK_POD" -f
else
    echo "No DeepSeek pod found with label 'app=deepseek-ai'."
fi

echo "==> Setup completed."
