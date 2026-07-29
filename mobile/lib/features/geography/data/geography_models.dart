import 'package:freezed_annotation/freezed_annotation.dart';

part 'geography_models.freezed.dart';
part 'geography_models.g.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// GEOGRAPHY MODELS — India states + districts
/// Matches GET /geography/states and /geography/states/<id>/districts.
/// ─────────────────────────────────────────────────────────────────────────────

@freezed
class IndiaState with _$IndiaState {
  const factory IndiaState({
    required int id,
    required String name,
    String? code,
    String? region,
    @JsonKey(name: 'is_union_territory') @Default(false) bool isUnionTerritory,
  }) = _IndiaState;

  factory IndiaState.fromJson(Map<String, dynamic> json) =>
      _$IndiaStateFromJson(json);
}

@freezed
class IndiaDistrict with _$IndiaDistrict {
  const factory IndiaDistrict({
    required int id,
    required String name,
    @JsonKey(name: 'state_id') int? stateId,
    double? latitude,
    double? longitude,
  }) = _IndiaDistrict;

  factory IndiaDistrict.fromJson(Map<String, dynamic> json) =>
      _$IndiaDistrictFromJson(json);
}
