// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AiResult _$AiResultFromJson(Map<String, dynamic> json) {
  return _AiResult.fromJson(json);
}

/// @nodoc
mixin _$AiResult {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'observation_id')
  String? get observationId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'error_message')
  String? get errorMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'processing_time_ms')
  int? get processingTimeMs => throw _privateConstructorUsedError;
  @JsonKey(name: 'gemini_model_version')
  String? get modelVersion => throw _privateConstructorUsedError;
  List<AiMatch> get matches => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'raw_gemini_response')
  Map<String, dynamic>? get rawResponse => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'observation_id') String? observationId,
            String status,
            @JsonKey(name: 'error_message') String? errorMessage,
            @JsonKey(name: 'processing_time_ms') int? processingTimeMs,
            @JsonKey(name: 'gemini_model_version') String? modelVersion,
            List<AiMatch> matches,
            @JsonKey(name: 'created_at') DateTime? createdAt,
            @JsonKey(name: 'completed_at') DateTime? completedAt,
            @JsonKey(name: 'raw_gemini_response')
            Map<String, dynamic>? rawResponse)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            @JsonKey(name: 'observation_id') String? observationId,
            String status,
            @JsonKey(name: 'error_message') String? errorMessage,
            @JsonKey(name: 'processing_time_ms') int? processingTimeMs,
            @JsonKey(name: 'gemini_model_version') String? modelVersion,
            List<AiMatch> matches,
            @JsonKey(name: 'created_at') DateTime? createdAt,
            @JsonKey(name: 'completed_at') DateTime? completedAt,
            @JsonKey(name: 'raw_gemini_response')
            Map<String, dynamic>? rawResponse)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'observation_id') String? observationId,
            String status,
            @JsonKey(name: 'error_message') String? errorMessage,
            @JsonKey(name: 'processing_time_ms') int? processingTimeMs,
            @JsonKey(name: 'gemini_model_version') String? modelVersion,
            List<AiMatch> matches,
            @JsonKey(name: 'created_at') DateTime? createdAt,
            @JsonKey(name: 'completed_at') DateTime? completedAt,
            @JsonKey(name: 'raw_gemini_response')
            Map<String, dynamic>? rawResponse)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AiResult value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AiResult value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AiResult value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this AiResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiResultCopyWith<AiResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiResultCopyWith<$Res> {
  factory $AiResultCopyWith(AiResult value, $Res Function(AiResult) then) =
      _$AiResultCopyWithImpl<$Res, AiResult>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'observation_id') String? observationId,
      String status,
      @JsonKey(name: 'error_message') String? errorMessage,
      @JsonKey(name: 'processing_time_ms') int? processingTimeMs,
      @JsonKey(name: 'gemini_model_version') String? modelVersion,
      List<AiMatch> matches,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      @JsonKey(name: 'raw_gemini_response') Map<String, dynamic>? rawResponse});
}

/// @nodoc
class _$AiResultCopyWithImpl<$Res, $Val extends AiResult>
    implements $AiResultCopyWith<$Res> {
  _$AiResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? observationId = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? processingTimeMs = freezed,
    Object? modelVersion = freezed,
    Object? matches = null,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
    Object? rawResponse = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      observationId: freezed == observationId
          ? _value.observationId
          : observationId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      processingTimeMs: freezed == processingTimeMs
          ? _value.processingTimeMs
          : processingTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
      modelVersion: freezed == modelVersion
          ? _value.modelVersion
          : modelVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      matches: null == matches
          ? _value.matches
          : matches // ignore: cast_nullable_to_non_nullable
              as List<AiMatch>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rawResponse: freezed == rawResponse
          ? _value.rawResponse
          : rawResponse // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiResultImplCopyWith<$Res>
    implements $AiResultCopyWith<$Res> {
  factory _$$AiResultImplCopyWith(
          _$AiResultImpl value, $Res Function(_$AiResultImpl) then) =
      __$$AiResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'observation_id') String? observationId,
      String status,
      @JsonKey(name: 'error_message') String? errorMessage,
      @JsonKey(name: 'processing_time_ms') int? processingTimeMs,
      @JsonKey(name: 'gemini_model_version') String? modelVersion,
      List<AiMatch> matches,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      @JsonKey(name: 'raw_gemini_response') Map<String, dynamic>? rawResponse});
}

/// @nodoc
class __$$AiResultImplCopyWithImpl<$Res>
    extends _$AiResultCopyWithImpl<$Res, _$AiResultImpl>
    implements _$$AiResultImplCopyWith<$Res> {
  __$$AiResultImplCopyWithImpl(
      _$AiResultImpl _value, $Res Function(_$AiResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? observationId = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? processingTimeMs = freezed,
    Object? modelVersion = freezed,
    Object? matches = null,
    Object? createdAt = freezed,
    Object? completedAt = freezed,
    Object? rawResponse = freezed,
  }) {
    return _then(_$AiResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      observationId: freezed == observationId
          ? _value.observationId
          : observationId // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      processingTimeMs: freezed == processingTimeMs
          ? _value.processingTimeMs
          : processingTimeMs // ignore: cast_nullable_to_non_nullable
              as int?,
      modelVersion: freezed == modelVersion
          ? _value.modelVersion
          : modelVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      matches: null == matches
          ? _value._matches
          : matches // ignore: cast_nullable_to_non_nullable
              as List<AiMatch>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rawResponse: freezed == rawResponse
          ? _value._rawResponse
          : rawResponse // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiResultImpl extends _AiResult {
  const _$AiResultImpl(
      {required this.id,
      @JsonKey(name: 'observation_id') this.observationId,
      this.status = 'pending',
      @JsonKey(name: 'error_message') this.errorMessage,
      @JsonKey(name: 'processing_time_ms') this.processingTimeMs,
      @JsonKey(name: 'gemini_model_version') this.modelVersion,
      final List<AiMatch> matches = const [],
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'completed_at') this.completedAt,
      @JsonKey(name: 'raw_gemini_response')
      final Map<String, dynamic>? rawResponse})
      : _matches = matches,
        _rawResponse = rawResponse,
        super._();

  factory _$AiResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiResultImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'observation_id')
  final String? observationId;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(name: 'error_message')
  final String? errorMessage;
  @override
  @JsonKey(name: 'processing_time_ms')
  final int? processingTimeMs;
  @override
  @JsonKey(name: 'gemini_model_version')
  final String? modelVersion;
  final List<AiMatch> _matches;
  @override
  @JsonKey()
  List<AiMatch> get matches {
    if (_matches is EqualUnmodifiableListView) return _matches;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matches);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  final Map<String, dynamic>? _rawResponse;
  @override
  @JsonKey(name: 'raw_gemini_response')
  Map<String, dynamic>? get rawResponse {
    final value = _rawResponse;
    if (value == null) return null;
    if (_rawResponse is EqualUnmodifiableMapView) return _rawResponse;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AiResult(id: $id, observationId: $observationId, status: $status, errorMessage: $errorMessage, processingTimeMs: $processingTimeMs, modelVersion: $modelVersion, matches: $matches, createdAt: $createdAt, completedAt: $completedAt, rawResponse: $rawResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.observationId, observationId) ||
                other.observationId == observationId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.processingTimeMs, processingTimeMs) ||
                other.processingTimeMs == processingTimeMs) &&
            (identical(other.modelVersion, modelVersion) ||
                other.modelVersion == modelVersion) &&
            const DeepCollectionEquality().equals(other._matches, _matches) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            const DeepCollectionEquality()
                .equals(other._rawResponse, _rawResponse));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      observationId,
      status,
      errorMessage,
      processingTimeMs,
      modelVersion,
      const DeepCollectionEquality().hash(_matches),
      createdAt,
      completedAt,
      const DeepCollectionEquality().hash(_rawResponse));

  /// Create a copy of AiResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiResultImplCopyWith<_$AiResultImpl> get copyWith =>
      __$$AiResultImplCopyWithImpl<_$AiResultImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'observation_id') String? observationId,
            String status,
            @JsonKey(name: 'error_message') String? errorMessage,
            @JsonKey(name: 'processing_time_ms') int? processingTimeMs,
            @JsonKey(name: 'gemini_model_version') String? modelVersion,
            List<AiMatch> matches,
            @JsonKey(name: 'created_at') DateTime? createdAt,
            @JsonKey(name: 'completed_at') DateTime? completedAt,
            @JsonKey(name: 'raw_gemini_response')
            Map<String, dynamic>? rawResponse)
        $default,
  ) {
    return $default(id, observationId, status, errorMessage, processingTimeMs,
        modelVersion, matches, createdAt, completedAt, rawResponse);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            @JsonKey(name: 'observation_id') String? observationId,
            String status,
            @JsonKey(name: 'error_message') String? errorMessage,
            @JsonKey(name: 'processing_time_ms') int? processingTimeMs,
            @JsonKey(name: 'gemini_model_version') String? modelVersion,
            List<AiMatch> matches,
            @JsonKey(name: 'created_at') DateTime? createdAt,
            @JsonKey(name: 'completed_at') DateTime? completedAt,
            @JsonKey(name: 'raw_gemini_response')
            Map<String, dynamic>? rawResponse)?
        $default,
  ) {
    return $default?.call(
        id,
        observationId,
        status,
        errorMessage,
        processingTimeMs,
        modelVersion,
        matches,
        createdAt,
        completedAt,
        rawResponse);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            @JsonKey(name: 'observation_id') String? observationId,
            String status,
            @JsonKey(name: 'error_message') String? errorMessage,
            @JsonKey(name: 'processing_time_ms') int? processingTimeMs,
            @JsonKey(name: 'gemini_model_version') String? modelVersion,
            List<AiMatch> matches,
            @JsonKey(name: 'created_at') DateTime? createdAt,
            @JsonKey(name: 'completed_at') DateTime? completedAt,
            @JsonKey(name: 'raw_gemini_response')
            Map<String, dynamic>? rawResponse)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, observationId, status, errorMessage, processingTimeMs,
          modelVersion, matches, createdAt, completedAt, rawResponse);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AiResult value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AiResult value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AiResult value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AiResultImplToJson(
      this,
    );
  }
}

abstract class _AiResult extends AiResult {
  const factory _AiResult(
      {required final String id,
      @JsonKey(name: 'observation_id') final String? observationId,
      final String status,
      @JsonKey(name: 'error_message') final String? errorMessage,
      @JsonKey(name: 'processing_time_ms') final int? processingTimeMs,
      @JsonKey(name: 'gemini_model_version') final String? modelVersion,
      final List<AiMatch> matches,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'completed_at') final DateTime? completedAt,
      @JsonKey(name: 'raw_gemini_response')
      final Map<String, dynamic>? rawResponse}) = _$AiResultImpl;
  const _AiResult._() : super._();

  factory _AiResult.fromJson(Map<String, dynamic> json) =
      _$AiResultImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'observation_id')
  String? get observationId;
  @override
  String get status;
  @override
  @JsonKey(name: 'error_message')
  String? get errorMessage;
  @override
  @JsonKey(name: 'processing_time_ms')
  int? get processingTimeMs;
  @override
  @JsonKey(name: 'gemini_model_version')
  String? get modelVersion;
  @override
  List<AiMatch> get matches;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(name: 'raw_gemini_response')
  Map<String, dynamic>? get rawResponse;

  /// Create a copy of AiResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiResultImplCopyWith<_$AiResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiMatch _$AiMatchFromJson(Map<String, dynamic> json) {
  return _AiMatch.fromJson(json);
}

/// @nodoc
mixin _$AiMatch {
  int get id => throw _privateConstructorUsedError;
  int get rank => throw _privateConstructorUsedError;
  @JsonKey(name: 'confidence_score')
  double get confidenceScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'matched_common_name')
  String? get commonName => throw _privateConstructorUsedError;
  @JsonKey(name: 'matched_scientific_name')
  String? get scientificName => throw _privateConstructorUsedError;
  @JsonKey(name: 'species_id')
  String? get speciesId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_accepted')
  bool get isAccepted => throw _privateConstructorUsedError;
  Map<String, dynamic>? get species => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id,
            int rank,
            @JsonKey(name: 'confidence_score') double confidenceScore,
            @JsonKey(name: 'matched_common_name') String? commonName,
            @JsonKey(name: 'matched_scientific_name') String? scientificName,
            @JsonKey(name: 'species_id') String? speciesId,
            @JsonKey(name: 'is_accepted') bool isAccepted,
            Map<String, dynamic>? species)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id,
            int rank,
            @JsonKey(name: 'confidence_score') double confidenceScore,
            @JsonKey(name: 'matched_common_name') String? commonName,
            @JsonKey(name: 'matched_scientific_name') String? scientificName,
            @JsonKey(name: 'species_id') String? speciesId,
            @JsonKey(name: 'is_accepted') bool isAccepted,
            Map<String, dynamic>? species)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id,
            int rank,
            @JsonKey(name: 'confidence_score') double confidenceScore,
            @JsonKey(name: 'matched_common_name') String? commonName,
            @JsonKey(name: 'matched_scientific_name') String? scientificName,
            @JsonKey(name: 'species_id') String? speciesId,
            @JsonKey(name: 'is_accepted') bool isAccepted,
            Map<String, dynamic>? species)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AiMatch value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AiMatch value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AiMatch value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this AiMatch to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiMatchCopyWith<AiMatch> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiMatchCopyWith<$Res> {
  factory $AiMatchCopyWith(AiMatch value, $Res Function(AiMatch) then) =
      _$AiMatchCopyWithImpl<$Res, AiMatch>;
  @useResult
  $Res call(
      {int id,
      int rank,
      @JsonKey(name: 'confidence_score') double confidenceScore,
      @JsonKey(name: 'matched_common_name') String? commonName,
      @JsonKey(name: 'matched_scientific_name') String? scientificName,
      @JsonKey(name: 'species_id') String? speciesId,
      @JsonKey(name: 'is_accepted') bool isAccepted,
      Map<String, dynamic>? species});
}

/// @nodoc
class _$AiMatchCopyWithImpl<$Res, $Val extends AiMatch>
    implements $AiMatchCopyWith<$Res> {
  _$AiMatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rank = null,
    Object? confidenceScore = null,
    Object? commonName = freezed,
    Object? scientificName = freezed,
    Object? speciesId = freezed,
    Object? isAccepted = null,
    Object? species = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      confidenceScore: null == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
      commonName: freezed == commonName
          ? _value.commonName
          : commonName // ignore: cast_nullable_to_non_nullable
              as String?,
      scientificName: freezed == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String?,
      speciesId: freezed == speciesId
          ? _value.speciesId
          : speciesId // ignore: cast_nullable_to_non_nullable
              as String?,
      isAccepted: null == isAccepted
          ? _value.isAccepted
          : isAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      species: freezed == species
          ? _value.species
          : species // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiMatchImplCopyWith<$Res> implements $AiMatchCopyWith<$Res> {
  factory _$$AiMatchImplCopyWith(
          _$AiMatchImpl value, $Res Function(_$AiMatchImpl) then) =
      __$$AiMatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      int rank,
      @JsonKey(name: 'confidence_score') double confidenceScore,
      @JsonKey(name: 'matched_common_name') String? commonName,
      @JsonKey(name: 'matched_scientific_name') String? scientificName,
      @JsonKey(name: 'species_id') String? speciesId,
      @JsonKey(name: 'is_accepted') bool isAccepted,
      Map<String, dynamic>? species});
}

/// @nodoc
class __$$AiMatchImplCopyWithImpl<$Res>
    extends _$AiMatchCopyWithImpl<$Res, _$AiMatchImpl>
    implements _$$AiMatchImplCopyWith<$Res> {
  __$$AiMatchImplCopyWithImpl(
      _$AiMatchImpl _value, $Res Function(_$AiMatchImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiMatch
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? rank = null,
    Object? confidenceScore = null,
    Object? commonName = freezed,
    Object? scientificName = freezed,
    Object? speciesId = freezed,
    Object? isAccepted = null,
    Object? species = freezed,
  }) {
    return _then(_$AiMatchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      confidenceScore: null == confidenceScore
          ? _value.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
      commonName: freezed == commonName
          ? _value.commonName
          : commonName // ignore: cast_nullable_to_non_nullable
              as String?,
      scientificName: freezed == scientificName
          ? _value.scientificName
          : scientificName // ignore: cast_nullable_to_non_nullable
              as String?,
      speciesId: freezed == speciesId
          ? _value.speciesId
          : speciesId // ignore: cast_nullable_to_non_nullable
              as String?,
      isAccepted: null == isAccepted
          ? _value.isAccepted
          : isAccepted // ignore: cast_nullable_to_non_nullable
              as bool,
      species: freezed == species
          ? _value._species
          : species // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiMatchImpl extends _AiMatch {
  const _$AiMatchImpl(
      {required this.id,
      this.rank = 1,
      @JsonKey(name: 'confidence_score') this.confidenceScore = 0,
      @JsonKey(name: 'matched_common_name') this.commonName,
      @JsonKey(name: 'matched_scientific_name') this.scientificName,
      @JsonKey(name: 'species_id') this.speciesId,
      @JsonKey(name: 'is_accepted') this.isAccepted = false,
      final Map<String, dynamic>? species})
      : _species = species,
        super._();

  factory _$AiMatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiMatchImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey()
  final int rank;
  @override
  @JsonKey(name: 'confidence_score')
  final double confidenceScore;
  @override
  @JsonKey(name: 'matched_common_name')
  final String? commonName;
  @override
  @JsonKey(name: 'matched_scientific_name')
  final String? scientificName;
  @override
  @JsonKey(name: 'species_id')
  final String? speciesId;
  @override
  @JsonKey(name: 'is_accepted')
  final bool isAccepted;
  final Map<String, dynamic>? _species;
  @override
  Map<String, dynamic>? get species {
    final value = _species;
    if (value == null) return null;
    if (_species is EqualUnmodifiableMapView) return _species;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'AiMatch(id: $id, rank: $rank, confidenceScore: $confidenceScore, commonName: $commonName, scientificName: $scientificName, speciesId: $speciesId, isAccepted: $isAccepted, species: $species)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiMatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.commonName, commonName) ||
                other.commonName == commonName) &&
            (identical(other.scientificName, scientificName) ||
                other.scientificName == scientificName) &&
            (identical(other.speciesId, speciesId) ||
                other.speciesId == speciesId) &&
            (identical(other.isAccepted, isAccepted) ||
                other.isAccepted == isAccepted) &&
            const DeepCollectionEquality().equals(other._species, _species));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      rank,
      confidenceScore,
      commonName,
      scientificName,
      speciesId,
      isAccepted,
      const DeepCollectionEquality().hash(_species));

  /// Create a copy of AiMatch
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiMatchImplCopyWith<_$AiMatchImpl> get copyWith =>
      __$$AiMatchImplCopyWithImpl<_$AiMatchImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            int id,
            int rank,
            @JsonKey(name: 'confidence_score') double confidenceScore,
            @JsonKey(name: 'matched_common_name') String? commonName,
            @JsonKey(name: 'matched_scientific_name') String? scientificName,
            @JsonKey(name: 'species_id') String? speciesId,
            @JsonKey(name: 'is_accepted') bool isAccepted,
            Map<String, dynamic>? species)
        $default,
  ) {
    return $default(id, rank, confidenceScore, commonName, scientificName,
        speciesId, isAccepted, species);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            int id,
            int rank,
            @JsonKey(name: 'confidence_score') double confidenceScore,
            @JsonKey(name: 'matched_common_name') String? commonName,
            @JsonKey(name: 'matched_scientific_name') String? scientificName,
            @JsonKey(name: 'species_id') String? speciesId,
            @JsonKey(name: 'is_accepted') bool isAccepted,
            Map<String, dynamic>? species)?
        $default,
  ) {
    return $default?.call(id, rank, confidenceScore, commonName, scientificName,
        speciesId, isAccepted, species);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            int id,
            int rank,
            @JsonKey(name: 'confidence_score') double confidenceScore,
            @JsonKey(name: 'matched_common_name') String? commonName,
            @JsonKey(name: 'matched_scientific_name') String? scientificName,
            @JsonKey(name: 'species_id') String? speciesId,
            @JsonKey(name: 'is_accepted') bool isAccepted,
            Map<String, dynamic>? species)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, rank, confidenceScore, commonName, scientificName,
          speciesId, isAccepted, species);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AiMatch value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AiMatch value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AiMatch value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AiMatchImplToJson(
      this,
    );
  }
}

abstract class _AiMatch extends AiMatch {
  const factory _AiMatch(
      {required final int id,
      final int rank,
      @JsonKey(name: 'confidence_score') final double confidenceScore,
      @JsonKey(name: 'matched_common_name') final String? commonName,
      @JsonKey(name: 'matched_scientific_name') final String? scientificName,
      @JsonKey(name: 'species_id') final String? speciesId,
      @JsonKey(name: 'is_accepted') final bool isAccepted,
      final Map<String, dynamic>? species}) = _$AiMatchImpl;
  const _AiMatch._() : super._();

  factory _AiMatch.fromJson(Map<String, dynamic> json) = _$AiMatchImpl.fromJson;

  @override
  int get id;
  @override
  int get rank;
  @override
  @JsonKey(name: 'confidence_score')
  double get confidenceScore;
  @override
  @JsonKey(name: 'matched_common_name')
  String? get commonName;
  @override
  @JsonKey(name: 'matched_scientific_name')
  String? get scientificName;
  @override
  @JsonKey(name: 'species_id')
  String? get speciesId;
  @override
  @JsonKey(name: 'is_accepted')
  bool get isAccepted;
  @override
  Map<String, dynamic>? get species;

  /// Create a copy of AiMatch
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiMatchImplCopyWith<_$AiMatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
