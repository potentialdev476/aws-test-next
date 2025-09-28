#!/bin/bash
echo "Before install - stopping PM2 processes and cleaning directory"

# DEBUG: Check what's in the deployment bundle
echo "=== DEBUG: Checking deployment bundle contents ==="
pwd
ls -la
echo "=== DEBUG: Looking for appspec.yml ==="
find . -name "appspec.yml" -type f
echo "=== DEBUG: Current directory structure ==="
tree -a || find . -type f | head -20

# CRITICAL: Clean up disk space BEFORE CodeDeploy extracts the bundle
echo "=== EMERGENCY DISK CLEANUP ==="
echo "Current disk usage:"
df -h

# Remove ALL old CodeDeploy deployments immediately
echo "Removing ALL old CodeDeploy deployments to free space"
find /opt/codedeploy-agent/deployment-root -type d -name "d-*" -exec rm -rf {} + 2>/dev/null || true
find /opt/codedeploy-agent/deployment-root -name "bundle.tar" -delete 2>/dev/null || true

# Clean up npm cache and temporary files
echo "Cleaning npm cache and temporary files"
npm cache clean --force 2>/dev/null || true
rm -rf /tmp/npm-* 2>/dev/null || true
rm -rf /tmp/.npm 2>/dev/null || true
rm -rf ~/.npm/_cacache 2>/dev/null || true

# Clean up system temporary files
echo "Cleaning system temporary files"
rm -rf /tmp/* 2>/dev/null || true
rm -rf /var/tmp/* 2>/dev/null || true

# Stop and delete PM2 processes
pm2 stop aws-test-next || true
pm2 delete aws-test-next || true

# Clean deployment directory to avoid file conflicts
echo "Cleaning deployment directory"
rm -rf /var/www/aws-test-next/*
rm -rf /var/www/aws-test-next/.* 2>/dev/null || true

# Final disk space check
echo "=== FINAL DISK SPACE CHECK ==="
df -h
echo "Available space in deployment directory:"
df -h /var/www/aws-test-next

