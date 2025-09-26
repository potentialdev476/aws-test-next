#!/bin/bash

# Emergency Cleanup Script for CodeDeploy
# Run this BEFORE starting a new deployment to free up disk space

echo "🚨 EMERGENCY DISK CLEANUP - PRE-DEPLOYMENT"
echo "=========================================="
echo "Timestamp: $(date)"
echo ""

# Check initial disk space
echo "📊 Initial disk usage:"
df -h
echo ""

# Function to get available space in GB
get_available_space() {
    df / | awk 'NR==2 {print int($4/1024/1024)}'
}

AVAILABLE_SPACE=$(get_available_space)
echo "💾 Available space: ${AVAILABLE_SPACE}GB"

# Always perform cleanup for CodeDeploy
echo "🗑️  Removing ALL CodeDeploy deployments..."
sudo rm -rf /opt/codedeploy-agent/deployment-root/d-* 2>/dev/null || true
sudo rm -rf /opt/codedeploy-agent/deployment-root/*/bundle.tar 2>/dev/null || true

# Clean up npm cache
echo "📦 Cleaning npm cache..."
npm cache clean --force 2>/dev/null || true
rm -rf ~/.npm/_cacache 2>/dev/null || true

# Clean up temporary files
echo "🧹 Cleaning temporary files..."
sudo rm -rf /tmp/* 2>/dev/null || true
sudo rm -rf /var/tmp/* 2>/dev/null || true

# Clean up system logs
echo "📝 Cleaning system logs..."
sudo find /var/log -name "*.log" -mtime +1 -delete 2>/dev/null || true

# Clean up package manager cache
echo "📦 Cleaning package manager cache..."
sudo apt-get clean 2>/dev/null || true
sudo apt-get autoclean 2>/dev/null || true

# Clean up PM2 logs
echo "📝 Cleaning PM2 logs..."
pm2 flush 2>/dev/null || true

# Check space after cleanup
NEW_AVAILABLE_SPACE=$(get_available_space)
echo "✅ Cleanup completed. Available space: ${NEW_AVAILABLE_SPACE}GB"

echo ""
echo "📊 Final disk usage:"
df -h
echo ""
echo "🎯 Emergency cleanup completed!"
echo "Ready for CodeDeploy deployment."
