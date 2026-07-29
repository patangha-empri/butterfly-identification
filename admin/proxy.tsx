// proxy.tsx — Next.js 16 route protection (replaces middleware.ts)
// .tsx extension is used so that proxy.ts (legacy) is invisible to the detector
// when pageExtensions excludes ".ts".
import { NextResponse, type NextRequest } from "next/server";

const PUBLIC_PATHS = ["/login"];

export function proxy(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const token = request.cookies.get("auth-token")?.value;

  const isPublic = PUBLIC_PATHS.some((p) => pathname.startsWith(p));

  if (isPublic) {
    if (token) return NextResponse.redirect(new URL("/dashboard", request.url));
    return NextResponse.next();
  }

  if (!token) {
    const loginUrl = new URL("/login", request.url);
    loginUrl.searchParams.set("next", pathname);
    return NextResponse.redirect(loginUrl);
  }

  return NextResponse.next();
}

export const config = {
  // Skip Next internals and any static file (paths containing a dot, e.g.
  // /pathanga-logo.png) — public/ assets are served from the root path.
  matcher: ["/((?!_next/static|_next/image|favicon.ico|icon.png|.*\\..*).*)"],
};
