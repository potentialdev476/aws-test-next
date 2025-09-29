#!/bin/bash
cd /var/www/aws-test-next
npm run build
pm2 start npm --name "aws-test-next" -- start