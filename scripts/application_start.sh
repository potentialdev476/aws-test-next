#!/bin/bash
echo "Application start - starting Next.js with PM2"

# Check disk space before starting
echo "Checking disk space before application start:"
df -h /var/www/aws-test-next

cd /var/www/aws-test-next

# Start the application
pm2 start npm --name "aws-test-next" -- start
pm2 save

echo "Application started successfully"
echo "PM2 status:"
pm2 status

