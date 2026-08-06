import axios from "axios";

import {
  clearAuth,
  getRefreshToken,
  getToken,
  isTokenExpired,
  setCurrentUser,
  setTokens,
} from "./auth";
import { BASE_PATH, appUrl, isOnPath } from "./navigation";
import type { ApiResponse, User } from "@/types";

// Session lifecycle: refreshing the access token, and ending the session when
// that is no longer possible.
//
// This module must never import ./api — lib/api.ts imports *this* one, and the
// refresh call deliberately bypasses the shared axios instance so a 401 on
// /auth/refresh cannot re-enter the interceptor that triggered it.

// Every request goes straight from the browser to the Flask backend. The admin
// panel ships as a static export on cPanel, so there is no Next.js server to
// host route handlers or server actions — do not add app/**/route.ts here.
export const API_BASE_URL =
  (process.env.NEXT_PUBLIC_API_URL ??
    "https://staging.thirdeyegfx.in/butterfly_backend")
    .replace(/\/$/, "") + "/api/v1";

interface RefreshResponse {
  access_token: string;
  refresh_token?: string;
  user?: User;
}

// ── Single-flight lock ────────────────────────────────────────────────────────
// A dashboard page typically fires several requests at once. Without this lock
// each one would launch its own refresh; because the backend *rotates* the
// refresh token, the second call would present a token the first had already
// consumed and the whole session would collapse. One refresh, shared by all
// waiters.
let inFlight: Promise<string | null> | null = null;

/**
 * Obtain a usable access token, refreshing if the current one is expired.
 *
 * Returns the token, or null when the session is genuinely over (no refresh
 * token, or the server rejected it). Concurrent callers share one round-trip.
 */
export function ensureAccessToken(): Promise<string | null> {
  const current = getToken();
  if (!isTokenExpired(current)) return Promise.resolve(current);
  return refreshSession();
}

/**
 * Exchange the stored refresh token for a new access token (and a rotated
 * refresh token). Returns null if the session cannot be revived.
 */
export function refreshSession(): Promise<string | null> {
  inFlight ??= performRefresh().finally(() => {
    inFlight = null;
  });
  return inFlight;
}

async function performRefresh(): Promise<string | null> {
  const refreshToken = getRefreshToken();
  if (!refreshToken || isTokenExpired(refreshToken)) return null;

  try {
    // A bare client, not the shared instance from lib/api.ts: no request
    // interceptor to overwrite our Authorization header with the *access*
    // token, and no response interceptor to recurse on a 401.
    //
    // flask_jwt_extended reads the refresh token from the Authorization header
    // (JWT_TOKEN_LOCATION = ["headers"]), never from the body.
    const res = await axios.post<ApiResponse<RefreshResponse>>(
      `${API_BASE_URL}/auth/refresh`,
      null,
      {
        baseURL: undefined,
        timeout: 30_000,
        headers: { Authorization: `Bearer ${refreshToken}` },
      }
    );

    const data = res.data?.data;
    if (!data?.access_token) return null;

    setTokens(data.access_token, data.refresh_token);
    // The refresh response carries the current profile, so a role change or a
    // suspension applied mid-session lands without a separate /auth/me call.
    if (data.user) setCurrentUser(data.user);
    return data.access_token;
  } catch (err) {
    // The server answered and rejected the refresh token (expired, revoked,
    // account suspended) → the session is over.
    //
    // A request that never got a response is an offline blip or a CORS/DNS
    // problem. Returning null there would sign the user out for losing wifi,
    // so keep the tokens and let the caller surface a normal network error;
    // the next attempt can still succeed.
    if (axios.isAxiosError(err) && !err.response) throw err;
    return null;
  }
}

/**
 * Tear down the session and send the browser to /login, remembering where the
 * user was so they land back there after signing in.
 *
 * `reason` becomes ?session=<reason> so the login page can explain itself
 * ("expired") instead of silently reappearing. A deliberate sign-out passes
 * nothing and gets no explanation.
 *
 * Safe to call from several failing requests at once: the isOnPath guard keeps
 * a burst of 401s from stacking navigations, and replace() (not assign) keeps
 * the dead page out of history so Back doesn't bounce through it.
 */
export function endSession(reason?: "expired"): void {
  clearAuth();
  if (typeof window === "undefined" || isOnPath("/login")) return;

  // window.location.pathname still carries the basePath; /login expects an
  // app-relative "next", which is what appUrl() will re-prefix on the way back.
  const raw = window.location.pathname.slice(BASE_PATH.length) || "/";
  const path = raw.startsWith("/") ? raw : `/${raw}`;

  const params = new URLSearchParams();
  if (path !== "/" && !path.startsWith("/login")) params.set("next", path);
  if (reason) params.set("session", reason);

  const query = params.toString();
  window.location.replace(appUrl(query ? `/login?${query}` : "/login"));
}
