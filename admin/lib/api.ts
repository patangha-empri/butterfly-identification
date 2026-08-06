import axios, { type AxiosError, type InternalAxiosRequestConfig } from "axios";

import { getToken } from "./auth";
import { API_BASE_URL, endSession, ensureAccessToken, refreshSession } from "./session";

// Every request goes straight from the browser to the Flask backend. The admin
// panel ships as a static export on cPanel, so there is no Next.js server to
// host route handlers or server actions — do not add app/**/route.ts here.
//
// The base URL and all refresh/expiry logic live in lib/session.ts; this file
// only wires them into axios.
const BASE_URL = API_BASE_URL;

const api = axios.create({
  baseURL: BASE_URL,
  timeout: 30_000,
  headers: { "Content-Type": "application/json" },
});

// Requests that must not carry (or provoke) a session refresh: /auth/login and
// /auth/register are pre-session, and /auth/refresh is the refresh itself.
function isAuthEndpoint(url = ""): boolean {
  return /\/auth\/(login|register|refresh)\/?$/.test(url);
}

// One retry per request, tracked on the config so a request can't ping-pong
// between the response interceptor and the server forever.
type RetriableConfig = InternalAxiosRequestConfig & { _retried?: boolean };

// ── Request interceptor ───────────────────────────────────────────────────────
// Refresh *proactively*. The old code attached whatever token was in storage
// and let the server reject it, which meant every expiry cost the user a failed
// request — and, because the response interceptor logged them straight out, a
// trip back to the login page. Here an access token that is expired (or within
// EXPIRY_SKEW_SECONDS of it) is renewed before the request leaves the browser,
// so expiry is invisible for as long as the 30-day refresh token lives.
api.interceptors.request.use(async (config) => {
  if (isAuthEndpoint(config.url)) return config;

  const token = await ensureAccessToken().catch(() => getToken());
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

// ── Response interceptor ──────────────────────────────────────────────────────
// The safety net for the cases the request interceptor cannot predict: a token
// revoked server-side, an account suspended mid-session, or a clock further out
// of sync than the skew allows. Refresh once, replay the original request, and
// only end the session if that fails.
api.interceptors.response.use(
  (res) => res,
  async (error: AxiosError) => {
    const config = error.config as RetriableConfig | undefined;

    if (error.response?.status !== 401) return Promise.reject(error);

    // A 401 from /auth/login is "wrong password" — the form shows it. Only a
    // 401 on an already-authenticated call means the session is gone.
    if (!config || isAuthEndpoint(config.url)) return Promise.reject(error);

    // Already replayed once with a fresh token and still refused: the token is
    // fine but this account can no longer authenticate (suspended, deleted).
    if (config._retried) {
      endSession("expired");
      return Promise.reject(error);
    }

    config._retried = true;

    let token: string | null = null;
    try {
      token = await refreshSession();
    } catch {
      // Network failure during refresh — the session may well still be valid,
      // so surface the original error rather than signing the user out.
      return Promise.reject(error);
    }

    if (!token) {
      endSession("expired");
      return Promise.reject(error);
    }

    config.headers.Authorization = `Bearer ${token}`;
    return api.request(config);
  }
);

export default api;

// ── Typed helpers ──────────────────────────────────────────────────────────────
export function apiErrorMessage(error: unknown): string {
  if (axios.isAxiosError(error)) {
    const data = error.response?.data as
      | { message?: string; error?: string; errors?: Record<string, string[]> }
      | undefined;
    if (data?.errors) {
      const details = Object.entries(data.errors)
        .map(([field, msgs]) => `${field}: ${msgs.join(", ")}`)
        .join("; ");
      return `${data.message ?? "Validation failed"}: ${details}`;
    }
    return data?.message ?? data?.error ?? error.message;
  }
  if (error instanceof Error) return error.message;
  return "An unexpected error occurred.";
}
