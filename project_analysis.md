# Project Analysis & API Technical Specifications
## Butterfly Identification System (v2.0)

This document provides a complete technical teardown of the Butterfly Identification System backend and web components. It is structured to serve as a comprehensive reference for generating a fully integrated, premium **Flutter Mobile Application**.

---

## 1. System & Architecture Overview

The platform is designed around a decoupled, three-tier architecture:

```mermaid
graph TD
    subgraph Client Tier
        Portal[Next.js Public Portal]
        Admin[Next.js Admin Panel]
        Flutter[Flutter Mobile Client (Target)]
    end

    subgraph API Tier
        Flask[Flask REST API Gateway]
        JWT[Flask-JWT-Extended]
        Limit[Flask-Limiter]
    end

    subgraph services [Service & Worker Tier]
        Gemini[Google Gemini 1.5 Flash API]
        Bunny[Bunny CDN / Local Storage]
        FCM[Firebase Cloud Messaging]
    end

    subgraph Data Tier
        DB[(PostgreSQL / SQLite)]
    end

    Portal -->|HTTP REST| Flask
    Admin -->|HTTP REST| Flask
    Flutter -->|HTTP REST| Flask

    Flask --> JWT
    Flask --> Limit
    Flask --> DB
    Flask --> Gemini
    Flask --> Bunny
    Flask --> FCM
```

### 1.1 Core Systems
1. **Flask API Backend**: The central engine. Manages authorization, observations CRUD, species catalogs, gamification metrics (achievements, streaks, stats), push notifications, and AI interfaces.
2. **Next.js Admin Panel**: Internal dashboard for moderators and admins. Facilitates user management, role assignments, observation verification/rejection, PDF/Excel reports, species creation, and CMS curation.
3. **Next.js Portal**: A public-facing web platform featuring a species wiki, articles, public sighting feeds, and a basic sighting logger.
4. **Flutter Mobile Client (Upcoming)**: The target application. It will interface with the Flask API to log sightings on-site, upload images directly from camera/gallery, query the AI engine synchronously, track streaks, and view achievements.

### 1.2 Core Integration Flows
- **Authentication**: Stateful-like stateless JWT. The backend issues an access token (24-hour expiry) and a refresh token (30-day expiry). Tokens are sent via the `Authorization: Bearer <token>` header.
- **Image Upload**: Multi-part multipart/form-data. Images are processed, compressed, scaled, and uploaded to Bunny CDN (or saved locally to `uploads/` in dev mode), yielding optimized/thumbnail URLs.
- **AI Species Identification**: Synchronous Gemini Vision integration. Users take photos of butterflies and submit an observation. Triggering identification sends images to Gemini 1.5 Flash with a lepidopterist system prompt, returning classification matches. The backend attempts to resolve matches with the database's species records.
- **Push Notifications**: FCM device registration mapping. User preferences dictate which categories of push events (e.g., AI completion, admin verification, local sightings) trigger notifications.

---

## 2. Database Models & Schemas

The database uses SQLAlchemy ORM. Underneath, it manages the following schemas:

### 2.1 User Management
#### `User` (Table: `users`)
Represents registered users, researchers, moderators, and administrators.
- `id` (VARCHAR(36), PK): UUID generated on creation.
- `email` (VARCHAR(255), Unique, Indexed, Nullable=False)
- `password_hash` (VARCHAR(255), Nullable=False): BCrypt hash.
- `full_name` (VARCHAR(200), Nullable=False)
- `username` (VARCHAR(100), Unique, Indexed, Nullable=False)
- `profile_image_url` (VARCHAR(500), Nullable=True)
- `bio` (TEXT, Nullable=True)
- `role_id` (INTEGER, FK -> `roles.id`, Nullable=False)
- `is_active` (BOOLEAN, Default=True, Nullable=False): Soft-deactivate flag.
- `is_verified` (BOOLEAN, Default=False, Nullable=False): Expert user flag.
- `is_suspended` (BOOLEAN, Default=False, Nullable=False)
- `suspension_reason` (TEXT, Nullable=True)
- `preferred_state_id` (INTEGER, FK -> `india_states.id`, Nullable=True)
- `created_at` (DATETIME, Default=UTC_NOW)
- `updated_at` (DATETIME, Default=UTC_NOW, OnUpdate=UTC_NOW)
- `last_login_at` (DATETIME, Nullable=True)

#### `Role` (Table: `roles`)
System permission manager.
- `id` (INTEGER, PK)
- `name` (VARCHAR(50), Unique, Nullable=False): `super_admin`, `admin`, `moderator`, `researcher`, `user`.
- `description` (VARCHAR(200))
- `permissions` (JSON, Nullable=False): Dict specifying resource permissions (e.g., `{"users": ["read", "write"]}`).

### 2.2 Species Catalog
#### `Species` (Table: `species`)
Represents the butterfly taxonomy catalog.
- `id` (VARCHAR(36), PK): UUID.
- `common_name` (VARCHAR(200), Nullable=False)
- `scientific_name` (VARCHAR(200), Unique, Indexed, Nullable=False): Genus + species.
- `family` (VARCHAR(100), Indexed, Nullable=False)
- `genus` (VARCHAR(100), Nullable=False)
- `description` (TEXT, Nullable=True)
- `habitat` (TEXT, Nullable=True)
- `seasonal_appearance` (JSON): Array of integer months when spotted (e.g., `[6, 7, 8]` for Jun-Aug).
- `conservation_status` (VARCHAR(5), Default='LC'): One of `LC`, `NT`, `VU`, `EN`, `CR`, `EW`, `EX`.
- `wing_span_min_mm` (INTEGER, Nullable=True)
- `wing_span_max_mm` (INTEGER, Nullable=True)
- `is_migratory` (BOOLEAN, Default=False)
- `color_tags` (JSON): Array of dominant colors (e.g., `["black", "yellow"]`).
- `slug` (VARCHAR(250), Unique, Indexed, Nullable=False)
- `is_active` (BOOLEAN, Default=True)

#### `SpeciesImage` (Table: `species_images`)
- `id` (VARCHAR(36), PK)
- `species_id` (VARCHAR(36), FK -> `species.id`)
- `image_url` (VARCHAR(500), Nullable=False)
- `thumbnail_url` (VARCHAR(500))
- `image_type` (VARCHAR(30), Default='reference'): `reference`, `male`, `female`, `caterpillar`, `pupa`, `egg`.
- `is_primary` (BOOLEAN, Default=False)
- `credit` (VARCHAR(300))

#### `SpeciesHostPlant` (Table: `species_host_plants`)
- `id` (INTEGER, PK)
- `species_id` (VARCHAR(36), FK -> `species.id`)
- `plant_name` (VARCHAR(200), Nullable=False)
- `plant_scientific_name` (VARCHAR(200))

#### `SpeciesIndiaDistribution` (Table: `species_india_distribution`)
- `id` (INTEGER, PK)
- `species_id` (VARCHAR(36), FK -> `species.id`)
- `state_id` (INTEGER, FK -> `india_states.id`)
- `abundance` (VARCHAR(20), Default='common'): `common`, `uncommon`, `rare`, `very_rare`.

### 2.3 Observations
#### `Observation` (Table: `observations`)
Sightings submitted by users.
- `id` (VARCHAR(36), PK)
- `user_id` (VARCHAR(36), FK -> `users.id`, Nullable=False)
- `species_id` (VARCHAR(36), FK -> `species.id`, Nullable=True): Populated after identification/moderation.
- `title` (VARCHAR(300))
- `notes` (TEXT)
- `weather` (VARCHAR(30)): `sunny`, `cloudy`, `rainy`, `windy`, `partly_cloudy`, `overcast`.
- `butterfly_activity` (VARCHAR(30)): `feeding`, `resting`, `mating`, `flying`, `ovipositing`, `puddling`, `basking`.
- `count_observed` (INTEGER, Default=1)
- `observed_at` (DATETIME, Default=UTC_NOW)
- `state_id` (INTEGER, FK -> `india_states.id`, Nullable=False)
- `district_id` (INTEGER, FK -> `india_districts.id`)
- `latitude` (FLOAT, Nullable=False): Geobounded to India: [8.0, 37.5].
- `longitude` (FLOAT, Nullable=False): Geobounded to India: [68.0, 97.5].
- `location_name` (VARCHAR(500)): Free-text description of location.
- `privacy` (VARCHAR(20), Default='public'): `public`, `anonymous_public`, `private`.
- `verification_status` (VARCHAR(30), Default='pending'): `pending`, `ai_identified`, `expert_verified`, `community_verified`, `rejected`.
- `verified_by` (VARCHAR(36), FK -> `users.id`)
- `verified_at` (DATETIME)
- `admin_notes` (TEXT)
- `is_active` (BOOLEAN, Default=True)

#### `ObservationImage` (Table: `observation_images`)
- `id` (VARCHAR(36), PK)
- `observation_id` (VARCHAR(36), FK -> `observations.id`)
- `original_url` (VARCHAR(500), Nullable=False)
- `optimized_url` (VARCHAR(500))
- `thumbnail_url` (VARCHAR(500))
- `is_primary` (BOOLEAN, Default=False)
- `file_size_bytes` (INTEGER)
- `width` (INTEGER)
- `height` (INTEGER)

#### `PublicShare` (Table: `public_shares`)
- `id` (VARCHAR(36), PK)
- `observation_id` (VARCHAR(36), FK -> `observations.id`, Unique)
- `share_token` (VARCHAR(64), Unique, Indexed)
- `is_active` (BOOLEAN, Default=True)
- `view_count` (INTEGER, Default=0)

### 2.4 AI Identification Results
#### `IdentificationResult` (Table: `identification_results`)
- `id` (VARCHAR(36), PK)
- `observation_id` (VARCHAR(36), FK -> `observations.id`, Unique)
- `user_id` (VARCHAR(36), FK -> `users.id`)
- `status` (VARCHAR(20), Default='pending'): `pending`, `processing`, `completed`, `failed`.
- `raw_gemini_response` (JSON)
- `gemini_raw_text` (TEXT)
- `processing_time_ms` (INTEGER)
- `gemini_model_version` (VARCHAR(50))
- `error_message` (TEXT)
- `created_at` (DATETIME, Default=UTC_NOW)
- `completed_at` (DATETIME)

#### `IdentificationMatch` (Table: `identification_matches`)
Matches returned by Gemini, mapped to database species if resolved.
- `id` (INTEGER, PK)
- `identification_result_id` (VARCHAR(36), FK -> `identification_results.id`)
- `species_id` (VARCHAR(36), FK -> `species.id`, Nullable=True)
- `matched_common_name` (VARCHAR(200))
- `matched_scientific_name` (VARCHAR(200))
- `confidence_score` (FLOAT, Default=0.0): Range 0.0 - 1.0.
- `rank` (INTEGER, Default=1): 1 = primary, 2 = secondary, etc.
- `is_accepted` (BOOLEAN, Default=False): Flagged when admin overrides/verifies.
- `admin_notes` (TEXT)

### 2.5 Gamification & Notification Preferences
#### `UserStreak` (Table: `user_streaks`)
- `current_streak` (INTEGER, Default=0)
- `longest_streak` (INTEGER, Default=0)
- `last_observation_date` (DATE)

#### `UserStats` (Table: `user_stats`)
- `total_observations` (INTEGER, Default=0)
- `total_identifications` (INTEGER, Default=0)
- `total_species_observed` (INTEGER, Default=0)
- `total_states_explored` (INTEGER, Default=0)
- `total_points` (INTEGER, Default=0)

#### `UserAchievement` (Table: `user_achievements`)
- `user_id` (VARCHAR(36), FK -> `users.id`)
- `achievement_id` (INTEGER, FK -> `achievement_definitions.id`)
- `earned_at` (DATETIME, Default=UTC_NOW)

#### `AchievementDefinition` (Table: `achievement_definitions`)
- `name` (VARCHAR(100), Unique)
- `description` (VARCHAR(400))
- `badge_image_url` (VARCHAR(500))
- `achievement_type` (VARCHAR(50), Unique): `first_observation`, `streak_7`, `streak_30`, `streak_100`, `species_10`, `species_50`, `species_100`, `state_explorer`, `rare_finder`, `verified_10`, `top_contributor`.
- `threshold_value` (INTEGER, Default=1)
- `points` (INTEGER, Default=10)

#### `NotificationPreference` (Table: `notification_preferences`)
- `user_id` (VARCHAR(36), FK -> `users.id`, Unique)
- `identification_complete` (BOOLEAN, Default=True)
- `new_species_nearby` (BOOLEAN, Default=True)
- `admin_verification` (BOOLEAN, Default=True)
- `educational_alerts` (BOOLEAN, Default=True)
- `events` (BOOLEAN, Default=True)
- `fcm_token` (VARCHAR(500))

#### `Notification` (Table: `notifications`)
In-app notification log.
- `id` (VARCHAR(36), PK)
- `user_id` (VARCHAR(36), FK -> `users.id`)
- `type` (VARCHAR(40)): `identification_complete`, `new_species_nearby`, `admin_verification`, `educational_alert`, `event`, `system`.
- `title` (VARCHAR(300))
- `body` (TEXT)
- `data` (JSON): Arbitrary payload (e.g., `{"observation_id": "..."}`).
- `is_read` (BOOLEAN, Default=False)
- `created_at` (DATETIME, Default=UTC_NOW)

### 2.6 Geography Reference
#### `IndiaState` (Table: `india_states`)
- `id` (INTEGER, PK)
- `name` (VARCHAR(100), Unique): e.g., "Maharashtra"
- `code` (VARCHAR(5), Unique): e.g., "MH"
- `region` (VARCHAR(20)): `North`, `South`, `East`, `West`, `Northeast`, `Central`
- `is_union_territory` (BOOLEAN, Default=False)

#### `IndiaDistrict` (Table: `india_districts`)
- `id` (INTEGER, PK)
- `name` (VARCHAR(100))
- `state_id` (INTEGER, FK -> `india_states.id`)
- `latitude` (FLOAT)
- `longitude` (FLOAT)

---

## 3. REST API Specifications

### 3.1 Standard Response Envelopes

#### Success Envelope
```json
{
  "success": true,
  "message": "Action completed successfully.",
  "data": {} 
}
```

#### Error Envelope
```json
{
  "success": false,
  "message": "Detailed error summary.",
  "errors": {
    "field_name": ["Validation constraint violation details."]
  }
}
```

#### Paginated Envelope
```json
{
  "success": true,
  "data": [],
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 145,
    "total_pages": 8,
    "has_next": true,
    "has_prev": false
  }
}
```

---

### 3.2 Endpoint Registry

#### Authentication Blueprint (`/api/v1/auth`)

| Method | Endpoint | Auth | Description | Payload Schema | Response `data` Shape |
|:---|:---|:---|:---|:---|:---|
| `POST` | `/register` | None | Register new user. Rate limit: 10/hr | `{"email", "password", "full_name", "username", "preferred_state_id"}` | Returns `User` dictionary with `email` and `is_active` |
| `POST` | `/login` | None | Login user. Rate limit: 20/hr | `{"email", "password"}` | `{"access_token", "refresh_token", "user": {User}}` |
| `POST` | `/refresh` | JWT Refresh | Exchange refresh token for access token | None | `{"access_token"}` |
| `GET` | `/me` | JWT Access | Get logged-in user profile details | None | `{User}` details including email, suspension status |
| `POST` | `/change-password` | JWT Access | Change user password. Rate limit: 5/hr | `{"current_password", "new_password"}` | `{}`. Response message: "Password changed successfully." |
| `POST` | `/logout` | JWT Access | Log out user (client invalidates token) | None | `{}`. Response message: "Logged out successfully." |

#### Users Blueprint (`/api/v1/users`)

| Method | Endpoint | Auth | Description | Payload Schema | Response `data` Shape |
|:---|:---|:---|:---|:---|:---|
| `GET` | `/me` | JWT Access | Get profile dashboard details | None | `{User}` |
| `PUT` | `/me` | JWT Access | Update profile details | `{"full_name", "username", "bio", "preferred_state_id"}` | `{User}` |
| `POST` | `/me/avatar` | JWT Access | Upload avatar. Rate limit: 10/hr | Form data: `image` (File) | `{"profile_image_url"}` updated |
| `POST` | `/me/fcm-token` | JWT Access | Register firebase messaging token | `{"fcm_token"}` | `{}`. Response message: "FCM token registered." |
| `GET` | `/me/stats` | JWT Access | Get gamification stats | None | `{"total_observations", "total_identifications", "total_species_observed", "total_states_explored", "total_points"}` |
| `GET` | `/me/achievements` | JWT Access | List unlocked achievements | None | `[{"id", "earned_at", "achievement": {"id", "name", "description", "badge_image_url", "achievement_type", "points"}}]` |
| `GET` | `/<username>` | JWT Access | Get profile metadata of another user | None | Public `{User}` (excludes private fields like email) |

#### Species Blueprint (`/api/v1/species`)

| Method | Endpoint | Auth | Description | Query Parameters | Response `data` Shape |
|:---|:---|:---|:---|:---|:---|
| `GET` | `/` | None | Paginated list of species | `page`, `per_page`, `family`, `conservation_status`, `state_id`, `color`, `search`, `is_migratory` | Paginated array of `{Species}` |
| `GET` | `/<slug_or_id>` | None | Get specific species detail | None | `{Species}` with nested list of `host_plants`, `distribution_states`, and `primary_image` |

#### Geography Blueprint (`/api/v1/geography`)

| Method | Endpoint | Auth | Description | Response `data` Shape |
|:---|:---|:---|:---|:---|
| `GET` | `/states` | None | List all states of India | `[{"id", "name", "code", "region", "is_union_territory"}]` |
| `GET` | `/states/<state_id>/districts` | None | List all districts of a state | `[{"id", "name", "state_id", "latitude", "longitude"}]` |

#### Observations Blueprint (`/api/v1/observations`)

| Method | Endpoint | Auth | Description | Payload / Query Schema | Response `data` Shape |
|:---|:---|:---|:---|:---|:---|
| `GET` | `/feed` | None | Paginated public feed | Query: `page`, `per_page`, `state_id`, `species_id`, `verification_status` | Paginated array of public `{Observation}` |
| `GET` | `/shared/<token>` | None | Get observation details via shared token | None | `{Observation}` details |
| `POST` | `/` | JWT Access | Log an observation. Rate limit: 100/day | Body: `{"title", "notes", "weather", "butterfly_activity", "count_observed", "observed_at", "state_id", "district_id", "latitude", "longitude", "location_name", "privacy"}` | `{Observation}` object |
| `GET` | `/` | JWT Access | Get my observations (paginated) | Query: `page`, `per_page`, `state_id`, `species_id`, `verification_status` | Paginated array of my `{Observation}` |
| `GET` | `/user/<user_id>` | JWT Access | List observations of other user | Query: `page`, `per_page`, `state_id`, `species_id` | Paginated array of their public `{Observation}` |
| `GET` | `/<obs_id>` | JWT Access | Get single observation details | None | `{Observation}` details with nested `images` |
| `PUT` | `/<obs_id>` | JWT Access | Update observation details | Body: `{"title", "notes", "weather", "butterfly_activity", "count_observed", "observed_at", "state_id", "district_id", "latitude", "longitude", "location_name", "privacy"}` | Updated `{Observation}` |
| `DELETE` | `/<obs_id>` | JWT Access | Soft delete observation | None | `{}`. Response message: "Observation deleted." |
| `PATCH` | `/<obs_id>/privacy` | JWT Access | Toggle visibility | Body: `{"privacy"}` (`public`, `anonymous_public`, `private`) | Updated `{Observation}` |
| `POST` | `/<obs_id>/share` | JWT Access | Generate share link | None | `{"id", "share_token", "view_count", "created_at"}` |
| `POST` | `/<obs_id>/images` | JWT Access | Add image to observation. Limit: 50/hr | Form data: `image` (File) | `{"id", "original_url", "optimized_url", "thumbnail_url", "is_primary", "width", "height"}` |
| `DELETE` | `/<obs_id>/images/<image_id>` | JWT Access | Remove image | None | `{}`. Response message: "Image removed." |

#### Identifications Blueprint (`/api/v1/identifications`)

| Method | Endpoint | Auth | Description | Payload Schema | Response `data` Shape |
|:---|:---|:---|:---|:---|:---|
| `POST` | `/observations/<obs_id>/identify` | JWT Access | Trigger synchronous Gemini identification (5-15s response time). Limit: 30/hr | None | `{IdentificationResult}` with nested list of `matches` sorted by rank |
| `GET` | `/observations/<obs_id>/result` | JWT Access | Fetch existing AI identification results | None | `{IdentificationResult}` with nested `matches` |
| `POST` | `/results/<result_id>/matches/<int:match_id>/accept` | Moderator | Override AI result. Mark match as correct, update observation's verification status to `expert_verified` | Body: `{"admin_notes"}` | Updated `{IdentificationMatch}` |

#### Notifications Blueprint (`/api/v1/notifications`)

| Method | Endpoint | Auth | Description | Payload Schema | Response `data` Shape |
|:---|:---|:---|:---|:---|:---|
| `GET` | `/` | JWT Access | List notifications (paginated) | Query: `page`, `per_page` | Paginated array of `{Notification}`. Inserts `unread_count` inside `meta` |
| `PATCH` | `/<notif_id>/read` | JWT Access | Mark notification as read | None | `{Notification}` (updated `is_read = true`) |
| `POST` | `/read-all` | JWT Access | Mark all notifications read | None | `{}`. Response message: "X notifications marked as read." |
| `GET` | `/preferences` | JWT Access | Get notification preferences | None | `{"identification_complete", "new_species_nearby", "admin_verification", "educational_alerts", "events"}` |
| `PUT` | `/preferences` | JWT Access | Update preferences | Body: Prefs JSON | Updated Preferences dictionary |

#### CMS Content Blueprint (`/api/v1/cms`)

| Method | Endpoint | Auth | Description | Query Parameters | Response `data` Shape |
|:---|:---|:---|:---|:---|:---|
| `GET` | `/articles` | None | Paginated published article feed | `page`, `per_page`, `type` (`educational`, `facts`, `news`, `events`) | Paginated array of `{CmsArticle}` (content excluded) |
| `GET` | `/articles/<slug>` | None | Read single CMS article detail | None | `{CmsArticle}` with full content string |
| `GET` | `/banners` | None | Fetch banners for promotion sliders | `placement` (`app_home`, `app_species`, `portal_home`) | `[{"id", "title", "image_url", "link_url", "placement", "is_active", "display_order"}]` |

---

## 4. Gemini Vision AI Sighting Flow

The system runs a robust, synchronous visual identification pipeline powered by the **Gemini 1.5 Flash** model.

### 4.1 AI Sighting Workflow
1. User creates an observation and uploads up to 3 images.
2. User taps "Identify" on the observation screen.
3. Client issues `POST /api/v1/identifications/observations/<obs_id>/identify`.
4. Backend checks for images linked to the observation. It reads the image bytes (downloading them from the CDN or fetching them from local storage).
5. The backend initializes `google.generativeai` SDK, configured with a low temperature of `0.1` and `response_mime_type: "application/json"`.
6. Images and a structured lepidopterist prompt are sent to Gemini.
7. Gemini returns structured JSON containing matching candidate species details.
8. The backend maps matches to species records in the database.
9. Matches are saved in the `identification_matches` table, and the observation's `verification_status` is updated to `ai_identified`.

```
[Flutter Client] ──────( POST /identify )──────> [Flask Backend]
                                                       │
                                            (Read Observation Images)
                                                       │
                                                       ▼
[Generative AI] <──(Images + JSON prompt)── [Gemini Service]
       │
 (JSON Output)
       │
       ▼
 [Flask Backend] ──(Normalize Confidence)
       │
       ├─(Search Species DB via difflib SequenceMatcher >= 0.75)
       │
       ├─(Store IdentificationResult & Match Candidates)
       │
       ▼
[Flutter Client] <───(200 OK + Matches)───────── [Flask Backend]
```

### 4.2 Prompt Configuration
The prompt forces Gemini to respond strictly in JSON without Markdown code fences, ensuring easy parsing:
```json
{
  "is_butterfly": true,
  "identified": true,
  "image_quality": "good",
  "matches": [
    {
      "common_name": "Blue Mormon",
      "scientific_name": "Papilio polymnestor",
      "confidence": 0.92,
      "reasoning": "Large Papilionid with brilliant blue iridescent scaling...",
      "visible_features": ["iridescent blue hindwing patches", "black body"]
    }
  ],
  "notes": "Dorsal view, wings spread..."
}
```

### 4.3 Database Resolution Algorithm
Because Gemini might return slightly different spelling variations, taxonomic revisions, or species not yet registered in the app's catalog, the backend uses a fuzzy database resolution sequence:
1. **Exact Match**: Checks if the returned scientific name matches a species in the database (case-insensitive).
2. **Scientific Name Fuzzy Match**: Uses `difflib.SequenceMatcher` to compare the scientific name against all active species records. If the similarity score is $\ge 0.85$, it registers a match.
3. **Genus-Level Fallback**: If the specific epithet fails but the genus is identified, the backend matches it to species within that genus if the similarity score is $\ge 0.75$.
4. **Common Name Fuzzy Match**: Compares common names using `SequenceMatcher`. If the similarity ratio is $\ge 0.80$ or if one name is fully contained in another, it links the records.
5. **No Match**: If similarity falls below `0.75`, the match is recorded without a `species_id` reference (displayed in UI as an unregistered species match).

---

## 5. Flutter App Specifications & Roadmap

Use this design plan when prompting an AI code generator to write the Flutter client.

### 5.1 Technology Stack Recommendations
- **State Management**: `flutter_bloc` (robust, clean event-state separation) or `flutter_riverpod` (easy caching and dependency injection).
- **Networking**: `dio` (excellent support for interceptors, request cancelation, base configs, and file upload progress bars).
- **Serialization**: `freezed` + `json_serializable` (creates type-safe models for all JSON payloads described above).
- **Local Storage / Caching**: `isar` or `hive` (high-performance local databases for caching species lists, storing offline sightings, and keeping user session tokens).
- **Navigation**: `go_router` (declares nested shell routes for tab bars and handles deep-links for shared observation tokens).
- **Location & Maps**: `geolocator` (coordinate logging) and `google_maps_flutter` (renders observations on maps).

### 5.2 Mobile Client Challenges & Solutions

#### Offline Logging Queue
*Challenge*: Users often spot butterflies in national parks or remote areas with poor network coverage.  
*Solution*: 
- Implement an offline queue. When there is no internet connection, store the observation details locally in Isar/Hive.
- Save photo paths locally.
- Use the `connectivity_plus` package to monitor network state. When connection is restored, prompt the user to upload queued sightings.

#### Token Lifecycle Interceptor
*Challenge*: The client must manage refreshing access tokens silently to ensure a seamless user experience.  
*Solution*: Add a custom Dio Interceptor to handle token refresh requests:
```dart
class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorage storage;

  AuthInterceptor(this.dio, this.storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await storage.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Access token expired, attempt silent refresh
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken != null) {
        try {
          final response = await dio.post('/auth/refresh', 
            options: Options(headers: {'Authorization': 'Bearer $refreshToken'})
          );
          final newAccessToken = response.data['data']['access_token'];
          await storage.saveAccessToken(newAccessToken);
          
          // Re-try original request with the new token
          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final clone = await dio.fetch(err.requestOptions);
          return handler.resolve(clone);
        } catch (e) {
          // Refresh token expired or invalid, log user out
          await storage.clearTokens();
          // Navigate to login screen
        }
      }
    }
    handler.next(err);
  }
}
```

#### Map Coordinate Bounding
*Challenge*: The backend enforces strict boundaries for geographical entries, requiring them to fall within India's borders.  
*Solution*: In the Flutter map screen, restrict geocoding and map picks using bounds enforcement:
- Latitude Range: `8.0` to `37.5`
- Longitude Range: `68.0` to `97.5`
- Implement an on-map marker placement listener that displays a warning if the pointer is dragged outside this bounding box, preventing API validation failures.

#### Image Pre-processing
*Challenge*: High-resolution camera images cause slow uploads and API timeouts.  
*Solution*: Compress image files on-device using `flutter_image_compress` before uploading. Limit images to a maximum width/height of `1080px` at `85%` quality.

---

## 6. Development & Deployment Context

### 6.1 Configuration Keys (`backend/.env`)
For the Flutter app to interface correctly with the local backend during development, configure the backend environment:
- `SECRET_KEY`: Used for sessions.
- `DATABASE_URL`: PostgreSQL connection string (defaults to `postgresql://postgres:postgres@localhost:5432/butterfly_db`).
- `JWT_SECRET_KEY`: Decrypts user access tokens.
- `BUNNY_STORAGE_API_KEY`, `BUNNY_STORAGE_ZONE`, `BUNNY_CDN_URL`: Bunny CDN integrations. Leaving these blank enables local dev storage under the `/uploads/` route.
- `GEMINI_API_KEY`: Required for visual species identification.
- `FIREBASE_SERVER_KEY`: Required for sending push notifications.

### 6.2 Running the Backend Locally
1. Install dependencies: `pip install -r requirements.txt`
2. Run database migrations: `python manage.py db upgrade`
3. Seed default data: `python manage.py seed-all` (Seeds roles, achievements, geography, and 50 butterfly species).
4. Start the server: `python manage.py run` (Runs Flask on `http://127.0.0.1:5000`).
