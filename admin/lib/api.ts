import axios, { type AxiosError } from "axios";
import { getToken, clearAuth } from "./auth";

const BASE_URL =
  (process.env.NEXT_PUBLIC_API_URL ??
    "https://staging.thirdeyegfx.in/butterfly_backend") + "/api/v1";

const api = axios.create({
  baseURL: BASE_URL,
  timeout: 30_000,
  headers: { "Content-Type": "application/json" },
});

// ── Request interceptor: attach JWT ────────────────────────────────────────────
api.interceptors.request.use((config) => {
  const token = getToken();
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

// ── Response interceptor: handle 401 globally ─────────────────────────────────
api.interceptors.response.use(
  (res) => res,
  (error: AxiosError) => {
    if (error.response?.status === 401) {
      clearAuth();
      if (typeof window !== "undefined") {
        window.location.href = "/login";
      }
    }
    return Promise.reject(error);
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
