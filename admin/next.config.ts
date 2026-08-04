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
  //
  // Builds only, never `next dev`. Detail routes export a single template
  // (/species/id/) that .htaccess rewrites real ids onto, so generateStaticParams
  // returns just the "id" placeholder. Under `output: export` Next also enforces
  // that list in dev — where no rewrite exists — so opening /species/<real-uuid>/
  // failed with «missing param … in generateStaticParams()». Dev serves dynamic
  // params normally instead; routeId() reads the id from the URL either way.
  //
  // Trade-off: dev no longer rejects server-only features on sight, so they fail
  // at build time rather than immediately. Keep this file's constraints in mind.
  output: process.env.NODE_ENV === "production" ? "export" : undefined,
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
