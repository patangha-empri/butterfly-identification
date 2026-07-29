import { NextResponse, type NextRequest } from "next/server";

const PUBLIC_PATHS = ["/login"];

export function proxy(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const token = request.cookies.get("auth-token")?.value;

  const isPublic = PUBLIC_PATHS.some((p) => pathname.startsWith(p));

  if (isPublic) {
    // Already authenticated — send to dashboard
    if (token) return NextResponse.redirect(new URL("/", request.url));
    return NextResponse.next();
  }

  // Protected route — require token
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
