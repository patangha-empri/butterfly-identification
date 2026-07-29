// ── Auth ───────────────────────────────────────────────────────────────────────
export type UserRole = "user" | "moderator" | "admin" | "super_admin";

export interface LoginResponse {
  access_token: string;
  refresh_token: string;
  user: User;
}

export interface RegisterResponse {
  access_token: string;
  refresh_token: string;
  user: User;
}

// ── Users ──────────────────────────────────────────────────────────────────────
export interface User {
  id: string;
  email: string;
  full_name: string;
  username: string;
  role: UserRole | null;
  is_active: boolean;
  is_verified: boolean;
  bio?: string | null;
  profile_image_url?: string | null;
  preferred_state_id?: number | null;
  created_at: string;
  stats?: UserStats;
}

export interface UserStats {
  total_observations: number;
  verified_observations: number;
  observation_streak: number;
  longest_streak: number;
}

// ── Species ────────────────────────────────────────────────────────────────────
export interface Species {
  id: string;
  common_name: string;
  scientific_name: string;
  family: string;
  genus: string;
  description?: string;
  habitat?: string;
  flight_period?: string;
  conservation_status?: string;
  color_tags?: string[];
  thumbnail_url?: string;
  image_url?: string;
  host_plants?: string[];
  is_active: boolean;
  observation_count?: number;
  created_at: string;
}

// ── Geography ──────────────────────────────────────────────────────────────────
export interface State {
  id: number;
  name: string;
  code: string;
  region?: string;
}

// ── Observations ───────────────────────────────────────────────────────────────
export type VerificationStatus =
  | "pending"
  | "ai_identified"
  | "expert_verified"
  | "community_verified"
  | "rejected";

export type ObservationPrivacy = "public" | "private" | "anonymous";

export interface ObservationImage {
  id: number;
  original_url: string;
  optimized_url?: string;
  thumbnail_url?: string;
  is_primary: boolean;
  width?: number;
  height?: number;
}

export interface Observation {
  id: string;
  user_id: string;
  user?: Pick<User, "id" | "username" | "full_name" | "profile_image_url">;
  species_id?: string;
  species?: Pick<Species, "id" | "common_name" | "scientific_name" | "thumbnail_url">;
  state_id: number;
  state?: State;
  latitude?: number;
  longitude?: number;
  location_name?: string;
  title?: string;
  notes?: string;
  observed_at?: string;
  privacy: ObservationPrivacy;
  verification_status: VerificationStatus;
  is_active: boolean;
  created_at: string;
  updated_at?: string;
  images?: ObservationImage[];
  identification?: IdentificationSummary;
}

export interface IdentificationSummary {
  status: "pending" | "processing" | "completed" | "failed";
  top_match?: {
    common_name: string;
    scientific_name: string;
    confidence_score: number;
  };
}

// ── CMS ────────────────────────────────────────────────────────────────────────
export interface CmsArticle {
  id: string;
  title: string;
  slug: string;
  summary?: string;
  content?: string;
  cover_image_url?: string;
  author?: Pick<User, "id" | "username" | "full_name">;
  status: "draft" | "published" | "archived";
  category?: string;
  tags?: string[];
  published_at?: string;
  created_at: string;
}

// ── Dashboard / Public Stats ───────────────────────────────────────────────────
export interface PublicStats {
  total_observations: number;
  total_species: number;
  total_users: number;
  verified_observations: number;
}

// ── API helpers ────────────────────────────────────────────────────────────────
export interface ApiResponse<T> {
  success: boolean;
  data: T;
  message?: string;
  meta?: PaginationMeta;
  errors?: Record<string, string[]>;
}

export interface PaginationMeta {
  page: number;
  per_page: number;
  total: number;
  pages: number;
  has_next: boolean;
  has_prev: boolean;
}

export interface ListParams {
  page?: number;
  per_page?: number;
  search?: string;
  status?: string;
  [key: string]: string | number | boolean | undefined;
}
