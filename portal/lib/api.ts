import axios from "axios";
import { clearAuth, getToken } from "./auth";

const BASE_URL = `${process.env.NEXT_PUBLIC_API_URL}/api/v1`;

const api = axios.create({
  baseURL: BASE_URL,
  timeout: 30_000,
});

// Attach JWT to every request
api.interceptors.request.use((config) => {
  const token = getToken();
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

// Global 401 handler
api.interceptors.response.use(
  (res) => res,
  (error) => {
    if (typeof window !== "undefined" && error.response?.status === 401) {
      clearAuth();
      window.location.href = "/login";
    }
    return Promise.reject(error);
  }
);

export default api;

export function apiErrorMessage(err: unknown): string {
  if (axios.isAxiosError(err)) {
    const data = err.response?.data as { message?: string; error?: string } | undefined;
    return data?.message ?? data?.error ?? err.message ?? "Something went wrong";
  }
  return "Something went wrong";
}
