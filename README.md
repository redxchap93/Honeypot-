# Honeypot-
Adaptive Kubernetes AI Honeypot Network: Leveraging Docker, Grok3, DeepSeek, and OpenAI DeepSearch for Intelligent Cyber Threat Detection and Dynamic Attack Mitigation
This script will:

Build the SSH honeypot image.
Import it into containerd (if required by your cluster).
Create the honeypot-ns namespace.
Deploy your SSH honeypot (using your provided YAML manifest).
Build and test the DeepSeek analysis container.
Deploy the DeepSeek analysis container into Kubernetes.
List pods and deployments.
Tail the logs of the DeepSeek analysis pod for real-time monitoring.
