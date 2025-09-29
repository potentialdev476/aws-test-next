#!/bin/bash
echo "Before install - stopping PM2 processes and cleaning directory"

# CRITICAL FIX: Copy appspec.yml to current directory where CodeDeploy expects it
echo "=== CRITICAL FIX: Ensuring appspec.yml is where CodeDeploy expects it ==="
if [ -f "deployment-archive/appspec.yml" ] && [ ! -f "appspec.yml" ]; then
    echo "Copying appspec.yml from deployment-archive to current directory"
    cp deployment-archive/appspec.yml .
    echo "appspec.yml copied successfully"
    ls -la appspec.yml
elif [ -f "appspec.yml" ]; then
    echo "appspec.yml already exists in current directory"
    ls -la appspec.yml
else
    echo "Checking deployment-archive for appspec.yml..."
    ls -la deployment-archive/ | grep appspec || echo "appspec.yml not found in deployment-archive"
fi

# DEBUG: Check what's in the deployment bundle
echo "=== DEBUG: Checking deployment bundle contents ==="
pwd
ls -la
echo "=== DEBUG: Looking for appspec.yml ==="
find . -name "appspec.yml" -type f
echo "=== DEBUG: Current directory structure ==="
tree -a || find . -type f | head -20

# AUTO-FIX: Resolve CodeDeploy appspec.yml timing issue
echo "=== AUTO-FIX: Resolving appspec.yml timing issue ==="
if [ ! -d "deployment-archive" ]; then
    echo "Creating deployment-archive directory..."
    mkdir -p deployment-archive
    
    # Download latest artifact and extract
    echo "Downloading latest artifact..."
    LATEST_ARTIFACT=$(aws s3 ls s3://codepipeline-us-east-2-c42590e5c592-4a71-8e71-6a918238eba5/aws-next-pl-arnold/SourceArti/ --region us-east-2 | tail -1 | awk '{print $4}')
    if [ ! -z "$LATEST_ARTIFACT" ]; then
        aws s3 cp s3://codepipeline-us-east-2-c42590e5c592-4a71-8e71-6a918238eba5/aws-next-pl-arnold/SourceArti/$LATEST_ARTIFACT /tmp/artifact.zip --region us-east-2
        unzip -q /tmp/artifact.zip -d deployment-archive/
        echo "Auto-fix completed: artifacts extracted successfully"
        rm -f /tmp/artifact.zip
        
        # CRITICAL: Ensure appspec.yml is in root directory for CodeDeploy
        if [ -f "deployment-archive/appspec.yml" ] && [ ! -f "appspec.yml" ]; then
            cp deployment-archive/appspec.yml .
            echo "Copied appspec.yml to root for CodeDeploy access"
        fi
    fi
fi

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

# Stop and delete PM2 processes (these errors are harmless)
echo "Stopping PM2 processes..."
pm2 stop aws-test-next 2>/dev/null || echo "PM2 process aws-test-next not found (expected)"
pm2 delete aws-test-next 2>/dev/null || echo "PM2 process aws-test-next not found (expected)"

# Clean deployment directory to avoid file conflicts
echo "Cleaning deployment directory"
rm -rf /var/www/aws-test-next/*
rm -rf /var/www/aws-test-next/.* 2>/dev/null || true

# Final disk space check
echo "=== FINAL DISK SPACE CHECK ==="
df -h
echo "Available space in deployment directory:"
df -h /var/www/aws-test-next