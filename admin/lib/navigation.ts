// Central place for basePath-aware URLs.
//
// The app is deployed to a subdirectory (basePath "/admin") as a fully static
// export on cPanel. next/link and useRouter() prefix the basePath for you, and
// usePathname() strips it back off — but anything that touches the raw URL
// (window.location, plain <img src>, <a href>) does not. Use these helpers
// there so the prefix lives in exactly one place.

export const BASE_PATH = (process.env.NEXT_PUBLIC_BASE_PATH ?? "/admin").replace(/\/$/, "");

// next.config.ts sets trailingSlash: true, so every exported page lives at
// <path>/index.html. Hard navigations must include the trailing slash or
// Apache issues an extra 301.
function withTrailingSlash(pathname: string): string {
  return pathname.endsWith("/") ? pathname : `${pathname}/`;
}

/**
 * Turn an app-relative path into a real browser URL.
 * appUrl("/login") → "/admin/login/"   appUrl("/login?next=/users") → "/admin/login/?next=/users"
 */
export function appUrl(path = "/"): string {
  const splitAt = path.search(/[?#]/);
  const rawPath = splitAt === -1 ? path : path.slice(0, splitAt);
  const suffix = splitAt === -1 ? "" : path.slice(splitAt);
  const pathname = rawPath.startsWith("/") ? rawPath : `/${rawPath}`;
  return `${BASE_PATH}${withTrailingSlash(pathname)}${suffix}`;
}

/** Resolve a static asset in public/ — e.g. assetUrl("/pathanga-logo.png"). */
export function assetUrl(path: string): string {
  return `${BASE_PATH}${path.startsWith("/") ? path : `/${path}`}`;
}

/** Full page load to an app-relative path. Use for auth transitions. */
export function hardRedirect(path: string): void {
  if (typeof window === "undefined") return;
  window.location.href = appUrl(path);
}

/** True when the browser is currently on the given app-relative path. */
export function isOnPath(path: string): boolean {
  if (typeof window === "undefined") return false;
  return window.location.pathname.startsWith(`${BASE_PATH}${path}`);
}

/**
 * Strip the trailing slash usePathname() carries because of trailingSlash: true,
 * so route comparisons ("/dashboard/" vs "/dashboard") line up.
 */
export function normalizePath(pathname: string): string {
  const stripped = pathname.replace(/\/+$/, "");
  return stripped === "" ? "/" : stripped;
}

/**
 * Read the real id out of the URL for a detail route.
 *
 * Detail pages are exported as a single static template (…/observations/id/)
 * and .htaccess rewrites /observations/:id onto it, so the `params` the page
 * receives always says "id". The address bar still holds the true value.
 */
export function routeId(pathname: string, fallback = ""): string {
  const last = normalizePath(pathname).split("/").filter(Boolean).pop();
  return last && last !== "id" ? decodeURIComponent(last) : fallback;
}
