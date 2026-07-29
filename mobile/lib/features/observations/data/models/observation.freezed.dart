// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'observation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Observation _$ObservationFromJson(Map<String, dynamic> json) {
  return _Observation.fromJson(json);
}

/// @nodoc
mixin _$Observation {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String? get userName => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_avatar_url')
  String? get userAvatarUrl => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get weather => throw _privateConstructorUsedError;
  @JsonKey(name: 'butterfly_activity')
  String? get butterflyActivity => throw _privateConstructorUsedError;
  @JsonKey(name: 'count_observed')
  int get countObserved => throw _privateConstructorUsedError;
  @JsonKey(name: 'state_id')
  int? get stateId => throw _privateConstructorUsedError;
  @JsonKey(name: 'state_name')
  String? get stateName => throw _privateConstructorUsedError;
  @JsonKey(name: 'district_id')
  int? get districtId => throw _privateConstructorUsedError;
  @JsonKey(name: 'district_name')
  String? get districtName => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_name')
  String? get locationName => throw _privateConstructorUsedError;
  String get privacy => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'verification_status')
  String? get verificationStatus =>
      throw _privateConstructorUsedError; // Moderation note (e.g. rejection reason) — only present for owner/staff.
  @JsonKey(name: 'admin_notes')
  String? get adminNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'identification_status')
  String? get identificationStatus => throw _privateConstructorUsedError;
  @JsonKey(name: 'identified_species_id')
  String? get identifiedSpeciesId => throw _privateConstructorUsedError;
  @JsonKey(name: 'identified_species_name')
  String? get identifiedSpeciesName => throw _privateConstructorUsedError;
  @JsonKey(name: 'identification_confidence')
  double? get identificationConfidence => throw _privateConstructorUsedError;
  @JsonKey(name: 'identification_reasoning')
  String? get identificationReasoning => throw _privateConstructorUsedError;
  @JsonKey(name: 'raw_gemini_response')
  Map<String, dynamic>? get rawGeminiResponse =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'primary_image_url')
  String? get primaryImageUrl => throw _privateConstructorUsedError;
  List<ObservationImage> get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'like_count')
  int get likeCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'comment_count')
  int get commentCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_liked')
  bool get isLiked => throw _privateConstructorUsedError;
  @JsonKey(name: 'observed_at')
  DateTime? get observedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'user_id') String? userId,
            @JsonKey(name: 'user_name') String? userName,
            @JsonKey(name: 'user_avatar_url') String? userAvatarUrl,
            String? title,
            String? notes,
            String? weather,
            @JsonKey(name: 'butterfly_activity') String? butterflyActivity,
            @JsonKey(name: 'count_observed') int countObserved,
            @JsonKey(name: 'state_id') int? stateId,
            @JsonKey(name: 'state_name') String? stateName,
            @JsonKey(name: 'district_id') int? districtId,
            @JsonKey(name: 'district_name') String? districtName,
            double? latitude,
            double? longitude,
            @JsonKey(name: 'location_name') String? locationName,
            String privacy,
            String status,
            @JsonKey(name: 'verification_status') String? verificationStatus,
            @JsonKey(name: 'admin_notes') String? adminNotes,
            @JsonKey(name: 'identification_status')
            String? identificationStatus,
            @JsonKey(name: 'identified_species_id') String? identifiedSpeciesId,
            @JsonKey(name: 'identified_species_name')
            String? identifiedSpeciesName,
            @JsonKey(name: 'identification_confidence')
            double? identificationConfidence,
            @JsonKey(name: 'identification_reasoning')
            String? identificationReasoning,
            @JsonKey(name: 'raw_gemini_response')
            Map<String, dynamic>? rawGeminiResponse,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            List<ObservationImage> images,
            @JsonKey(name: 'like_count') int likeCount,
            @JsonKey(name: 'comment_count') int commentCount,
            @JsonKey(name: 'is_liked') bool isLiked,
            @JsonKey(name: 'observed_at') DateTime? observedAt,
            @JsonKey(name: 'created_at') DateTime? createdAt)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            @JsonKey(name: 'user_id') String? userId,
            @JsonKey(name: 'user_name') String? userName,
            @JsonKey(name: 'user_avatar_url') String? userAvatarUrl,
            String? title,
            String? notes,
            String? weather,
            @JsonKey(name: 'butterfly_activity') String? butterflyActivity,
            @JsonKey(name: 'count_observed') int countObserved,
            @JsonKey(name: 'state_id') int? stateId,
            @JsonKey(name: 'state_name') String? stateName,
            @JsonKey(name: 'district_id') int? districtId,
            @JsonKey(name: 'district_name') String? districtName,
            double? latitude,
            double? longitude,
            @JsonKey(name: 'location_name') String? locationName,
            String privacy,
            String status,
            @JsonKey(name: 'verification_status') String? verificationStatus,
            @JsonKey(name: 'admin_notes') String? adminNotes,
            @JsonKey(name: 'identification_status')
            String? identificationStatus,
            @JsonKey(name: 'identified_species_id') String? identifiedSpeciesId,
            @JsonKey(name: 'identified_species_name')
            String? identifiedSpeciesName,
            @JsonKey(name: 'identification_confidence')
            double? identificationConfidence,
            @JsonKey(name: 'identification_reasoning')
            String? identificationReasoning,
            @JsonKey(name: 'raw_gemini_response')
            Map<String, dynamic>? rawGeminiResponse,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            List<ObservationImage> images,
            @JsonKey(name: 'like_count') int likeCount,
            @JsonKey(name: 'comment_count') int commentCount,
            @JsonKey(name: 'is_liked') bool isLiked,
            @JsonKey(name: 'observed_at') DateTime? observedAt,
            @JsonKey(name: 'created_at') DateTime? createdAt)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'user_id') String? userId,
            @JsonKey(name: 'user_name') String? userName,
            @JsonKey(name: 'user_avatar_url') String? userAvatarUrl,
            String? title,
            String? notes,
            String? weather,
            @JsonKey(name: 'butterfly_activity') String? butterflyActivity,
            @JsonKey(name: 'count_observed') int countObserved,
            @JsonKey(name: 'state_id') int? stateId,
            @JsonKey(name: 'state_name') String? stateName,
            @JsonKey(name: 'district_id') int? districtId,
            @JsonKey(name: 'district_name') String? districtName,
            double? latitude,
            double? longitude,
            @JsonKey(name: 'location_name') String? locationName,
            String privacy,
            String status,
            @JsonKey(name: 'verification_status') String? verificationStatus,
            @JsonKey(name: 'admin_notes') String? adminNotes,
            @JsonKey(name: 'identification_status')
            String? identificationStatus,
            @JsonKey(name: 'identified_species_id') String? identifiedSpeciesId,
            @JsonKey(name: 'identified_species_name')
            String? identifiedSpeciesName,
            @JsonKey(name: 'identification_confidence')
            double? identificationConfidence,
            @JsonKey(name: 'identification_reasoning')
            String? identificationReasoning,
            @JsonKey(name: 'raw_gemini_response')
            Map<String, dynamic>? rawGeminiResponse,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            List<ObservationImage> images,
            @JsonKey(name: 'like_count') int likeCount,
            @JsonKey(name: 'comment_count') int commentCount,
            @JsonKey(name: 'is_liked') bool isLiked,
            @JsonKey(name: 'observed_at') DateTime? observedAt,
            @JsonKey(name: 'created_at') DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Observation value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Observation value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Observation value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this Observation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Observation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ObservationCopyWith<Observation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ObservationCopyWith<$Res> {
  factory $ObservationCopyWith(
          Observation value, $Res Function(Observation) then) =
      _$ObservationCopyWithImpl<$Res, Observation>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'user_name') String? userName,
      @JsonKey(name: 'user_avatar_url') String? userAvatarUrl,
      String? title,
      String? notes,
      String? weather,
      @JsonKey(name: 'butterfly_activity') String? butterflyActivity,
      @JsonKey(name: 'count_observed') int countObserved,
      @JsonKey(name: 'state_id') int? stateId,
      @JsonKey(name: 'state_name') String? stateName,
      @JsonKey(name: 'district_id') int? districtId,
      @JsonKey(name: 'district_name') String? districtName,
      double? latitude,
      double? longitude,
      @JsonKey(name: 'location_name') String? locationName,
      String privacy,
      String status,
      @JsonKey(name: 'verification_status') String? verificationStatus,
      @JsonKey(name: 'admin_notes') String? adminNotes,
      @JsonKey(name: 'identification_status') String? identificationStatus,
      @JsonKey(name: 'identified_species_id') String? identifiedSpeciesId,
      @JsonKey(name: 'identified_species_name') String? identifiedSpeciesName,
      @JsonKey(name: 'identification_confidence')
      double? identificationConfidence,
      @JsonKey(name: 'identification_reasoning')
      String? identificationReasoning,
      @JsonKey(name: 'raw_gemini_response')
      Map<String, dynamic>? rawGeminiResponse,
      @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
      List<ObservationImage> images,
      @JsonKey(name: 'like_count') int likeCount,
      @JsonKey(name: 'comment_count') int commentCount,
      @JsonKey(name: 'is_liked') bool isLiked,
      @JsonKey(name: 'observed_at') DateTime? observedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$ObservationCopyWithImpl<$Res, $Val extends Observation>
    implements $ObservationCopyWith<$Res> {
  _$ObservationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Observation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? userAvatarUrl = freezed,
    Object? title = freezed,
    Object? notes = freezed,
    Object? weather = freezed,
    Object? butterflyActivity = freezed,
    Object? countObserved = null,
    Object? stateId = freezed,
    Object? stateName = freezed,
    Object? districtId = freezed,
    Object? districtName = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? locationName = freezed,
    Object? privacy = null,
    Object? status = null,
    Object? verificationStatus = freezed,
    Object? adminNotes = freezed,
    Object? identificationStatus = freezed,
    Object? identifiedSpeciesId = freezed,
    Object? identifiedSpeciesName = freezed,
    Object? identificationConfidence = freezed,
    Object? identificationReasoning = freezed,
    Object? rawGeminiResponse = freezed,
    Object? primaryImageUrl = freezed,
    Object? images = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? isLiked = null,
    Object? observedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatarUrl: freezed == userAvatarUrl
          ? _value.userAvatarUrl
          : userAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      weather: freezed == weather
          ? _value.weather
          : weather // ignore: cast_nullable_to_non_nullable
              as String?,
      butterflyActivity: freezed == butterflyActivity
          ? _value.butterflyActivity
          : butterflyActivity // ignore: cast_nullable_to_non_nullable
              as String?,
      countObserved: null == countObserved
          ? _value.countObserved
          : countObserved // ignore: cast_nullable_to_non_nullable
              as int,
      stateId: freezed == stateId
          ? _value.stateId
          : stateId // ignore: cast_nullable_to_non_nullable
              as int?,
      stateName: freezed == stateName
          ? _value.stateName
          : stateName // ignore: cast_nullable_to_non_nullable
              as String?,
      districtId: freezed == districtId
          ? _value.districtId
          : districtId // ignore: cast_nullable_to_non_nullable
              as int?,
      districtName: freezed == districtName
          ? _value.districtName
          : districtName // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      verificationStatus: freezed == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      identificationStatus: freezed == identificationStatus
          ? _value.identificationStatus
          : identificationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      identifiedSpeciesId: freezed == identifiedSpeciesId
          ? _value.identifiedSpeciesId
          : identifiedSpeciesId // ignore: cast_nullable_to_non_nullable
              as String?,
      identifiedSpeciesName: freezed == identifiedSpeciesName
          ? _value.identifiedSpeciesName
          : identifiedSpeciesName // ignore: cast_nullable_to_non_nullable
              as String?,
      identificationConfidence: freezed == identificationConfidence
          ? _value.identificationConfidence
          : identificationConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      identificationReasoning: freezed == identificationReasoning
          ? _value.identificationReasoning
          : identificationReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      rawGeminiResponse: freezed == rawGeminiResponse
          ? _value.rawGeminiResponse
          : rawGeminiResponse // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      primaryImageUrl: freezed == primaryImageUrl
          ? _value.primaryImageUrl
          : primaryImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ObservationImage>,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      observedAt: freezed == observedAt
          ? _value.observedAt
          : observedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ObservationImplCopyWith<$Res>
    implements $ObservationCopyWith<$Res> {
  factory _$$ObservationImplCopyWith(
          _$ObservationImpl value, $Res Function(_$ObservationImpl) then) =
      __$$ObservationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String? userId,
      @JsonKey(name: 'user_name') String? userName,
      @JsonKey(name: 'user_avatar_url') String? userAvatarUrl,
      String? title,
      String? notes,
      String? weather,
      @JsonKey(name: 'butterfly_activity') String? butterflyActivity,
      @JsonKey(name: 'count_observed') int countObserved,
      @JsonKey(name: 'state_id') int? stateId,
      @JsonKey(name: 'state_name') String? stateName,
      @JsonKey(name: 'district_id') int? districtId,
      @JsonKey(name: 'district_name') String? districtName,
      double? latitude,
      double? longitude,
      @JsonKey(name: 'location_name') String? locationName,
      String privacy,
      String status,
      @JsonKey(name: 'verification_status') String? verificationStatus,
      @JsonKey(name: 'admin_notes') String? adminNotes,
      @JsonKey(name: 'identification_status') String? identificationStatus,
      @JsonKey(name: 'identified_species_id') String? identifiedSpeciesId,
      @JsonKey(name: 'identified_species_name') String? identifiedSpeciesName,
      @JsonKey(name: 'identification_confidence')
      double? identificationConfidence,
      @JsonKey(name: 'identification_reasoning')
      String? identificationReasoning,
      @JsonKey(name: 'raw_gemini_response')
      Map<String, dynamic>? rawGeminiResponse,
      @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
      List<ObservationImage> images,
      @JsonKey(name: 'like_count') int likeCount,
      @JsonKey(name: 'comment_count') int commentCount,
      @JsonKey(name: 'is_liked') bool isLiked,
      @JsonKey(name: 'observed_at') DateTime? observedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$ObservationImplCopyWithImpl<$Res>
    extends _$ObservationCopyWithImpl<$Res, _$ObservationImpl>
    implements _$$ObservationImplCopyWith<$Res> {
  __$$ObservationImplCopyWithImpl(
      _$ObservationImpl _value, $Res Function(_$ObservationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Observation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? userName = freezed,
    Object? userAvatarUrl = freezed,
    Object? title = freezed,
    Object? notes = freezed,
    Object? weather = freezed,
    Object? butterflyActivity = freezed,
    Object? countObserved = null,
    Object? stateId = freezed,
    Object? stateName = freezed,
    Object? districtId = freezed,
    Object? districtName = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? locationName = freezed,
    Object? privacy = null,
    Object? status = null,
    Object? verificationStatus = freezed,
    Object? adminNotes = freezed,
    Object? identificationStatus = freezed,
    Object? identifiedSpeciesId = freezed,
    Object? identifiedSpeciesName = freezed,
    Object? identificationConfidence = freezed,
    Object? identificationReasoning = freezed,
    Object? rawGeminiResponse = freezed,
    Object? primaryImageUrl = freezed,
    Object? images = null,
    Object? likeCount = null,
    Object? commentCount = null,
    Object? isLiked = null,
    Object? observedAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$ObservationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
      userAvatarUrl: freezed == userAvatarUrl
          ? _value.userAvatarUrl
          : userAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      weather: freezed == weather
          ? _value.weather
          : weather // ignore: cast_nullable_to_non_nullable
              as String?,
      butterflyActivity: freezed == butterflyActivity
          ? _value.butterflyActivity
          : butterflyActivity // ignore: cast_nullable_to_non_nullable
              as String?,
      countObserved: null == countObserved
          ? _value.countObserved
          : countObserved // ignore: cast_nullable_to_non_nullable
              as int,
      stateId: freezed == stateId
          ? _value.stateId
          : stateId // ignore: cast_nullable_to_non_nullable
              as int?,
      stateName: freezed == stateName
          ? _value.stateName
          : stateName // ignore: cast_nullable_to_non_nullable
              as String?,
      districtId: freezed == districtId
          ? _value.districtId
          : districtId // ignore: cast_nullable_to_non_nullable
              as int?,
      districtName: freezed == districtName
          ? _value.districtName
          : districtName // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      locationName: freezed == locationName
          ? _value.locationName
          : locationName // ignore: cast_nullable_to_non_nullable
              as String?,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      verificationStatus: freezed == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      adminNotes: freezed == adminNotes
          ? _value.adminNotes
          : adminNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      identificationStatus: freezed == identificationStatus
          ? _value.identificationStatus
          : identificationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      identifiedSpeciesId: freezed == identifiedSpeciesId
          ? _value.identifiedSpeciesId
          : identifiedSpeciesId // ignore: cast_nullable_to_non_nullable
              as String?,
      identifiedSpeciesName: freezed == identifiedSpeciesName
          ? _value.identifiedSpeciesName
          : identifiedSpeciesName // ignore: cast_nullable_to_non_nullable
              as String?,
      identificationConfidence: freezed == identificationConfidence
          ? _value.identificationConfidence
          : identificationConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      identificationReasoning: freezed == identificationReasoning
          ? _value.identificationReasoning
          : identificationReasoning // ignore: cast_nullable_to_non_nullable
              as String?,
      rawGeminiResponse: freezed == rawGeminiResponse
          ? _value._rawGeminiResponse
          : rawGeminiResponse // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      primaryImageUrl: freezed == primaryImageUrl
          ? _value.primaryImageUrl
          : primaryImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ObservationImage>,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
      observedAt: freezed == observedAt
          ? _value.observedAt
          : observedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ObservationImpl extends _Observation {
  const _$ObservationImpl(
      {required this.id,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'user_name') this.userName,
      @JsonKey(name: 'user_avatar_url') this.userAvatarUrl,
      this.title,
      this.notes,
      this.weather,
      @JsonKey(name: 'butterfly_activity') this.butterflyActivity,
      @JsonKey(name: 'count_observed') this.countObserved = 1,
      @JsonKey(name: 'state_id') this.stateId,
      @JsonKey(name: 'state_name') this.stateName,
      @JsonKey(name: 'district_id') this.districtId,
      @JsonKey(name: 'district_name') this.districtName,
      this.latitude,
      this.longitude,
      @JsonKey(name: 'location_name') this.locationName,
      this.privacy = 'public',
      this.status = 'pending',
      @JsonKey(name: 'verification_status') this.verificationStatus,
      @JsonKey(name: 'admin_notes') this.adminNotes,
      @JsonKey(name: 'identification_status') this.identificationStatus,
      @JsonKey(name: 'identified_species_id') this.identifiedSpeciesId,
      @JsonKey(name: 'identified_species_name') this.identifiedSpeciesName,
      @JsonKey(name: 'identification_confidence') this.identificationConfidence,
      @JsonKey(name: 'identification_reasoning') this.identificationReasoning,
      @JsonKey(name: 'raw_gemini_response')
      final Map<String, dynamic>? rawGeminiResponse,
      @JsonKey(name: 'primary_image_url') this.primaryImageUrl,
      final List<ObservationImage> images = const [],
      @JsonKey(name: 'like_count') this.likeCount = 0,
      @JsonKey(name: 'comment_count') this.commentCount = 0,
      @JsonKey(name: 'is_liked') this.isLiked = false,
      @JsonKey(name: 'observed_at') this.observedAt,
      @JsonKey(name: 'created_at') this.createdAt})
      : _rawGeminiResponse = rawGeminiResponse,
        _images = images,
        super._();

  factory _$ObservationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ObservationImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'user_name')
  final String? userName;
  @override
  @JsonKey(name: 'user_avatar_url')
  final String? userAvatarUrl;
  @override
  final String? title;
  @override
  final String? notes;
  @override
  final String? weather;
  @override
  @JsonKey(name: 'butterfly_activity')
  final String? butterflyActivity;
  @override
  @JsonKey(name: 'count_observed')
  final int countObserved;
  @override
  @JsonKey(name: 'state_id')
  final int? stateId;
  @override
  @JsonKey(name: 'state_name')
  final String? stateName;
  @override
  @JsonKey(name: 'district_id')
  final int? districtId;
  @override
  @JsonKey(name: 'district_name')
  final String? districtName;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  @JsonKey(name: 'location_name')
  final String? locationName;
  @override
  @JsonKey()
  final String privacy;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'verification_status')
  final String? verificationStatus;
// Moderation note (e.g. rejection reason) — only present for owner/staff.
  @override
  @JsonKey(name: 'admin_notes')
  final String? adminNotes;
  @override
  @JsonKey(name: 'identification_status')
  final String? identificationStatus;
  @override
  @JsonKey(name: 'identified_species_id')
  final String? identifiedSpeciesId;
  @override
  @JsonKey(name: 'identified_species_name')
  final String? identifiedSpeciesName;
  @override
  @JsonKey(name: 'identification_confidence')
  final double? identificationConfidence;
  @override
  @JsonKey(name: 'identification_reasoning')
  final String? identificationReasoning;
  final Map<String, dynamic>? _rawGeminiResponse;
  @override
  @JsonKey(name: 'raw_gemini_response')
  Map<String, dynamic>? get rawGeminiResponse {
    final value = _rawGeminiResponse;
    if (value == null) return null;
    if (_rawGeminiResponse is EqualUnmodifiableMapView)
      return _rawGeminiResponse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'primary_image_url')
  final String? primaryImageUrl;
  final List<ObservationImage> _images;
  @override
  @JsonKey()
  List<ObservationImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey(name: 'like_count')
  final int likeCount;
  @override
  @JsonKey(name: 'comment_count')
  final int commentCount;
  @override
  @JsonKey(name: 'is_liked')
  final bool isLiked;
  @override
  @JsonKey(name: 'observed_at')
  final DateTime? observedAt;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Observation(id: $id, userId: $userId, userName: $userName, userAvatarUrl: $userAvatarUrl, title: $title, notes: $notes, weather: $weather, butterflyActivity: $butterflyActivity, countObserved: $countObserved, stateId: $stateId, stateName: $stateName, districtId: $districtId, districtName: $districtName, latitude: $latitude, longitude: $longitude, locationName: $locationName, privacy: $privacy, status: $status, verificationStatus: $verificationStatus, adminNotes: $adminNotes, identificationStatus: $identificationStatus, identifiedSpeciesId: $identifiedSpeciesId, identifiedSpeciesName: $identifiedSpeciesName, identificationConfidence: $identificationConfidence, identificationReasoning: $identificationReasoning, rawGeminiResponse: $rawGeminiResponse, primaryImageUrl: $primaryImageUrl, images: $images, likeCount: $likeCount, commentCount: $commentCount, isLiked: $isLiked, observedAt: $observedAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ObservationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userAvatarUrl, userAvatarUrl) ||
                other.userAvatarUrl == userAvatarUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.weather, weather) || other.weather == weather) &&
            (identical(other.butterflyActivity, butterflyActivity) ||
                other.butterflyActivity == butterflyActivity) &&
            (identical(other.countObserved, countObserved) ||
                other.countObserved == countObserved) &&
            (identical(other.stateId, stateId) || other.stateId == stateId) &&
            (identical(other.stateName, stateName) ||
                other.stateName == stateName) &&
            (identical(other.districtId, districtId) ||
                other.districtId == districtId) &&
            (identical(other.districtName, districtName) ||
                other.districtName == districtName) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.locationName, locationName) ||
                other.locationName == locationName) &&
            (identical(other.privacy, privacy) || other.privacy == privacy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.adminNotes, adminNotes) ||
                other.adminNotes == adminNotes) &&
            (identical(other.identificationStatus, identificationStatus) ||
                other.identificationStatus == identificationStatus) &&
            (identical(other.identifiedSpeciesId, identifiedSpeciesId) ||
                other.identifiedSpeciesId == identifiedSpeciesId) &&
            (identical(other.identifiedSpeciesName, identifiedSpeciesName) ||
                other.identifiedSpeciesName == identifiedSpeciesName) &&
            (identical(
                    other.identificationConfidence, identificationConfidence) ||
                other.identificationConfidence == identificationConfidence) &&
            (identical(
                    other.identificationReasoning, identificationReasoning) ||
                other.identificationReasoning == identificationReasoning) &&
            const DeepCollectionEquality()
                .equals(other._rawGeminiResponse, _rawGeminiResponse) &&
            (identical(other.primaryImageUrl, primaryImageUrl) ||
                other.primaryImageUrl == primaryImageUrl) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked) &&
            (identical(other.observedAt, observedAt) ||
                other.observedAt == observedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        userName,
        userAvatarUrl,
        title,
        notes,
        weather,
        butterflyActivity,
        countObserved,
        stateId,
        stateName,
        districtId,
        districtName,
        latitude,
        longitude,
        locationName,
        privacy,
        status,
        verificationStatus,
        adminNotes,
        identificationStatus,
        identifiedSpeciesId,
        identifiedSpeciesName,
        identificationConfidence,
        identificationReasoning,
        const DeepCollectionEquality().hash(_rawGeminiResponse),
        primaryImageUrl,
        const DeepCollectionEquality().hash(_images),
        likeCount,
        commentCount,
        isLiked,
        observedAt,
        createdAt
      ]);

  /// Create a copy of Observation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ObservationImplCopyWith<_$ObservationImpl> get copyWith =>
      __$$ObservationImplCopyWithImpl<_$ObservationImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'user_id') String? userId,
            @JsonKey(name: 'user_name') String? userName,
            @JsonKey(name: 'user_avatar_url') String? userAvatarUrl,
            String? title,
            String? notes,
            String? weather,
            @JsonKey(name: 'butterfly_activity') String? butterflyActivity,
            @JsonKey(name: 'count_observed') int countObserved,
            @JsonKey(name: 'state_id') int? stateId,
            @JsonKey(name: 'state_name') String? stateName,
            @JsonKey(name: 'district_id') int? districtId,
            @JsonKey(name: 'district_name') String? districtName,
            double? latitude,
            double? longitude,
            @JsonKey(name: 'location_name') String? locationName,
            String privacy,
            String status,
            @JsonKey(name: 'verification_status') String? verificationStatus,
            @JsonKey(name: 'admin_notes') String? adminNotes,
            @JsonKey(name: 'identification_status')
            String? identificationStatus,
            @JsonKey(name: 'identified_species_id') String? identifiedSpeciesId,
            @JsonKey(name: 'identified_species_name')
            String? identifiedSpeciesName,
            @JsonKey(name: 'identification_confidence')
            double? identificationConfidence,
            @JsonKey(name: 'identification_reasoning')
            String? identificationReasoning,
            @JsonKey(name: 'raw_gemini_response')
            Map<String, dynamic>? rawGeminiResponse,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            List<ObservationImage> images,
            @JsonKey(name: 'like_count') int likeCount,
            @JsonKey(name: 'comment_count') int commentCount,
            @JsonKey(name: 'is_liked') bool isLiked,
            @JsonKey(name: 'observed_at') DateTime? observedAt,
            @JsonKey(name: 'created_at') DateTime? createdAt)
        $default,
  ) {
    return $default(
        id,
        userId,
        userName,
        userAvatarUrl,
        title,
        notes,
        weather,
        butterflyActivity,
        countObserved,
        stateId,
        stateName,
        districtId,
        districtName,
        latitude,
        longitude,
        locationName,
        privacy,
        status,
        verificationStatus,
        adminNotes,
        identificationStatus,
        identifiedSpeciesId,
        identifiedSpeciesName,
        identificationConfidence,
        identificationReasoning,
        rawGeminiResponse,
        primaryImageUrl,
        images,
        likeCount,
        commentCount,
        isLiked,
        observedAt,
        createdAt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            @JsonKey(name: 'user_id') String? userId,
            @JsonKey(name: 'user_name') String? userName,
            @JsonKey(name: 'user_avatar_url') String? userAvatarUrl,
            String? title,
            String? notes,
            String? weather,
            @JsonKey(name: 'butterfly_activity') String? butterflyActivity,
            @JsonKey(name: 'count_observed') int countObserved,
            @JsonKey(name: 'state_id') int? stateId,
            @JsonKey(name: 'state_name') String? stateName,
            @JsonKey(name: 'district_id') int? districtId,
            @JsonKey(name: 'district_name') String? districtName,
            double? latitude,
            double? longitude,
            @JsonKey(name: 'location_name') String? locationName,
            String privacy,
            String status,
            @JsonKey(name: 'verification_status') String? verificationStatus,
            @JsonKey(name: 'admin_notes') String? adminNotes,
            @JsonKey(name: 'identification_status')
            String? identificationStatus,
            @JsonKey(name: 'identified_species_id') String? identifiedSpeciesId,
            @JsonKey(name: 'identified_species_name')
            String? identifiedSpeciesName,
            @JsonKey(name: 'identification_confidence')
            double? identificationConfidence,
            @JsonKey(name: 'identification_reasoning')
            String? identificationReasoning,
            @JsonKey(name: 'raw_gemini_response')
            Map<String, dynamic>? rawGeminiResponse,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            List<ObservationImage> images,
            @JsonKey(name: 'like_count') int likeCount,
            @JsonKey(name: 'comment_count') int commentCount,
            @JsonKey(name: 'is_liked') bool isLiked,
            @JsonKey(name: 'observed_at') DateTime? observedAt,
            @JsonKey(name: 'created_at') DateTime? createdAt)?
        $default,
  ) {
    return $default?.call(
        id,
        userId,
        userName,
        userAvatarUrl,
        title,
        notes,
        weather,
        butterflyActivity,
        countObserved,
        stateId,
        stateName,
        districtId,
        districtName,
        latitude,
        longitude,
        locationName,
        privacy,
        status,
        verificationStatus,
        adminNotes,
        identificationStatus,
        identifiedSpeciesId,
        identifiedSpeciesName,
        identificationConfidence,
        identificationReasoning,
        rawGeminiResponse,
        primaryImageUrl,
        images,
        likeCount,
        commentCount,
        isLiked,
        observedAt,
        createdAt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'user_id') String? userId,
            @JsonKey(name: 'user_name') String? userName,
            @JsonKey(name: 'user_avatar_url') String? userAvatarUrl,
            String? title,
            String? notes,
            String? weather,
            @JsonKey(name: 'butterfly_activity') String? butterflyActivity,
            @JsonKey(name: 'count_observed') int countObserved,
            @JsonKey(name: 'state_id') int? stateId,
            @JsonKey(name: 'state_name') String? stateName,
            @JsonKey(name: 'district_id') int? districtId,
            @JsonKey(name: 'district_name') String? districtName,
            double? latitude,
            double? longitude,
            @JsonKey(name: 'location_name') String? locationName,
            String privacy,
            String status,
            @JsonKey(name: 'verification_status') String? verificationStatus,
            @JsonKey(name: 'admin_notes') String? adminNotes,
            @JsonKey(name: 'identification_status')
            String? identificationStatus,
            @JsonKey(name: 'identified_species_id') String? identifiedSpeciesId,
            @JsonKey(name: 'identified_species_name')
            String? identifiedSpeciesName,
            @JsonKey(name: 'identification_confidence')
            double? identificationConfidence,
            @JsonKey(name: 'identification_reasoning')
            String? identificationReasoning,
            @JsonKey(name: 'raw_gemini_response')
            Map<String, dynamic>? rawGeminiResponse,
            @JsonKey(name: 'primary_image_url') String? primaryImageUrl,
            List<ObservationImage> images,
            @JsonKey(name: 'like_count') int likeCount,
            @JsonKey(name: 'comment_count') int commentCount,
            @JsonKey(name: 'is_liked') bool isLiked,
            @JsonKey(name: 'observed_at') DateTime? observedAt,
            @JsonKey(name: 'created_at') DateTime? createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(
          id,
          userId,
          userName,
          userAvatarUrl,
          title,
          notes,
          weather,
          butterflyActivity,
          countObserved,
          stateId,
          stateName,
          districtId,
          districtName,
          latitude,
          longitude,
          locationName,
          privacy,
          status,
          verificationStatus,
          adminNotes,
          identificationStatus,
          identifiedSpeciesId,
          identifiedSpeciesName,
          identificationConfidence,
          identificationReasoning,
          rawGeminiResponse,
          primaryImageUrl,
          images,
          likeCount,
          commentCount,
          isLiked,
          observedAt,
          createdAt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Observation value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Observation value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Observation value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ObservationImplToJson(
      this,
    );
  }
}

abstract class _Observation extends Observation {
  const factory _Observation(
      {required final String id,
      @JsonKey(name: 'user_id') final String? userId,
      @JsonKey(name: 'user_name') final String? userName,
      @JsonKey(name: 'user_avatar_url') final String? userAvatarUrl,
      final String? title,
      final String? notes,
      final String? weather,
      @JsonKey(name: 'butterfly_activity') final String? butterflyActivity,
      @JsonKey(name: 'count_observed') final int countObserved,
      @JsonKey(name: 'state_id') final int? stateId,
      @JsonKey(name: 'state_name') final String? stateName,
      @JsonKey(name: 'district_id') final int? districtId,
      @JsonKey(name: 'district_name') final String? districtName,
      final double? latitude,
      final double? longitude,
      @JsonKey(name: 'location_name') final String? locationName,
      final String privacy,
      final String status,
      @JsonKey(name: 'verification_status') final String? verificationStatus,
      @JsonKey(name: 'admin_notes') final String? adminNotes,
      @JsonKey(name: 'identification_status')
      final String? identificationStatus,
      @JsonKey(name: 'identified_species_id') final String? identifiedSpeciesId,
      @JsonKey(name: 'identified_species_name')
      final String? identifiedSpeciesName,
      @JsonKey(name: 'identification_confidence')
      final double? identificationConfidence,
      @JsonKey(name: 'identification_reasoning')
      final String? identificationReasoning,
      @JsonKey(name: 'raw_gemini_response')
      final Map<String, dynamic>? rawGeminiResponse,
      @JsonKey(name: 'primary_image_url') final String? primaryImageUrl,
      final List<ObservationImage> images,
      @JsonKey(name: 'like_count') final int likeCount,
      @JsonKey(name: 'comment_count') final int commentCount,
      @JsonKey(name: 'is_liked') final bool isLiked,
      @JsonKey(name: 'observed_at') final DateTime? observedAt,
      @JsonKey(name: 'created_at')
      final DateTime? createdAt}) = _$ObservationImpl;
  const _Observation._() : super._();

  factory _Observation.fromJson(Map<String, dynamic> json) =
      _$ObservationImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'user_name')
  String? get userName;
  @override
  @JsonKey(name: 'user_avatar_url')
  String? get userAvatarUrl;
  @override
  String? get title;
  @override
  String? get notes;
  @override
  String? get weather;
  @override
  @JsonKey(name: 'butterfly_activity')
  String? get butterflyActivity;
  @override
  @JsonKey(name: 'count_observed')
  int get countObserved;
  @override
  @JsonKey(name: 'state_id')
  int? get stateId;
  @override
  @JsonKey(name: 'state_name')
  String? get stateName;
  @override
  @JsonKey(name: 'district_id')
  int? get districtId;
  @override
  @JsonKey(name: 'district_name')
  String? get districtName;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  @JsonKey(name: 'location_name')
  String? get locationName;
  @override
  String get privacy;
  @override
  String get status;
  @override
  @JsonKey(name: 'verification_status')
  String?
      get verificationStatus; // Moderation note (e.g. rejection reason) — only present for owner/staff.
  @override
  @JsonKey(name: 'admin_notes')
  String? get adminNotes;
  @override
  @JsonKey(name: 'identification_status')
  String? get identificationStatus;
  @override
  @JsonKey(name: 'identified_species_id')
  String? get identifiedSpeciesId;
  @override
  @JsonKey(name: 'identified_species_name')
  String? get identifiedSpeciesName;
  @override
  @JsonKey(name: 'identification_confidence')
  double? get identificationConfidence;
  @override
  @JsonKey(name: 'identification_reasoning')
  String? get identificationReasoning;
  @override
  @JsonKey(name: 'raw_gemini_response')
  Map<String, dynamic>? get rawGeminiResponse;
  @override
  @JsonKey(name: 'primary_image_url')
  String? get primaryImageUrl;
  @override
  List<ObservationImage> get images;
  @override
  @JsonKey(name: 'like_count')
  int get likeCount;
  @override
  @JsonKey(name: 'comment_count')
  int get commentCount;
  @override
  @JsonKey(name: 'is_liked')
  bool get isLiked;
  @override
  @JsonKey(name: 'observed_at')
  DateTime? get observedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of Observation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ObservationImplCopyWith<_$ObservationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ObservationImage _$ObservationImageFromJson(Map<String, dynamic> json) {
  return _ObservationImage.fromJson(json);
}

/// @nodoc
mixin _$ObservationImage {
  String? get id =>
      throw _privateConstructorUsedError; // Backend returns original_url / optimized_url / thumbnail_url (no image_url).
  @JsonKey(name: 'optimized_url')
  String? get optimizedUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_url')
  String? get originalUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_primary')
  bool get isPrimary => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String? id,
            @JsonKey(name: 'optimized_url') String? optimizedUrl,
            @JsonKey(name: 'original_url') String? originalUrl,
            @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
            @JsonKey(name: 'is_primary') bool isPrimary)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String? id,
            @JsonKey(name: 'optimized_url') String? optimizedUrl,
            @JsonKey(name: 'original_url') String? originalUrl,
            @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
            @JsonKey(name: 'is_primary') bool isPrimary)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String? id,
            @JsonKey(name: 'optimized_url') String? optimizedUrl,
            @JsonKey(name: 'original_url') String? originalUrl,
            @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
            @JsonKey(name: 'is_primary') bool isPrimary)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ObservationImage value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ObservationImage value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ObservationImage value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ObservationImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ObservationImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ObservationImageCopyWith<ObservationImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ObservationImageCopyWith<$Res> {
  factory $ObservationImageCopyWith(
          ObservationImage value, $Res Function(ObservationImage) then) =
      _$ObservationImageCopyWithImpl<$Res, ObservationImage>;
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'optimized_url') String? optimizedUrl,
      @JsonKey(name: 'original_url') String? originalUrl,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @JsonKey(name: 'is_primary') bool isPrimary});
}

/// @nodoc
class _$ObservationImageCopyWithImpl<$Res, $Val extends ObservationImage>
    implements $ObservationImageCopyWith<$Res> {
  _$ObservationImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ObservationImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? optimizedUrl = freezed,
    Object? originalUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? isPrimary = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      optimizedUrl: freezed == optimizedUrl
          ? _value.optimizedUrl
          : optimizedUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      originalUrl: freezed == originalUrl
          ? _value.originalUrl
          : originalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ObservationImageImplCopyWith<$Res>
    implements $ObservationImageCopyWith<$Res> {
  factory _$$ObservationImageImplCopyWith(_$ObservationImageImpl value,
          $Res Function(_$ObservationImageImpl) then) =
      __$$ObservationImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      @JsonKey(name: 'optimized_url') String? optimizedUrl,
      @JsonKey(name: 'original_url') String? originalUrl,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      @JsonKey(name: 'is_primary') bool isPrimary});
}

/// @nodoc
class __$$ObservationImageImplCopyWithImpl<$Res>
    extends _$ObservationImageCopyWithImpl<$Res, _$ObservationImageImpl>
    implements _$$ObservationImageImplCopyWith<$Res> {
  __$$ObservationImageImplCopyWithImpl(_$ObservationImageImpl _value,
      $Res Function(_$ObservationImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ObservationImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? optimizedUrl = freezed,
    Object? originalUrl = freezed,
    Object? thumbnailUrl = freezed,
    Object? isPrimary = null,
  }) {
    return _then(_$ObservationImageImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      optimizedUrl: freezed == optimizedUrl
          ? _value.optimizedUrl
          : optimizedUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      originalUrl: freezed == originalUrl
          ? _value.originalUrl
          : originalUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isPrimary: null == isPrimary
          ? _value.isPrimary
          : isPrimary // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ObservationImageImpl extends _ObservationImage {
  const _$ObservationImageImpl(
      {this.id,
      @JsonKey(name: 'optimized_url') this.optimizedUrl,
      @JsonKey(name: 'original_url') this.originalUrl,
      @JsonKey(name: 'thumbnail_url') this.thumbnailUrl,
      @JsonKey(name: 'is_primary') this.isPrimary = false})
      : super._();

  factory _$ObservationImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ObservationImageImplFromJson(json);

  @override
  final String? id;
// Backend returns original_url / optimized_url / thumbnail_url (no image_url).
  @override
  @JsonKey(name: 'optimized_url')
  final String? optimizedUrl;
  @override
  @JsonKey(name: 'original_url')
  final String? originalUrl;
  @override
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @override
  @JsonKey(name: 'is_primary')
  final bool isPrimary;

  @override
  String toString() {
    return 'ObservationImage(id: $id, optimizedUrl: $optimizedUrl, originalUrl: $originalUrl, thumbnailUrl: $thumbnailUrl, isPrimary: $isPrimary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ObservationImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.optimizedUrl, optimizedUrl) ||
                other.optimizedUrl == optimizedUrl) &&
            (identical(other.originalUrl, originalUrl) ||
                other.originalUrl == originalUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.isPrimary, isPrimary) ||
                other.isPrimary == isPrimary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, optimizedUrl, originalUrl, thumbnailUrl, isPrimary);

  /// Create a copy of ObservationImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ObservationImageImplCopyWith<_$ObservationImageImpl> get copyWith =>
      __$$ObservationImageImplCopyWithImpl<_$ObservationImageImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String? id,
            @JsonKey(name: 'optimized_url') String? optimizedUrl,
            @JsonKey(name: 'original_url') String? originalUrl,
            @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
            @JsonKey(name: 'is_primary') bool isPrimary)
        $default,
  ) {
    return $default(id, optimizedUrl, originalUrl, thumbnailUrl, isPrimary);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String? id,
            @JsonKey(name: 'optimized_url') String? optimizedUrl,
            @JsonKey(name: 'original_url') String? originalUrl,
            @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
            @JsonKey(name: 'is_primary') bool isPrimary)?
        $default,
  ) {
    return $default?.call(
        id, optimizedUrl, originalUrl, thumbnailUrl, isPrimary);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String? id,
            @JsonKey(name: 'optimized_url') String? optimizedUrl,
            @JsonKey(name: 'original_url') String? originalUrl,
            @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
            @JsonKey(name: 'is_primary') bool isPrimary)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, optimizedUrl, originalUrl, thumbnailUrl, isPrimary);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ObservationImage value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ObservationImage value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ObservationImage value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ObservationImageImplToJson(
      this,
    );
  }
}

abstract class _ObservationImage extends ObservationImage {
  const factory _ObservationImage(
          {final String? id,
          @JsonKey(name: 'optimized_url') final String? optimizedUrl,
          @JsonKey(name: 'original_url') final String? originalUrl,
          @JsonKey(name: 'thumbnail_url') final String? thumbnailUrl,
          @JsonKey(name: 'is_primary') final bool isPrimary}) =
      _$ObservationImageImpl;
  const _ObservationImage._() : super._();

  factory _ObservationImage.fromJson(Map<String, dynamic> json) =
      _$ObservationImageImpl.fromJson;

  @override
  String?
      get id; // Backend returns original_url / optimized_url / thumbnail_url (no image_url).
  @override
  @JsonKey(name: 'optimized_url')
  String? get optimizedUrl;
  @override
  @JsonKey(name: 'original_url')
  String? get originalUrl;
  @override
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl;
  @override
  @JsonKey(name: 'is_primary')
  bool get isPrimary;

  /// Create a copy of ObservationImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ObservationImageImplCopyWith<_$ObservationImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
