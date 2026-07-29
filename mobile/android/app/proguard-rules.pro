# ─────────────────────────────────────────────────────────────────────────────
# ProGuard / R8 rules for release builds.
# The Flutter Gradle plugin already ships sensible defaults; these add keeps for
# libraries that rely on reflection or generated code, and silence benign
# missing-class warnings from optional plugin dependencies.
# ─────────────────────────────────────────────────────────────────────────────

# Flutter engine + embedding
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Firebase (firebase_core / firebase_messaging are declared dependencies)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Play Core (used by Flutter's deferred-components stubs; safe to ignore)
-dontwarn com.google.android.play.core.**

# Keep annotations and generic signatures used by JSON / reflection-based libs
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod

# Drift / SQLite (sqlite3 native bindings)
-keep class org.sqlite.** { *; }
-dontwarn org.sqlite.**

# Kotlin coroutines / metadata
-dontwarn kotlinx.**
-keep class kotlin.Metadata { *; }
