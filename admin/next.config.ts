import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Exclude plain .ts from page detection so that the legacy middleware.ts
  // and the (unused) proxy.ts at the root don't trigger the
  // "both middleware and proxy detected" conflict in Next.js 16.
  // All actual pages / layouts use .tsx; route protection lives in proxy.tsx.
  pageExtensions: ["js", "jsx", "tsx"],
};

export default nextConfig;
