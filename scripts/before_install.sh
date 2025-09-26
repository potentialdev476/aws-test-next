#!/bin/bash
echo "Before install - stopping PM2 processes"
pm2 stop aws-test-next || true
pm2 delete aws-test-next || true

