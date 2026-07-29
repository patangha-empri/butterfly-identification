import 'package:freezed_annotation/freezed_annotation.dart';
import 'observation_summary.dart';
import 'species_summary.dart';

part 'home_feed.freezed.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// HOME FEED
/// Aggregate of all discovery sections rendered on the home dashboard.
/// Assembled client-side from several endpoints (parallel fetch).
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
class HomeFeed with _$HomeFeed {
  const factory HomeFeed({
    @Default([]) List<SpeciesSummary> trending,
    @Default([]) List<SpeciesSummary> seasonal,
    @Default([]) List<SpeciesSummary> featured,
    @Default([]) List<ObservationSummary> nearby,
    @Default([]) List<ObservationSummary> recent,
    @Default(false) bool fromCache,
  }) = _HomeFeed;

  const HomeFeed._();

  bool get isEmpty =>
      trending.isEmpty &&
      seasonal.isEmpty &&
      featured.isEmpty &&
      nearby.isEmpty &&
      recent.isEmpty;
}
