#!/bin/bash
echo "After install - installing dependencies"
cd /var/www/aws-test-next
npm ci --production
npm run build

