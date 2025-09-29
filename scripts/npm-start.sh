cd /var/www/aws-test-next

# Kill any existing processes first
pm2 stop aws-test-next 2>/dev/null || true
pm2 delete aws-test-next 2>/dev/null || true

# Build the app
npm run build

# Start fresh process
pm2 start npm --name "aws-test-next" -- start

# Show status
pm2 status