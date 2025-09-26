#!/bin/bash
echo "Application start - starting Next.js with PM2"
cd /var/www/aws-test-next
pm2 start npm --name "aws-test-next" -- start
pm2 save

