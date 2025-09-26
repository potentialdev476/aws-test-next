import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  basePath: '/next',
  assetPrefix: '/next',
  trailingSlash: true,
  output: 'standalone',
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
};

export default nextConfig;
