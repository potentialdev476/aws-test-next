#!/bin/bash
echo "After install - setting up Next.js application"
cd /var/www/aws-test-next

# Check disk space before proceeding
echo "Checking disk space before setup:"
df -h /var/www/aws-test-next

# Ensure .env files exist for production
if [ ! -f .env.production ]; then
    echo "NEXT_PUBLIC_BASE_PATH=/next" > .env.production
    echo "Created .env.production file"
fi

# Install only production dependencies
echo "Installing production dependencies..."
npm ci --production --prefer-offline --no-audit --no-fund

# Check if .next directory exists (from buildspec build)
if [ -d ".next" ]; then
    echo "Build artifacts found, skipping build"
    ls -la .next/
else
    echo "ERROR: No build artifacts found. Build should have been done in CodeBuild."
    exit 1
fi

# Set proper permissions
echo "Setting proper permissions..."
chown -R www-data:www-data /var/www/aws-test-next
chmod -R 755 /var/www/aws-test-next

# Final disk space check
echo "Final disk space check:"
df -h /var/www/aws-test-next
echo "Application setup completed successfully"

