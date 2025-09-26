#!/bin/bash

# Next.js Frontend Deployment Script
echo "🚀 Deploying Next.js Frontend..."

# Install dependencies
echo "📦 Installing dependencies..."
npm ci --production

# Build for production
echo "🔨 Building for production..."
npm run build

# Start the application
echo "🔄 Starting Next.js application..."
pm2 restart nextjs-app || pm2 start npm --name "nextjs-app" -- start

echo "✅ Next.js Frontend deployment completed!"
echo "🌐 Access at: http://your-ec2-ip/next/"
