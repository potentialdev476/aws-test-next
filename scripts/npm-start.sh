#!/bin/bash
cd /var/www/html/aws-test-next
yarn build
pm2 restart aws-test-next