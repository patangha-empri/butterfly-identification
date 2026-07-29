import 'dart:io';
import 'observation.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// OBSERVATION DRAFT
/// Local, mutable form state for creating a sighting. Holds picked image files
/// (not yet uploaded) and serializes to the backend create payload.
/// ─────────────────────────────────────────────────────────────────────────────

class ObservationDraft {
  ObservationDraft({
    this.title,
    this.notes,
    this.stateId,
    this.districtId,
    this.latitude,
    this.longitude,
    this.locationName,
    this.weather,
    this.activity,
    this.countObserved = 1,
    this.observedAt,
    this.privacy = ObservationPrivacy.public,
    List<File>? images,
    this.primaryIndex = 0,
  }) : images = images ?? [];

  String? title;
  String? notes;
  int? stateId;
  int? districtId;
  double? latitude;
  double? longitude;
  String? locationName;
  Weather? weather;
  ButterflyActivity? activity;
  int countObserved;
  DateTime? observedAt;
  ObservationPrivacy privacy;
  List<File> images;
  int primaryIndex;

  bool get isValid => stateId != null;

  /// Body for POST /observations/ (snake_case, omitting null/empty fields).
  Map<String, dynamic> toCreateJson() => {
        if (title != null && title!.trim().isNotEmpty) 'title': title!.trim(),
        if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
        if (stateId != null) 'state_id': stateId,
        if (districtId != null) 'district_id': districtId,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (locationName != null && locationName!.trim().isNotEmpty)
          'location_name': locationName!.trim(),
        if (weather != null) 'weather': weather!.value,
        if (activity != null) 'butterfly_activity': activity!.value,
        'count_observed': countObserved,
        if (observedAt != null) 'observed_at': observedAt!.toUtc().toIso8601String(),
        'privacy': privacy.value,
      };
}
