# Google Maps — setup, key restrictions, and keeping the bill near zero

The map tab renders public sightings with the **Maps SDK for Android / iOS**.
Everything else Google sells — Directions, Places, Geocoding, Static Maps, the
JavaScript API — is deliberately unused. See "Cost model" below.

---

## 1. Where the keys live

Keys ship inside the app binary (that is how the mobile SDKs work — there is no
way to hide them), but they are kept **out of git** so the repository itself
never publishes them.

| Platform | File | Committed? |
|---|---|---|
| Android | `android/maps.properties` | No — git-ignored |
| Android | `android/maps.properties.example` | Yes, template |
| iOS | `ios/Flutter/Secrets.xcconfig` | No — git-ignored |
| iOS | `ios/Flutter/Secrets.xcconfig.example` | Yes, template |

On a fresh clone:

```bash
cp android/maps.properties.example android/maps.properties
cp ios/Flutter/Secrets.xcconfig.example ios/Flutter/Secrets.xcconfig
# then paste each key into MAPS_API_KEY=
```

Android reads it in `android/app/build.gradle.kts` and injects it into the
manifest placeholder `${MAPS_API_KEY}`; `MAPS_API_KEY` from the environment also
works, which is what CI should use. iOS passes it through `Info.plist`
(`MapsApiKey`) to `AppDelegate.swift`.

**A missing key is not a build error.** The app builds and the map renders grey.
That is intentional — a new machine should be able to build the project before
anyone hands over credentials.

---

## 2. Restrict the keys (do this before shipping)

An unrestricted key lifted out of an APK can be used by anyone, on your bill.
In Google Cloud Console → *APIs & Services → Credentials*:

**Android key**
- Application restriction: **Android apps**
- Package name: `com.thardeye.butterfly_india`
- SHA-1: add **both** the debug certificate and the upload/release certificate
  ```bash
  keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android
  ```
- API restriction: **Maps SDK for Android** only

**iOS key**
- Application restriction: **iOS apps**
- Bundle ID: the Runner target's identifier
- API restriction: **Maps SDK for iOS** only

Two separate keys, one per platform, so a leak on one side can be rotated
without shipping a new build on the other.

---

## 3. Cost model

What this app does and does not call:

| Google product | Used here | Why |
|---|---|---|
| Maps SDK for Android / iOS | **Yes** | Draws the map. Panning and zooming afterwards is client-side. |
| Directions API | No | "Navigate here" opens the installed Google Maps app via a URL (`google.navigation:` / `comgooglemaps://`, web as last resort). Handing off costs nothing; drawing our own route would be a billed request per tap. |
| Places API | No | No search-by-place anywhere. Species and sightings are searched against our own backend. |
| Geocoding API | No | Coordinates come from the device GPS and from our database. Sightings with no GPS fall back to a state centroid computed on-device (`map_providers.dart`). |
| Static Maps / Embed / JS API | No | No map images in the admin panel, the portal, or notifications. |

Sightings are fetched **once per filter change** from our own API and clustered
on-device (`map_clusterer.dart`), so scrolling the map generates no traffic to
Google or to us.

**Before launch:** in Cloud Console set a **budget alert** on the project and,
per key, a **daily quota cap** on the Maps SDK. A cap is the only thing that
turns a runaway loop or a leaked key into a broken map instead of an invoice.
Google's pricing tiers change periodically — check the current rates and free
allowance for the Maps SDK on your billing page rather than trusting a number
written here.

---

## 4. Performance choices worth keeping

These are in `map_screen.dart` and matter most on cheap Android hardware:

- Markers are re-clustered only when zoom moves by ≥ 0.5, not on every frame of
  a pinch.
- Cluster bitmaps are painted once and cached, with counts bucketed
  (`1`…`9` exact, then `10+`, `25+`, `50+`, `100+`, `500+`) — fourteen images
  cover any number of sightings.
- Buildings, indoor, traffic, tilt and rotation are off; they cost frames and
  add nothing to a sightings map.
- The blue "my location" dot is enabled only when the user taps the locate
  button, so opening the map never triggers a GPS permission prompt.
- The camera is bounded to India (5–37.5° N, 66–98° E) and zoom to 3–17.
