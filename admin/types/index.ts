// ── Auth ───────────────────────────────────────────────────────────────────────
export type UserRole = "user" | "moderator" | "admin" | "super_admin";

export interface LoginResponse {
  access_token: string;
  refresh_token: string;
  user: User;
}

// ── Users ──────────────────────────────────────────────────────────────────────
// Shape mirrors backend user_repo.user_to_dict (+ stats/streak on the admin
// detail route). The avatar field is `profile_image_url`, NOT `avatar_url`.
export interface User {
  id: string;
  email: string;
  full_name: string;
  username: string;
  role: UserRole | null;
  is_active: boolean;
  is_suspended?: boolean;
  is_verified: boolean;
  bio?: string;
  profile_image_url?: string;
  preferred_state_id?: number;
  last_login_at?: string;
  created_at: string;
  updated_at?: string;
  stats?: UserStats;
  streak?: UserStreak;
  // Active (non-revoked) moderation counters — admin endpoints only.
  active_warnings?: number;
  active_flags?: number;
}

// ── Moderation ─────────────────────────────────────────────────────────────────
export type ModerationActionType =
  | "warning"
  | "flag"
  | "suspension"
  | "unsuspension"
  | "content_removed";

export interface ModerationAction {
  id: string;
  user_id: string;
  admin_id?: string;
  admin_username?: string;
  admin_full_name?: string;
  action_type: ModerationActionType;
  reason?: string;
  related_entity_type?: string;
  related_entity_id?: string;
  created_at: string;
  revoked_at?: string;
}

export interface UserStats {
  total_observations?: number;
  total_identifications?: number;
  total_species_observed?: number;
  total_states_explored?: number;
  total_points?: number;
}

export interface UserStreak {
  current_streak?: number;
  longest_streak?: number;
  last_observation_date?: string;
}

// ── Species ────────────────────────────────────────────────────────────────────
// Shape mirrors backend species_service._to_dict(include_related=True).
export interface SpeciesImage {
  image_url: string;
  thumbnail_url?: string;
  image_type?: string;
  is_primary?: boolean;
  credit?: string;
  caption?: string;
}

export interface SpeciesHostPlant {
  name: string;
  scientific_name?: string;
}

export interface SpeciesDistribution {
  state_id: number;
  state_name?: string;
  state_code?: string;
  abundance?: string;
}

export interface Species {
  id: string;
  common_name: string;
  scientific_name: string;
  family: string;
  genus: string;
  description?: string;
  description_short?: string;
  habitat?: string;
  rarity?: string;
  conservation_status?: string;
  wingspan_mm?: string;
  flight_months?: number[];
  color_tags?: string[];
  slug: string;
  primary_image_url?: string;
  primary_image?: SpeciesImage | null;
  observation_count?: number;
  host_plants?: SpeciesHostPlant[];
  states?: string[];
  images?: SpeciesImage[];
  distribution_states?: SpeciesDistribution[];
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

export type ObservationPrivacy = "public" | "private" | "anonymous_public";

export interface ObservationImage {
  id: string;
  original_url: string;
  optimized_url?: string;
  thumbnail_url?: string;
  is_primary: boolean;
  width?: number;
  height?: number;
}

// Shape mirrors backend observation_service._obs_to_dict.
export interface Observation {
  id: string;
  user_id: string;
  user?: Pick<
    User,
    "id" | "username" | "full_name" | "profile_image_url" | "bio" | "is_verified" | "role"
  > | null;
  species_id?: string;
  title?: string;
  notes?: string;
  weather?: string;
  butterfly_activity?: string;
  count_observed?: number;
  observed_at?: string;
  state_id: number;
  state_name?: string;
  district_id?: number;
  district_name?: string;
  latitude?: number;
  longitude?: number;
  location_name?: string;
  privacy: ObservationPrivacy;
  verification_status: VerificationStatus;
  created_at: string;
  // ── AI identification summary ──
  identification_status?: string;
  identified_species_id?: string;
  identified_species_name?: string;
  identification_confidence?: number;
  identification_reasoning?: string;
  // ── Social ──
  like_count?: number;
  comment_count?: number;
  primary_image_url?: string;
  images?: ObservationImage[];
  // ── Moderation (admin/owner only) ──
  admin_notes?: string;
}

// ── Observation Social (admin) ──────────────────────────────────────────────
export interface ObservationLiker {
  user: Pick<User, "id" | "username" | "full_name" | "profile_image_url">;
  liked_at: string;
}

export interface ObservationComment {
  id: string;
  body: string;
  created_at: string;
  user: Pick<User, "id" | "username" | "full_name" | "profile_image_url"> | null;
}

export interface ObservationSocial {
  like_count: number;
  likers: ObservationLiker[];
  comment_count: number;
  comments: ObservationComment[];
}

// ── Identifications ────────────────────────────────────────────────────────────
export interface IdentificationMatch {
  id: number;
  rank: number;
  confidence_score: number;
  matched_common_name: string;
  matched_scientific_name: string;
  species_id?: string;
  is_accepted: boolean;
  admin_notes?: string;
}

export interface IdentificationResult {
  id: string;
  observation_id: string;
  user_id?: string;
  status: "pending" | "processing" | "completed" | "failed";
  error_message?: string;
  processing_time_ms?: number;
  gemini_model_version?: string;
  created_at: string;
  completed_at?: string;
  input_token_count?: number;
  output_token_count?: number;
  total_token_count?: number;
  matches: IdentificationMatch[];
  observation?: {
    id: string;
    title?: string;
    notes?: string;
    location_name?: string;
    latitude?: number;
    longitude?: number;
    verification_status: string;
    created_at: string;
    primary_image_url?: string;
    user?: {
      username: string;
      full_name?: string;
    } | null;
  } | null;
}

// ── CMS ────────────────────────────────────────────────────────────────────────
export interface CmsArticle {
  id: string;
  title: string;
  slug: string;
  summary?: string;
  excerpt?: string;
  content?: string;
  cover_image_url?: string;
  author_id: string;
  author?: Pick<User, "id" | "username" | "full_name">;
  status: "draft" | "published" | "archived";
  article_type?: "educational" | "facts" | "news" | "events";
  category?: string;
  tags?: string[];
  published_at?: string;
  created_at: string;
  updated_at?: string;
}

// ── Reports ────────────────────────────────────────────────────────────────────
export interface Report {
  id: string;
  reporter_id: string;
  reporter?: Pick<User, "id" | "username" | "full_name">;
  target_type: "observation" | "user" | "comment";
  target_id: string;
  reason: string;
  description?: string;
  status: "open" | "resolved" | "dismissed";
  resolved_by?: string;
  created_at: string;
}

// ── Dashboard ──────────────────────────────────────────────────────────────────
export interface DashboardStats {
  total_users: number;
  total_observations: number;
  total_species: number;
  total_identifications: number;
  pending_observations: number;
  rejected_observations?: number;
  suspended_users?: number;
  warned_users?: number;
  flagged_users?: number;
  // Rolling last-30-days counters (backend keys are *_30d).
  new_users_30d?: number;
  new_observations_30d?: number;
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
