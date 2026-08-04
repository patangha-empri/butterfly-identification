import type { NextConfig } from "next";

// Single source of truth for the sub-path this app is deployed under.
// lib/navigation.ts reads the same variable so raw-URL navigation
// (window.location, <img src>) can't drift from Next's own prefixing.
const basePath = (process.env.NEXT_PUBLIC_BASE_PATH ?? "/admin").replace(/\/$/, "");

const nextConfig: NextConfig = {
  // Static HTML export — deployed to cPanel with no Node.js server. That rules
  // out proxy/middleware, route handlers, server actions and server-side
  // redirect(); all data fetching happens in the browser via lib/api.ts and
  // route protection is client-side in app/(dashboard)/layout.tsx.
  output: "export",
  basePath,
  trailingSlash: true,
  // Inlined so the client bundle can build basePath-aware raw URLs.
  env: {
    NEXT_PUBLIC_BASE_PATH: basePath,
  },
  images: {
    unoptimized: true,
  },
};

export default nextConfig;
