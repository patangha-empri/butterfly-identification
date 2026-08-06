import type { User } from "@/types";

// Token storage + JWT introspection. Nothing here talks to the network — the
// refresh round-trip and its single-flight lock live in lib/session.ts, which
// imports this module. Keeping that split is what stops lib/api.ts (which owns
// the axios instance) and lib/session.ts (which uses it) from forming a cycle.

const TOKEN_KEY = "butterfly_admin_token";
const REFRESH_KEY = "butterfly_admin_refresh";
const USER_KEY = "butterfly_admin_user";

// Refresh this many seconds *before* the access token's own `exp`. Covers
// clock skew between the browser and the Flask host plus the flight time of
// the request we are about to send, so a token can't expire mid-request.
export const EXPIRY_SKEW_SECONDS = 60;

export function getToken(): string | null {
  if (typeof window === "undefined") return null;
  return localStorage.getItem(TOKEN_KEY);
}

export function getRefreshToken(): string | null {
  if (typeof window === "undefined") return null;
  return localStorage.getItem(REFRESH_KEY);
}

export function setTokens(accessToken: string, refreshToken?: string): void {
  localStorage.setItem(TOKEN_KEY, accessToken);
  // The backend rotates the refresh token on every /auth/refresh, so this is
  // written repeatedly across a session — but never clobber a good stored
  // token with undefined if a caller only has the access half.
  if (refreshToken) localStorage.setItem(REFRESH_KEY, refreshToken);
}

export function clearAuth(): void {
  localStorage.removeItem(TOKEN_KEY);
  localStorage.removeItem(REFRESH_KEY);
  localStorage.removeItem(USER_KEY);
}

export function setCurrentUser(user: User): void {
  localStorage.setItem(USER_KEY, JSON.stringify(user));
}

export function getCurrentUser(): User | null {
  if (typeof window === "undefined") return null;
  try {
    const stored = localStorage.getItem(USER_KEY);
    return stored ? (JSON.parse(stored) as User) : null;
  } catch {
    return null;
  }
}

export function isStaff(user: User | null): boolean {
  return ["admin", "super_admin", "moderator"].includes(user?.role ?? "");
}

export function isSuperAdmin(user: User | null): boolean {
  return ["admin", "super_admin"].includes(user?.role ?? "");
}

// ── JWT introspection ─────────────────────────────────────────────────────────
// We only read the `exp` claim to decide *when* to refresh. This is a UX
// optimisation, never a security check — the signature is verified by Flask,
// and a forged local token simply earns a 401 on the next request.

/** Epoch milliseconds at which `token` expires, or null if it carries no exp. */
export function tokenExpiresAt(token: string | null): number | null {
  if (!token) return null;
  const payload = token.split(".")[1];
  if (!payload) return null;
  try {
    // base64url → base64, then pad to a multiple of 4 for atob().
    const base64 = payload.replace(/-/g, "+").replace(/_/g, "/");
    const padded = base64.padEnd(Math.ceil(base64.length / 4) * 4, "=");
    const claims = JSON.parse(atob(padded)) as { exp?: number };
    return typeof claims.exp === "number" ? claims.exp * 1000 : null;
  } catch {
    return null;
  }
}

/**
 * True when `token` is missing, malformed, or within `skewSeconds` of expiring.
 *
 * A token with no readable `exp` is treated as *not* expired: we can't prove it
 * is stale, so let the server be the judge rather than logging the user out on
 * a parsing quirk.
 */
export function isTokenExpired(
  token: string | null,
  skewSeconds = EXPIRY_SKEW_SECONDS
): boolean {
  if (!token) return true;
  const expiresAt = tokenExpiresAt(token);
  if (expiresAt === null) return false;
  return Date.now() >= expiresAt - skewSeconds * 1000;
}

/**
 * True when the browser holds credentials worth acting on — either a live
 * access token or a refresh token that can mint one.
 *
 * Route guards must use this rather than `getToken()`. An expired access token
 * with a valid 30-day refresh token is a perfectly good session; bouncing it to
 * /login was the old behaviour and the reason sessions felt like they died
 * after a day.
 */
export function hasSession(): boolean {
  if (typeof window === "undefined") return false;
  return !isTokenExpired(getToken()) || !isTokenExpired(getRefreshToken());
}

/**
 * True when tokens are stored at all, regardless of whether they still work.
 *
 * Distinguishes "your session ran out" from "you were never signed in", so the
 * login page only apologises in the first case.
 */
export function hasStoredCredentials(): boolean {
  if (typeof window === "undefined") return false;
  return Boolean(getToken() ?? getRefreshToken());
}

/** True when only the refresh token is still usable — i.e. refresh before use. */
export function needsRefresh(): boolean {
  if (typeof window === "undefined") return false;
  return isTokenExpired(getToken()) && !isTokenExpired(getRefreshToken());
}
