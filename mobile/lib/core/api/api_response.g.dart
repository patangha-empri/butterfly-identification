// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiResponseImpl<T> _$$ApiResponseImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    $checkedCreate(
      r'_$ApiResponseImpl',
      json,
      ($checkedConvert) {
        final val = _$ApiResponseImpl<T>(
          success: $checkedConvert('success', (v) => v as bool),
          data: $checkedConvert(
              'data', (v) => _$nullableGenericFromJson(v, fromJsonT)),
          message: $checkedConvert('message', (v) => v as String?),
          meta: $checkedConvert(
              'meta',
              (v) => v == null
                  ? null
                  : ApiMeta.fromJson(v as Map<String, dynamic>)),
          errors: $checkedConvert('errors', (v) => v as Map<String, dynamic>?),
        );
        return val;
      },
    );

Map<String, dynamic> _$$ApiResponseImplToJson<T>(
  _$ApiResponseImpl<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'success': instance.success,
      if (_$nullableGenericToJson(instance.data, toJsonT) case final value?)
        'data': value,
      if (instance.message case final value?) 'message': value,
      if (instance.meta?.toJson() case final value?) 'meta': value,
      if (instance.errors case final value?) 'errors': value,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);

_$ApiMetaImpl _$$ApiMetaImplFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      r'_$ApiMetaImpl',
      json,
      ($checkedConvert) {
        final val = _$ApiMetaImpl(
          total: $checkedConvert('total', (v) => (v as num?)?.toInt()),
          page: $checkedConvert('page', (v) => (v as num?)?.toInt()),
          perPage: $checkedConvert('per_page', (v) => (v as num?)?.toInt()),
          totalPages:
              $checkedConvert('total_pages', (v) => (v as num?)?.toInt()),
          hasMore: $checkedConvert('has_more', (v) => v as bool?),
        );
        return val;
      },
      fieldKeyMap: const {
        'perPage': 'per_page',
        'totalPages': 'total_pages',
        'hasMore': 'has_more'
      },
    );

Map<String, dynamic> _$$ApiMetaImplToJson(_$ApiMetaImpl instance) =>
    <String, dynamic>{
      if (instance.total case final value?) 'total': value,
      if (instance.page case final value?) 'page': value,
      if (instance.perPage case final value?) 'per_page': value,
      if (instance.totalPages case final value?) 'total_pages': value,
      if (instance.hasMore case final value?) 'has_more': value,
    };
