import type { User } from "@/types";

const TOKEN_KEY = "butterfly_portal_token";
const REFRESH_KEY = "butterfly_portal_refresh";
const USER_KEY = "butterfly_portal_user";
const COOKIE_NAME = "auth-token";

export function getToken(): string | null {
  if (typeof window === "undefined") return null;
  return localStorage.getItem(TOKEN_KEY);
}

export function setTokens(accessToken: string, refreshToken?: string): void {
  localStorage.setItem(TOKEN_KEY, accessToken);
  if (refreshToken) localStorage.setItem(REFRESH_KEY, refreshToken);
  const maxAge = 60 * 60 * 24 * 7; // 7 days
  document.cookie = `${COOKIE_NAME}=${accessToken}; path=/; max-age=${maxAge}; SameSite=Lax`;
}

export function clearAuth(): void {
  localStorage.removeItem(TOKEN_KEY);
  localStorage.removeItem(REFRESH_KEY);
  localStorage.removeItem(USER_KEY);
  document.cookie = `${COOKIE_NAME}=; path=/; expires=Thu, 01 Jan 1970 00:00:00 GMT`;
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

export function isLoggedIn(): boolean {
  return !!getToken();
}
