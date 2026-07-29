// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CachedObservationsTableTable extends CachedObservationsTable
    with TableInfo<$CachedObservationsTableTable, CachedObservationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedObservationsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _stateIdMeta =
      const VerificationMeta('stateId');
  @override
  late final GeneratedColumn<int> stateId = GeneratedColumn<int>(
      'state_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _stateNameMeta =
      const VerificationMeta('stateName');
  @override
  late final GeneratedColumn<String> stateName = GeneratedColumn<String>(
      'state_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _latitudeMeta =
      const VerificationMeta('latitude');
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
      'latitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _longitudeMeta =
      const VerificationMeta('longitude');
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
      'longitude', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _locationNameMeta =
      const VerificationMeta('locationName');
  @override
  late final GeneratedColumn<String> locationName = GeneratedColumn<String>(
      'location_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _privacyMeta =
      const VerificationMeta('privacy');
  @override
  late final GeneratedColumn<String> privacy = GeneratedColumn<String>(
      'privacy', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('public'));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _identificationStatusMeta =
      const VerificationMeta('identificationStatus');
  @override
  late final GeneratedColumn<String> identificationStatus =
      GeneratedColumn<String>('identification_status', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _identifiedSpeciesIdMeta =
      const VerificationMeta('identifiedSpeciesId');
  @override
  late final GeneratedColumn<String> identifiedSpeciesId =
      GeneratedColumn<String>('identified_species_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _identifiedSpeciesNameMeta =
      const VerificationMeta('identifiedSpeciesName');
  @override
  late final GeneratedColumn<String> identifiedSpeciesName =
      GeneratedColumn<String>('identified_species_name', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _identificationConfidenceMeta =
      const VerificationMeta('identificationConfidence');
  @override
  late final GeneratedColumn<double> identificationConfidence =
      GeneratedColumn<double>('identification_confidence', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _primaryImageUrlMeta =
      const VerificationMeta('primaryImageUrl');
  @override
  late final GeneratedColumn<String> primaryImageUrl = GeneratedColumn<String>(
      'primary_image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageUrlsJsonMeta =
      const VerificationMeta('imageUrlsJson');
  @override
  late final GeneratedColumn<String> imageUrlsJson = GeneratedColumn<String>(
      'image_urls_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _observedAtMeta =
      const VerificationMeta('observedAt');
  @override
  late final GeneratedColumn<DateTime> observedAt = GeneratedColumn<DateTime>(
      'observed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _cachedAtMeta =
      const VerificationMeta('cachedAt');
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
      'cached_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _likeCountMeta =
      const VerificationMeta('likeCount');
  @override
  late final GeneratedColumn<int> likeCount = GeneratedColumn<int>(
      'like_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _commentCountMeta =
      const VerificationMeta('commentCount');
  @override
  late final GeneratedColumn<int> commentCount = GeneratedColumn<int>(
      'comment_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        title,
        notes,
        stateId,
        stateName,
        latitude,
        longitude,
        locationName,
        privacy,
        status,
        identificationStatus,
        identifiedSpeciesId,
        identifiedSpeciesName,
        identificationConfidence,
        primaryImageUrl,
        imageUrlsJson,
        observedAt,
        createdAt,
        cachedAt,
        isSynced,
        likeCount,
        commentCount
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_observations';
  @override
  VerificationContext validateIntegrity(
      Insertable<CachedObservationRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('state_id')) {
      context.handle(_stateIdMeta,
          stateId.isAcceptableOrUnknown(data['state_id']!, _stateIdMeta));
    }
    if (data.containsKey('state_name')) {
      context.handle(_stateNameMeta,
          stateName.isAcceptableOrUnknown(data['state_name']!, _stateNameMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    }
    if (data.containsKey('location_name')) {
      context.handle(
          _locationNameMeta,
          locationName.isAcceptableOrUnknown(
              data['location_name']!, _locationNameMeta));
    }
    if (data.containsKey('privacy')) {
      context.handle(_privacyMeta,
          privacy.isAcceptableOrUnknown(data['privacy']!, _privacyMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('identification_status')) {
      context.handle(
          _identificationStatusMeta,
          identificationStatus.isAcceptableOrUnknown(
              data['identification_status']!, _identificationStatusMeta));
    }
    if (data.containsKey('identified_species_id')) {
      context.handle(
          _identifiedSpeciesIdMeta,
          identifiedSpeciesId.isAcceptableOrUnknown(
              data['identified_species_id']!, _identifiedSpeciesIdMeta));
    }
    if (data.containsKey('identified_species_name')) {
      context.handle(
          _identifiedSpeciesNameMeta,
          identifiedSpeciesName.isAcceptableOrUnknown(
              data['identified_species_name']!, _identifiedSpeciesNameMeta));
    }
    if (data.containsKey('identification_confidence')) {
      context.handle(
          _identificationConfidenceMeta,
          identificationConfidence.isAcceptableOrUnknown(
              data['identification_confidence']!,
              _identificationConfidenceMeta));
    }
    if (data.containsKey('primary_image_url')) {
      context.handle(
          _primaryImageUrlMeta,
          primaryImageUrl.isAcceptableOrUnknown(
              data['primary_image_url']!, _primaryImageUrlMeta));
    }
    if (data.containsKey('image_urls_json')) {
      context.handle(
          _imageUrlsJsonMeta,
          imageUrlsJson.isAcceptableOrUnknown(
              data['image_urls_json']!, _imageUrlsJsonMeta));
    }
    if (data.containsKey('observed_at')) {
      context.handle(
          _observedAtMeta,
          observedAt.isAcceptableOrUnknown(
              data['observed_at']!, _observedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('cached_at')) {
      context.handle(_cachedAtMeta,
          cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('like_count')) {
      context.handle(_likeCountMeta,
          likeCount.isAcceptableOrUnknown(data['like_count']!, _likeCountMeta));
    }
    if (data.containsKey('comment_count')) {
      context.handle(
          _commentCountMeta,
          commentCount.isAcceptableOrUnknown(
              data['comment_count']!, _commentCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedObservationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedObservationRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      stateId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}state_id']),
      stateName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}state_name']),
      latitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}latitude']),
      longitude: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}longitude']),
      locationName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_name']),
      privacy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}privacy'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      identificationStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}identification_status']),
      identifiedSpeciesId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}identified_species_id']),
      identifiedSpeciesName: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}identified_species_name']),
      identificationConfidence: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}identification_confidence']),
      primaryImageUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}primary_image_url']),
      imageUrlsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_urls_json']),
      observedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}observed_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      cachedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cached_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      likeCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}like_count'])!,
      commentCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}comment_count'])!,
    );
  }

  @override
  $CachedObservationsTableTable createAlias(String alias) {
    return $CachedObservationsTableTable(attachedDatabase, alias);
  }
}

class CachedObservationRow extends DataClass
    implements Insertable<CachedObservationRow> {
  final String id;
  final String? userId;
  final String? title;
  final String? notes;
  final int? stateId;
  final String? stateName;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final String privacy;
  final String status;
  final String? identificationStatus;
  final String? identifiedSpeciesId;
  final String? identifiedSpeciesName;
  final double? identificationConfidence;
  final String? primaryImageUrl;
  final String? imageUrlsJson;
  final DateTime? observedAt;
  final DateTime createdAt;
  final DateTime cachedAt;
  final bool isSynced;
  final int likeCount;
  final int commentCount;
  const CachedObservationRow(
      {required this.id,
      this.userId,
      this.title,
      this.notes,
      this.stateId,
      this.stateName,
      this.latitude,
      this.longitude,
      this.locationName,
      required this.privacy,
      required this.status,
      this.identificationStatus,
      this.identifiedSpeciesId,
      this.identifiedSpeciesName,
      this.identificationConfidence,
      this.primaryImageUrl,
      this.imageUrlsJson,
      this.observedAt,
      required this.createdAt,
      required this.cachedAt,
      required this.isSynced,
      required this.likeCount,
      required this.commentCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || stateId != null) {
      map['state_id'] = Variable<int>(stateId);
    }
    if (!nullToAbsent || stateName != null) {
      map['state_name'] = Variable<String>(stateName);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || locationName != null) {
      map['location_name'] = Variable<String>(locationName);
    }
    map['privacy'] = Variable<String>(privacy);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || identificationStatus != null) {
      map['identification_status'] = Variable<String>(identificationStatus);
    }
    if (!nullToAbsent || identifiedSpeciesId != null) {
      map['identified_species_id'] = Variable<String>(identifiedSpeciesId);
    }
    if (!nullToAbsent || identifiedSpeciesName != null) {
      map['identified_species_name'] = Variable<String>(identifiedSpeciesName);
    }
    if (!nullToAbsent || identificationConfidence != null) {
      map['identification_confidence'] =
          Variable<double>(identificationConfidence);
    }
    if (!nullToAbsent || primaryImageUrl != null) {
      map['primary_image_url'] = Variable<String>(primaryImageUrl);
    }
    if (!nullToAbsent || imageUrlsJson != null) {
      map['image_urls_json'] = Variable<String>(imageUrlsJson);
    }
    if (!nullToAbsent || observedAt != null) {
      map['observed_at'] = Variable<DateTime>(observedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['like_count'] = Variable<int>(likeCount);
    map['comment_count'] = Variable<int>(commentCount);
    return map;
  }

  CachedObservationsTableCompanion toCompanion(bool nullToAbsent) {
    return CachedObservationsTableCompanion(
      id: Value(id),
      userId:
          userId == null && nullToAbsent ? const Value.absent() : Value(userId),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      stateId: stateId == null && nullToAbsent
          ? const Value.absent()
          : Value(stateId),
      stateName: stateName == null && nullToAbsent
          ? const Value.absent()
          : Value(stateName),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      locationName: locationName == null && nullToAbsent
          ? const Value.absent()
          : Value(locationName),
      privacy: Value(privacy),
      status: Value(status),
      identificationStatus: identificationStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(identificationStatus),
      identifiedSpeciesId: identifiedSpeciesId == null && nullToAbsent
          ? const Value.absent()
          : Value(identifiedSpeciesId),
      identifiedSpeciesName: identifiedSpeciesName == null && nullToAbsent
          ? const Value.absent()
          : Value(identifiedSpeciesName),
      identificationConfidence: identificationConfidence == null && nullToAbsent
          ? const Value.absent()
          : Value(identificationConfidence),
      primaryImageUrl: primaryImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryImageUrl),
      imageUrlsJson: imageUrlsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrlsJson),
      observedAt: observedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(observedAt),
      createdAt: Value(createdAt),
      cachedAt: Value(cachedAt),
      isSynced: Value(isSynced),
      likeCount: Value(likeCount),
      commentCount: Value(commentCount),
    );
  }

  factory CachedObservationRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedObservationRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      title: serializer.fromJson<String?>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      stateId: serializer.fromJson<int?>(json['stateId']),
      stateName: serializer.fromJson<String?>(json['stateName']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      locationName: serializer.fromJson<String?>(json['locationName']),
      privacy: serializer.fromJson<String>(json['privacy']),
      status: serializer.fromJson<String>(json['status']),
      identificationStatus:
          serializer.fromJson<String?>(json['identificationStatus']),
      identifiedSpeciesId:
          serializer.fromJson<String?>(json['identifiedSpeciesId']),
      identifiedSpeciesName:
          serializer.fromJson<String?>(json['identifiedSpeciesName']),
      identificationConfidence:
          serializer.fromJson<double?>(json['identificationConfidence']),
      primaryImageUrl: serializer.fromJson<String?>(json['primaryImageUrl']),
      imageUrlsJson: serializer.fromJson<String?>(json['imageUrlsJson']),
      observedAt: serializer.fromJson<DateTime?>(json['observedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      likeCount: serializer.fromJson<int>(json['likeCount']),
      commentCount: serializer.fromJson<int>(json['commentCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'title': serializer.toJson<String?>(title),
      'notes': serializer.toJson<String?>(notes),
      'stateId': serializer.toJson<int?>(stateId),
      'stateName': serializer.toJson<String?>(stateName),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'locationName': serializer.toJson<String?>(locationName),
      'privacy': serializer.toJson<String>(privacy),
      'status': serializer.toJson<String>(status),
      'identificationStatus': serializer.toJson<String?>(identificationStatus),
      'identifiedSpeciesId': serializer.toJson<String?>(identifiedSpeciesId),
      'identifiedSpeciesName':
          serializer.toJson<String?>(identifiedSpeciesName),
      'identificationConfidence':
          serializer.toJson<double?>(identificationConfidence),
      'primaryImageUrl': serializer.toJson<String?>(primaryImageUrl),
      'imageUrlsJson': serializer.toJson<String?>(imageUrlsJson),
      'observedAt': serializer.toJson<DateTime?>(observedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'likeCount': serializer.toJson<int>(likeCount),
      'commentCount': serializer.toJson<int>(commentCount),
    };
  }

  CachedObservationRow copyWith(
          {String? id,
          Value<String?> userId = const Value.absent(),
          Value<String?> title = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<int?> stateId = const Value.absent(),
          Value<String?> stateName = const Value.absent(),
          Value<double?> latitude = const Value.absent(),
          Value<double?> longitude = const Value.absent(),
          Value<String?> locationName = const Value.absent(),
          String? privacy,
          String? status,
          Value<String?> identificationStatus = const Value.absent(),
          Value<String?> identifiedSpeciesId = const Value.absent(),
          Value<String?> identifiedSpeciesName = const Value.absent(),
          Value<double?> identificationConfidence = const Value.absent(),
          Value<String?> primaryImageUrl = const Value.absent(),
          Value<String?> imageUrlsJson = const Value.absent(),
          Value<DateTime?> observedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? cachedAt,
          bool? isSynced,
          int? likeCount,
          int? commentCount}) =>
      CachedObservationRow(
        id: id ?? this.id,
        userId: userId.present ? userId.value : this.userId,
        title: title.present ? title.value : this.title,
        notes: notes.present ? notes.value : this.notes,
        stateId: stateId.present ? stateId.value : this.stateId,
        stateName: stateName.present ? stateName.value : this.stateName,
        latitude: latitude.present ? latitude.value : this.latitude,
        longitude: longitude.present ? longitude.value : this.longitude,
        locationName:
            locationName.present ? locationName.value : this.locationName,
        privacy: privacy ?? this.privacy,
        status: status ?? this.status,
        identificationStatus: identificationStatus.present
            ? identificationStatus.value
            : this.identificationStatus,
        identifiedSpeciesId: identifiedSpeciesId.present
            ? identifiedSpeciesId.value
            : this.identifiedSpeciesId,
        identifiedSpeciesName: identifiedSpeciesName.present
            ? identifiedSpeciesName.value
            : this.identifiedSpeciesName,
        identificationConfidence: identificationConfidence.present
            ? identificationConfidence.value
            : this.identificationConfidence,
        primaryImageUrl: primaryImageUrl.present
            ? primaryImageUrl.value
            : this.primaryImageUrl,
        imageUrlsJson:
            imageUrlsJson.present ? imageUrlsJson.value : this.imageUrlsJson,
        observedAt: observedAt.present ? observedAt.value : this.observedAt,
        createdAt: createdAt ?? this.createdAt,
        cachedAt: cachedAt ?? this.cachedAt,
        isSynced: isSynced ?? this.isSynced,
        likeCount: likeCount ?? this.likeCount,
        commentCount: commentCount ?? this.commentCount,
      );
  CachedObservationRow copyWithCompanion(
      CachedObservationsTableCompanion data) {
    return CachedObservationRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      stateId: data.stateId.present ? data.stateId.value : this.stateId,
      stateName: data.stateName.present ? data.stateName.value : this.stateName,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      locationName: data.locationName.present
          ? data.locationName.value
          : this.locationName,
      privacy: data.privacy.present ? data.privacy.value : this.privacy,
      status: data.status.present ? data.status.value : this.status,
      identificationStatus: data.identificationStatus.present
          ? data.identificationStatus.value
          : this.identificationStatus,
      identifiedSpeciesId: data.identifiedSpeciesId.present
          ? data.identifiedSpeciesId.value
          : this.identifiedSpeciesId,
      identifiedSpeciesName: data.identifiedSpeciesName.present
          ? data.identifiedSpeciesName.value
          : this.identifiedSpeciesName,
      identificationConfidence: data.identificationConfidence.present
          ? data.identificationConfidence.value
          : this.identificationConfidence,
      primaryImageUrl: data.primaryImageUrl.present
          ? data.primaryImageUrl.value
          : this.primaryImageUrl,
      imageUrlsJson: data.imageUrlsJson.present
          ? data.imageUrlsJson.value
          : this.imageUrlsJson,
      observedAt:
          data.observedAt.present ? data.observedAt.value : this.observedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      likeCount: data.likeCount.present ? data.likeCount.value : this.likeCount,
      commentCount: data.commentCount.present
          ? data.commentCount.value
          : this.commentCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedObservationRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('stateId: $stateId, ')
          ..write('stateName: $stateName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('locationName: $locationName, ')
          ..write('privacy: $privacy, ')
          ..write('status: $status, ')
          ..write('identificationStatus: $identificationStatus, ')
          ..write('identifiedSpeciesId: $identifiedSpeciesId, ')
          ..write('identifiedSpeciesName: $identifiedSpeciesName, ')
          ..write('identificationConfidence: $identificationConfidence, ')
          ..write('primaryImageUrl: $primaryImageUrl, ')
          ..write('imageUrlsJson: $imageUrlsJson, ')
          ..write('observedAt: $observedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('likeCount: $likeCount, ')
          ..write('commentCount: $commentCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        userId,
        title,
        notes,
        stateId,
        stateName,
        latitude,
        longitude,
        locationName,
        privacy,
        status,
        identificationStatus,
        identifiedSpeciesId,
        identifiedSpeciesName,
        identificationConfidence,
        primaryImageUrl,
        imageUrlsJson,
        observedAt,
        createdAt,
        cachedAt,
        isSynced,
        likeCount,
        commentCount
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedObservationRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.stateId == this.stateId &&
          other.stateName == this.stateName &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.locationName == this.locationName &&
          other.privacy == this.privacy &&
          other.status == this.status &&
          other.identificationStatus == this.identificationStatus &&
          other.identifiedSpeciesId == this.identifiedSpeciesId &&
          other.identifiedSpeciesName == this.identifiedSpeciesName &&
          other.identificationConfidence == this.identificationConfidence &&
          other.primaryImageUrl == this.primaryImageUrl &&
          other.imageUrlsJson == this.imageUrlsJson &&
          other.observedAt == this.observedAt &&
          other.createdAt == this.createdAt &&
          other.cachedAt == this.cachedAt &&
          other.isSynced == this.isSynced &&
          other.likeCount == this.likeCount &&
          other.commentCount == this.commentCount);
}

class CachedObservationsTableCompanion
    extends UpdateCompanion<CachedObservationRow> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String?> title;
  final Value<String?> notes;
  final Value<int?> stateId;
  final Value<String?> stateName;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> locationName;
  final Value<String> privacy;
  final Value<String> status;
  final Value<String?> identificationStatus;
  final Value<String?> identifiedSpeciesId;
  final Value<String?> identifiedSpeciesName;
  final Value<double?> identificationConfidence;
  final Value<String?> primaryImageUrl;
  final Value<String?> imageUrlsJson;
  final Value<DateTime?> observedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> cachedAt;
  final Value<bool> isSynced;
  final Value<int> likeCount;
  final Value<int> commentCount;
  final Value<int> rowid;
  const CachedObservationsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.stateId = const Value.absent(),
    this.stateName = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.locationName = const Value.absent(),
    this.privacy = const Value.absent(),
    this.status = const Value.absent(),
    this.identificationStatus = const Value.absent(),
    this.identifiedSpeciesId = const Value.absent(),
    this.identifiedSpeciesName = const Value.absent(),
    this.identificationConfidence = const Value.absent(),
    this.primaryImageUrl = const Value.absent(),
    this.imageUrlsJson = const Value.absent(),
    this.observedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.likeCount = const Value.absent(),
    this.commentCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedObservationsTableCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.stateId = const Value.absent(),
    this.stateName = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.locationName = const Value.absent(),
    this.privacy = const Value.absent(),
    this.status = const Value.absent(),
    this.identificationStatus = const Value.absent(),
    this.identifiedSpeciesId = const Value.absent(),
    this.identifiedSpeciesName = const Value.absent(),
    this.identificationConfidence = const Value.absent(),
    this.primaryImageUrl = const Value.absent(),
    this.imageUrlsJson = const Value.absent(),
    this.observedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.likeCount = const Value.absent(),
    this.commentCount = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<CachedObservationRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<int>? stateId,
    Expression<String>? stateName,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? locationName,
    Expression<String>? privacy,
    Expression<String>? status,
    Expression<String>? identificationStatus,
    Expression<String>? identifiedSpeciesId,
    Expression<String>? identifiedSpeciesName,
    Expression<double>? identificationConfidence,
    Expression<String>? primaryImageUrl,
    Expression<String>? imageUrlsJson,
    Expression<DateTime>? observedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? cachedAt,
    Expression<bool>? isSynced,
    Expression<int>? likeCount,
    Expression<int>? commentCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (stateId != null) 'state_id': stateId,
      if (stateName != null) 'state_name': stateName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (locationName != null) 'location_name': locationName,
      if (privacy != null) 'privacy': privacy,
      if (status != null) 'status': status,
      if (identificationStatus != null)
        'identification_status': identificationStatus,
      if (identifiedSpeciesId != null)
        'identified_species_id': identifiedSpeciesId,
      if (identifiedSpeciesName != null)
        'identified_species_name': identifiedSpeciesName,
      if (identificationConfidence != null)
        'identification_confidence': identificationConfidence,
      if (primaryImageUrl != null) 'primary_image_url': primaryImageUrl,
      if (imageUrlsJson != null) 'image_urls_json': imageUrlsJson,
      if (observedAt != null) 'observed_at': observedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (likeCount != null) 'like_count': likeCount,
      if (commentCount != null) 'comment_count': commentCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedObservationsTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? userId,
      Value<String?>? title,
      Value<String?>? notes,
      Value<int?>? stateId,
      Value<String?>? stateName,
      Value<double?>? latitude,
      Value<double?>? longitude,
      Value<String?>? locationName,
      Value<String>? privacy,
      Value<String>? status,
      Value<String?>? identificationStatus,
      Value<String?>? identifiedSpeciesId,
      Value<String?>? identifiedSpeciesName,
      Value<double?>? identificationConfidence,
      Value<String?>? primaryImageUrl,
      Value<String?>? imageUrlsJson,
      Value<DateTime?>? observedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? cachedAt,
      Value<bool>? isSynced,
      Value<int>? likeCount,
      Value<int>? commentCount,
      Value<int>? rowid}) {
    return CachedObservationsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      stateId: stateId ?? this.stateId,
      stateName: stateName ?? this.stateName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      privacy: privacy ?? this.privacy,
      status: status ?? this.status,
      identificationStatus: identificationStatus ?? this.identificationStatus,
      identifiedSpeciesId: identifiedSpeciesId ?? this.identifiedSpeciesId,
      identifiedSpeciesName:
          identifiedSpeciesName ?? this.identifiedSpeciesName,
      identificationConfidence:
          identificationConfidence ?? this.identificationConfidence,
      primaryImageUrl: primaryImageUrl ?? this.primaryImageUrl,
      imageUrlsJson: imageUrlsJson ?? this.imageUrlsJson,
      observedAt: observedAt ?? this.observedAt,
      createdAt: createdAt ?? this.createdAt,
      cachedAt: cachedAt ?? this.cachedAt,
      isSynced: isSynced ?? this.isSynced,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (stateId.present) {
      map['state_id'] = Variable<int>(stateId.value);
    }
    if (stateName.present) {
      map['state_name'] = Variable<String>(stateName.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (locationName.present) {
      map['location_name'] = Variable<String>(locationName.value);
    }
    if (privacy.present) {
      map['privacy'] = Variable<String>(privacy.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (identificationStatus.present) {
      map['identification_status'] =
          Variable<String>(identificationStatus.value);
    }
    if (identifiedSpeciesId.present) {
      map['identified_species_id'] =
          Variable<String>(identifiedSpeciesId.value);
    }
    if (identifiedSpeciesName.present) {
      map['identified_species_name'] =
          Variable<String>(identifiedSpeciesName.value);
    }
    if (identificationConfidence.present) {
      map['identification_confidence'] =
          Variable<double>(identificationConfidence.value);
    }
    if (primaryImageUrl.present) {
      map['primary_image_url'] = Variable<String>(primaryImageUrl.value);
    }
    if (imageUrlsJson.present) {
      map['image_urls_json'] = Variable<String>(imageUrlsJson.value);
    }
    if (observedAt.present) {
      map['observed_at'] = Variable<DateTime>(observedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (likeCount.present) {
      map['like_count'] = Variable<int>(likeCount.value);
    }
    if (commentCount.present) {
      map['comment_count'] = Variable<int>(commentCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedObservationsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('stateId: $stateId, ')
          ..write('stateName: $stateName, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('locationName: $locationName, ')
          ..write('privacy: $privacy, ')
          ..write('status: $status, ')
          ..write('identificationStatus: $identificationStatus, ')
          ..write('identifiedSpeciesId: $identifiedSpeciesId, ')
          ..write('identifiedSpeciesName: $identifiedSpeciesName, ')
          ..write('identificationConfidence: $identificationConfidence, ')
          ..write('primaryImageUrl: $primaryImageUrl, ')
          ..write('imageUrlsJson: $imageUrlsJson, ')
          ..write('observedAt: $observedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('likeCount: $likeCount, ')
          ..write('commentCount: $commentCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfflineQueueTableTable extends OfflineQueueTable
    with TableInfo<$OfflineQueueTableTable, OfflineQueueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineQueueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<int> localId = GeneratedColumn<int>(
      'local_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endpointMeta =
      const VerificationMeta('endpoint');
  @override
  late final GeneratedColumn<String> endpoint = GeneratedColumn<String>(
      'endpoint', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _httpMethodMeta =
      const VerificationMeta('httpMethod');
  @override
  late final GeneratedColumn<String> httpMethod = GeneratedColumn<String>(
      'http_method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('POST'));
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _maxRetriesMeta =
      const VerificationMeta('maxRetries');
  @override
  late final GeneratedColumn<int> maxRetries = GeneratedColumn<int>(
      'max_retries', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _hasImagesMeta =
      const VerificationMeta('hasImages');
  @override
  late final GeneratedColumn<bool> hasImages = GeneratedColumn<bool>(
      'has_images', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("has_images" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _localImagePathsMeta =
      const VerificationMeta('localImagePaths');
  @override
  late final GeneratedColumn<String> localImagePaths = GeneratedColumn<String>(
      'local_image_paths', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _lastAttemptAtMeta =
      const VerificationMeta('lastAttemptAt');
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>('last_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        localId,
        type,
        payload,
        endpoint,
        httpMethod,
        retryCount,
        maxRetries,
        hasImages,
        localImagePaths,
        status,
        errorMessage,
        createdAt,
        lastAttemptAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_queue';
  @override
  VerificationContext validateIntegrity(Insertable<OfflineQueueRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('endpoint')) {
      context.handle(_endpointMeta,
          endpoint.isAcceptableOrUnknown(data['endpoint']!, _endpointMeta));
    } else if (isInserting) {
      context.missing(_endpointMeta);
    }
    if (data.containsKey('http_method')) {
      context.handle(
          _httpMethodMeta,
          httpMethod.isAcceptableOrUnknown(
              data['http_method']!, _httpMethodMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('max_retries')) {
      context.handle(
          _maxRetriesMeta,
          maxRetries.isAcceptableOrUnknown(
              data['max_retries']!, _maxRetriesMeta));
    }
    if (data.containsKey('has_images')) {
      context.handle(_hasImagesMeta,
          hasImages.isAcceptableOrUnknown(data['has_images']!, _hasImagesMeta));
    }
    if (data.containsKey('local_image_paths')) {
      context.handle(
          _localImagePathsMeta,
          localImagePaths.isAcceptableOrUnknown(
              data['local_image_paths']!, _localImagePathsMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
          _lastAttemptAtMeta,
          lastAttemptAt.isAcceptableOrUnknown(
              data['last_attempt_at']!, _lastAttemptAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  OfflineQueueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineQueueRow(
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      endpoint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}endpoint'])!,
      httpMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}http_method'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      maxRetries: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_retries'])!,
      hasImages: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_images'])!,
      localImagePaths: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}local_image_paths']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_attempt_at']),
    );
  }

  @override
  $OfflineQueueTableTable createAlias(String alias) {
    return $OfflineQueueTableTable(attachedDatabase, alias);
  }
}

class OfflineQueueRow extends DataClass implements Insertable<OfflineQueueRow> {
  final int localId;
  final String type;
  final String payload;
  final String endpoint;
  final String httpMethod;
  final int retryCount;
  final int maxRetries;
  final bool hasImages;
  final String? localImagePaths;
  final String status;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime? lastAttemptAt;
  const OfflineQueueRow(
      {required this.localId,
      required this.type,
      required this.payload,
      required this.endpoint,
      required this.httpMethod,
      required this.retryCount,
      required this.maxRetries,
      required this.hasImages,
      this.localImagePaths,
      required this.status,
      this.errorMessage,
      required this.createdAt,
      this.lastAttemptAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<int>(localId);
    map['type'] = Variable<String>(type);
    map['payload'] = Variable<String>(payload);
    map['endpoint'] = Variable<String>(endpoint);
    map['http_method'] = Variable<String>(httpMethod);
    map['retry_count'] = Variable<int>(retryCount);
    map['max_retries'] = Variable<int>(maxRetries);
    map['has_images'] = Variable<bool>(hasImages);
    if (!nullToAbsent || localImagePaths != null) {
      map['local_image_paths'] = Variable<String>(localImagePaths);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    return map;
  }

  OfflineQueueTableCompanion toCompanion(bool nullToAbsent) {
    return OfflineQueueTableCompanion(
      localId: Value(localId),
      type: Value(type),
      payload: Value(payload),
      endpoint: Value(endpoint),
      httpMethod: Value(httpMethod),
      retryCount: Value(retryCount),
      maxRetries: Value(maxRetries),
      hasImages: Value(hasImages),
      localImagePaths: localImagePaths == null && nullToAbsent
          ? const Value.absent()
          : Value(localImagePaths),
      status: Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
    );
  }

  factory OfflineQueueRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineQueueRow(
      localId: serializer.fromJson<int>(json['localId']),
      type: serializer.fromJson<String>(json['type']),
      payload: serializer.fromJson<String>(json['payload']),
      endpoint: serializer.fromJson<String>(json['endpoint']),
      httpMethod: serializer.fromJson<String>(json['httpMethod']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      maxRetries: serializer.fromJson<int>(json['maxRetries']),
      hasImages: serializer.fromJson<bool>(json['hasImages']),
      localImagePaths: serializer.fromJson<String?>(json['localImagePaths']),
      status: serializer.fromJson<String>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<int>(localId),
      'type': serializer.toJson<String>(type),
      'payload': serializer.toJson<String>(payload),
      'endpoint': serializer.toJson<String>(endpoint),
      'httpMethod': serializer.toJson<String>(httpMethod),
      'retryCount': serializer.toJson<int>(retryCount),
      'maxRetries': serializer.toJson<int>(maxRetries),
      'hasImages': serializer.toJson<bool>(hasImages),
      'localImagePaths': serializer.toJson<String?>(localImagePaths),
      'status': serializer.toJson<String>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
    };
  }

  OfflineQueueRow copyWith(
          {int? localId,
          String? type,
          String? payload,
          String? endpoint,
          String? httpMethod,
          int? retryCount,
          int? maxRetries,
          bool? hasImages,
          Value<String?> localImagePaths = const Value.absent(),
          String? status,
          Value<String?> errorMessage = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> lastAttemptAt = const Value.absent()}) =>
      OfflineQueueRow(
        localId: localId ?? this.localId,
        type: type ?? this.type,
        payload: payload ?? this.payload,
        endpoint: endpoint ?? this.endpoint,
        httpMethod: httpMethod ?? this.httpMethod,
        retryCount: retryCount ?? this.retryCount,
        maxRetries: maxRetries ?? this.maxRetries,
        hasImages: hasImages ?? this.hasImages,
        localImagePaths: localImagePaths.present
            ? localImagePaths.value
            : this.localImagePaths,
        status: status ?? this.status,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        createdAt: createdAt ?? this.createdAt,
        lastAttemptAt:
            lastAttemptAt.present ? lastAttemptAt.value : this.lastAttemptAt,
      );
  OfflineQueueRow copyWithCompanion(OfflineQueueTableCompanion data) {
    return OfflineQueueRow(
      localId: data.localId.present ? data.localId.value : this.localId,
      type: data.type.present ? data.type.value : this.type,
      payload: data.payload.present ? data.payload.value : this.payload,
      endpoint: data.endpoint.present ? data.endpoint.value : this.endpoint,
      httpMethod:
          data.httpMethod.present ? data.httpMethod.value : this.httpMethod,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      maxRetries:
          data.maxRetries.present ? data.maxRetries.value : this.maxRetries,
      hasImages: data.hasImages.present ? data.hasImages.value : this.hasImages,
      localImagePaths: data.localImagePaths.present
          ? data.localImagePaths.value
          : this.localImagePaths,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineQueueRow(')
          ..write('localId: $localId, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('endpoint: $endpoint, ')
          ..write('httpMethod: $httpMethod, ')
          ..write('retryCount: $retryCount, ')
          ..write('maxRetries: $maxRetries, ')
          ..write('hasImages: $hasImages, ')
          ..write('localImagePaths: $localImagePaths, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      localId,
      type,
      payload,
      endpoint,
      httpMethod,
      retryCount,
      maxRetries,
      hasImages,
      localImagePaths,
      status,
      errorMessage,
      createdAt,
      lastAttemptAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineQueueRow &&
          other.localId == this.localId &&
          other.type == this.type &&
          other.payload == this.payload &&
          other.endpoint == this.endpoint &&
          other.httpMethod == this.httpMethod &&
          other.retryCount == this.retryCount &&
          other.maxRetries == this.maxRetries &&
          other.hasImages == this.hasImages &&
          other.localImagePaths == this.localImagePaths &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt &&
          other.lastAttemptAt == this.lastAttemptAt);
}

class OfflineQueueTableCompanion extends UpdateCompanion<OfflineQueueRow> {
  final Value<int> localId;
  final Value<String> type;
  final Value<String> payload;
  final Value<String> endpoint;
  final Value<String> httpMethod;
  final Value<int> retryCount;
  final Value<int> maxRetries;
  final Value<bool> hasImages;
  final Value<String?> localImagePaths;
  final Value<String> status;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastAttemptAt;
  const OfflineQueueTableCompanion({
    this.localId = const Value.absent(),
    this.type = const Value.absent(),
    this.payload = const Value.absent(),
    this.endpoint = const Value.absent(),
    this.httpMethod = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.maxRetries = const Value.absent(),
    this.hasImages = const Value.absent(),
    this.localImagePaths = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
  });
  OfflineQueueTableCompanion.insert({
    this.localId = const Value.absent(),
    required String type,
    required String payload,
    required String endpoint,
    this.httpMethod = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.maxRetries = const Value.absent(),
    this.hasImages = const Value.absent(),
    this.localImagePaths = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
  })  : type = Value(type),
        payload = Value(payload),
        endpoint = Value(endpoint);
  static Insertable<OfflineQueueRow> custom({
    Expression<int>? localId,
    Expression<String>? type,
    Expression<String>? payload,
    Expression<String>? endpoint,
    Expression<String>? httpMethod,
    Expression<int>? retryCount,
    Expression<int>? maxRetries,
    Expression<bool>? hasImages,
    Expression<String>? localImagePaths,
    Expression<String>? status,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastAttemptAt,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (type != null) 'type': type,
      if (payload != null) 'payload': payload,
      if (endpoint != null) 'endpoint': endpoint,
      if (httpMethod != null) 'http_method': httpMethod,
      if (retryCount != null) 'retry_count': retryCount,
      if (maxRetries != null) 'max_retries': maxRetries,
      if (hasImages != null) 'has_images': hasImages,
      if (localImagePaths != null) 'local_image_paths': localImagePaths,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
    });
  }

  OfflineQueueTableCompanion copyWith(
      {Value<int>? localId,
      Value<String>? type,
      Value<String>? payload,
      Value<String>? endpoint,
      Value<String>? httpMethod,
      Value<int>? retryCount,
      Value<int>? maxRetries,
      Value<bool>? hasImages,
      Value<String?>? localImagePaths,
      Value<String>? status,
      Value<String?>? errorMessage,
      Value<DateTime>? createdAt,
      Value<DateTime?>? lastAttemptAt}) {
    return OfflineQueueTableCompanion(
      localId: localId ?? this.localId,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      endpoint: endpoint ?? this.endpoint,
      httpMethod: httpMethod ?? this.httpMethod,
      retryCount: retryCount ?? this.retryCount,
      maxRetries: maxRetries ?? this.maxRetries,
      hasImages: hasImages ?? this.hasImages,
      localImagePaths: localImagePaths ?? this.localImagePaths,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<int>(localId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (endpoint.present) {
      map['endpoint'] = Variable<String>(endpoint.value);
    }
    if (httpMethod.present) {
      map['http_method'] = Variable<String>(httpMethod.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (maxRetries.present) {
      map['max_retries'] = Variable<int>(maxRetries.value);
    }
    if (hasImages.present) {
      map['has_images'] = Variable<bool>(hasImages.value);
    }
    if (localImagePaths.present) {
      map['local_image_paths'] = Variable<String>(localImagePaths.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineQueueTableCompanion(')
          ..write('localId: $localId, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('endpoint: $endpoint, ')
          ..write('httpMethod: $httpMethod, ')
          ..write('retryCount: $retryCount, ')
          ..write('maxRetries: $maxRetries, ')
          ..write('hasImages: $hasImages, ')
          ..write('localImagePaths: $localImagePaths, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastAttemptAt: $lastAttemptAt')
          ..write(')'))
        .toString();
  }
}

class $CachedSpeciesTableTable extends CachedSpeciesTable
    with TableInfo<$CachedSpeciesTableTable, CachedSpeciesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedSpeciesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _commonNameMeta =
      const VerificationMeta('commonName');
  @override
  late final GeneratedColumn<String> commonName = GeneratedColumn<String>(
      'common_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scientificNameMeta =
      const VerificationMeta('scientificName');
  @override
  late final GeneratedColumn<String> scientificName = GeneratedColumn<String>(
      'scientific_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _familyMeta = const VerificationMeta('family');
  @override
  late final GeneratedColumn<String> family = GeneratedColumn<String>(
      'family', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _subfamilyMeta =
      const VerificationMeta('subfamily');
  @override
  late final GeneratedColumn<String> subfamily = GeneratedColumn<String>(
      'subfamily', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _primaryImageUrlMeta =
      const VerificationMeta('primaryImageUrl');
  @override
  late final GeneratedColumn<String> primaryImageUrl = GeneratedColumn<String>(
      'primary_image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
      'rarity', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conservationStatusMeta =
      const VerificationMeta('conservationStatus');
  @override
  late final GeneratedColumn<String> conservationStatus =
      GeneratedColumn<String>('conservation_status', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionShortMeta =
      const VerificationMeta('descriptionShort');
  @override
  late final GeneratedColumn<String> descriptionShort = GeneratedColumn<String>(
      'description_short', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statesJsonMeta =
      const VerificationMeta('statesJson');
  @override
  late final GeneratedColumn<String> statesJson = GeneratedColumn<String>(
      'states_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isBookmarkedMeta =
      const VerificationMeta('isBookmarked');
  @override
  late final GeneratedColumn<bool> isBookmarked = GeneratedColumn<bool>(
      'is_bookmarked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_bookmarked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _observationCountMeta =
      const VerificationMeta('observationCount');
  @override
  late final GeneratedColumn<int> observationCount = GeneratedColumn<int>(
      'observation_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _cachedAtMeta =
      const VerificationMeta('cachedAt');
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
      'cached_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        commonName,
        scientificName,
        family,
        subfamily,
        primaryImageUrl,
        rarity,
        conservationStatus,
        descriptionShort,
        statesJson,
        isBookmarked,
        observationCount,
        cachedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_species';
  @override
  VerificationContext validateIntegrity(Insertable<CachedSpeciesRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('common_name')) {
      context.handle(
          _commonNameMeta,
          commonName.isAcceptableOrUnknown(
              data['common_name']!, _commonNameMeta));
    } else if (isInserting) {
      context.missing(_commonNameMeta);
    }
    if (data.containsKey('scientific_name')) {
      context.handle(
          _scientificNameMeta,
          scientificName.isAcceptableOrUnknown(
              data['scientific_name']!, _scientificNameMeta));
    } else if (isInserting) {
      context.missing(_scientificNameMeta);
    }
    if (data.containsKey('family')) {
      context.handle(_familyMeta,
          family.isAcceptableOrUnknown(data['family']!, _familyMeta));
    }
    if (data.containsKey('subfamily')) {
      context.handle(_subfamilyMeta,
          subfamily.isAcceptableOrUnknown(data['subfamily']!, _subfamilyMeta));
    }
    if (data.containsKey('primary_image_url')) {
      context.handle(
          _primaryImageUrlMeta,
          primaryImageUrl.isAcceptableOrUnknown(
              data['primary_image_url']!, _primaryImageUrlMeta));
    }
    if (data.containsKey('rarity')) {
      context.handle(_rarityMeta,
          rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta));
    }
    if (data.containsKey('conservation_status')) {
      context.handle(
          _conservationStatusMeta,
          conservationStatus.isAcceptableOrUnknown(
              data['conservation_status']!, _conservationStatusMeta));
    }
    if (data.containsKey('description_short')) {
      context.handle(
          _descriptionShortMeta,
          descriptionShort.isAcceptableOrUnknown(
              data['description_short']!, _descriptionShortMeta));
    }
    if (data.containsKey('states_json')) {
      context.handle(
          _statesJsonMeta,
          statesJson.isAcceptableOrUnknown(
              data['states_json']!, _statesJsonMeta));
    }
    if (data.containsKey('is_bookmarked')) {
      context.handle(
          _isBookmarkedMeta,
          isBookmarked.isAcceptableOrUnknown(
              data['is_bookmarked']!, _isBookmarkedMeta));
    }
    if (data.containsKey('observation_count')) {
      context.handle(
          _observationCountMeta,
          observationCount.isAcceptableOrUnknown(
              data['observation_count']!, _observationCountMeta));
    }
    if (data.containsKey('cached_at')) {
      context.handle(_cachedAtMeta,
          cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedSpeciesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedSpeciesRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      commonName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}common_name'])!,
      scientificName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}scientific_name'])!,
      family: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}family']),
      subfamily: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subfamily']),
      primaryImageUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}primary_image_url']),
      rarity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rarity']),
      conservationStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conservation_status']),
      descriptionShort: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}description_short']),
      statesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}states_json']),
      isBookmarked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_bookmarked'])!,
      observationCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}observation_count'])!,
      cachedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}cached_at'])!,
    );
  }

  @override
  $CachedSpeciesTableTable createAlias(String alias) {
    return $CachedSpeciesTableTable(attachedDatabase, alias);
  }
}

class CachedSpeciesRow extends DataClass
    implements Insertable<CachedSpeciesRow> {
  final String id;
  final String commonName;
  final String scientificName;
  final String? family;
  final String? subfamily;
  final String? primaryImageUrl;
  final String? rarity;
  final String? conservationStatus;
  final String? descriptionShort;
  final String? statesJson;
  final bool isBookmarked;
  final int observationCount;
  final DateTime cachedAt;
  const CachedSpeciesRow(
      {required this.id,
      required this.commonName,
      required this.scientificName,
      this.family,
      this.subfamily,
      this.primaryImageUrl,
      this.rarity,
      this.conservationStatus,
      this.descriptionShort,
      this.statesJson,
      required this.isBookmarked,
      required this.observationCount,
      required this.cachedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['common_name'] = Variable<String>(commonName);
    map['scientific_name'] = Variable<String>(scientificName);
    if (!nullToAbsent || family != null) {
      map['family'] = Variable<String>(family);
    }
    if (!nullToAbsent || subfamily != null) {
      map['subfamily'] = Variable<String>(subfamily);
    }
    if (!nullToAbsent || primaryImageUrl != null) {
      map['primary_image_url'] = Variable<String>(primaryImageUrl);
    }
    if (!nullToAbsent || rarity != null) {
      map['rarity'] = Variable<String>(rarity);
    }
    if (!nullToAbsent || conservationStatus != null) {
      map['conservation_status'] = Variable<String>(conservationStatus);
    }
    if (!nullToAbsent || descriptionShort != null) {
      map['description_short'] = Variable<String>(descriptionShort);
    }
    if (!nullToAbsent || statesJson != null) {
      map['states_json'] = Variable<String>(statesJson);
    }
    map['is_bookmarked'] = Variable<bool>(isBookmarked);
    map['observation_count'] = Variable<int>(observationCount);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CachedSpeciesTableCompanion toCompanion(bool nullToAbsent) {
    return CachedSpeciesTableCompanion(
      id: Value(id),
      commonName: Value(commonName),
      scientificName: Value(scientificName),
      family:
          family == null && nullToAbsent ? const Value.absent() : Value(family),
      subfamily: subfamily == null && nullToAbsent
          ? const Value.absent()
          : Value(subfamily),
      primaryImageUrl: primaryImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(primaryImageUrl),
      rarity:
          rarity == null && nullToAbsent ? const Value.absent() : Value(rarity),
      conservationStatus: conservationStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(conservationStatus),
      descriptionShort: descriptionShort == null && nullToAbsent
          ? const Value.absent()
          : Value(descriptionShort),
      statesJson: statesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(statesJson),
      isBookmarked: Value(isBookmarked),
      observationCount: Value(observationCount),
      cachedAt: Value(cachedAt),
    );
  }

  factory CachedSpeciesRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedSpeciesRow(
      id: serializer.fromJson<String>(json['id']),
      commonName: serializer.fromJson<String>(json['commonName']),
      scientificName: serializer.fromJson<String>(json['scientificName']),
      family: serializer.fromJson<String?>(json['family']),
      subfamily: serializer.fromJson<String?>(json['subfamily']),
      primaryImageUrl: serializer.fromJson<String?>(json['primaryImageUrl']),
      rarity: serializer.fromJson<String?>(json['rarity']),
      conservationStatus:
          serializer.fromJson<String?>(json['conservationStatus']),
      descriptionShort: serializer.fromJson<String?>(json['descriptionShort']),
      statesJson: serializer.fromJson<String?>(json['statesJson']),
      isBookmarked: serializer.fromJson<bool>(json['isBookmarked']),
      observationCount: serializer.fromJson<int>(json['observationCount']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'commonName': serializer.toJson<String>(commonName),
      'scientificName': serializer.toJson<String>(scientificName),
      'family': serializer.toJson<String?>(family),
      'subfamily': serializer.toJson<String?>(subfamily),
      'primaryImageUrl': serializer.toJson<String?>(primaryImageUrl),
      'rarity': serializer.toJson<String?>(rarity),
      'conservationStatus': serializer.toJson<String?>(conservationStatus),
      'descriptionShort': serializer.toJson<String?>(descriptionShort),
      'statesJson': serializer.toJson<String?>(statesJson),
      'isBookmarked': serializer.toJson<bool>(isBookmarked),
      'observationCount': serializer.toJson<int>(observationCount),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CachedSpeciesRow copyWith(
          {String? id,
          String? commonName,
          String? scientificName,
          Value<String?> family = const Value.absent(),
          Value<String?> subfamily = const Value.absent(),
          Value<String?> primaryImageUrl = const Value.absent(),
          Value<String?> rarity = const Value.absent(),
          Value<String?> conservationStatus = const Value.absent(),
          Value<String?> descriptionShort = const Value.absent(),
          Value<String?> statesJson = const Value.absent(),
          bool? isBookmarked,
          int? observationCount,
          DateTime? cachedAt}) =>
      CachedSpeciesRow(
        id: id ?? this.id,
        commonName: commonName ?? this.commonName,
        scientificName: scientificName ?? this.scientificName,
        family: family.present ? family.value : this.family,
        subfamily: subfamily.present ? subfamily.value : this.subfamily,
        primaryImageUrl: primaryImageUrl.present
            ? primaryImageUrl.value
            : this.primaryImageUrl,
        rarity: rarity.present ? rarity.value : this.rarity,
        conservationStatus: conservationStatus.present
            ? conservationStatus.value
            : this.conservationStatus,
        descriptionShort: descriptionShort.present
            ? descriptionShort.value
            : this.descriptionShort,
        statesJson: statesJson.present ? statesJson.value : this.statesJson,
        isBookmarked: isBookmarked ?? this.isBookmarked,
        observationCount: observationCount ?? this.observationCount,
        cachedAt: cachedAt ?? this.cachedAt,
      );
  CachedSpeciesRow copyWithCompanion(CachedSpeciesTableCompanion data) {
    return CachedSpeciesRow(
      id: data.id.present ? data.id.value : this.id,
      commonName:
          data.commonName.present ? data.commonName.value : this.commonName,
      scientificName: data.scientificName.present
          ? data.scientificName.value
          : this.scientificName,
      family: data.family.present ? data.family.value : this.family,
      subfamily: data.subfamily.present ? data.subfamily.value : this.subfamily,
      primaryImageUrl: data.primaryImageUrl.present
          ? data.primaryImageUrl.value
          : this.primaryImageUrl,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      conservationStatus: data.conservationStatus.present
          ? data.conservationStatus.value
          : this.conservationStatus,
      descriptionShort: data.descriptionShort.present
          ? data.descriptionShort.value
          : this.descriptionShort,
      statesJson:
          data.statesJson.present ? data.statesJson.value : this.statesJson,
      isBookmarked: data.isBookmarked.present
          ? data.isBookmarked.value
          : this.isBookmarked,
      observationCount: data.observationCount.present
          ? data.observationCount.value
          : this.observationCount,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedSpeciesRow(')
          ..write('id: $id, ')
          ..write('commonName: $commonName, ')
          ..write('scientificName: $scientificName, ')
          ..write('family: $family, ')
          ..write('subfamily: $subfamily, ')
          ..write('primaryImageUrl: $primaryImageUrl, ')
          ..write('rarity: $rarity, ')
          ..write('conservationStatus: $conservationStatus, ')
          ..write('descriptionShort: $descriptionShort, ')
          ..write('statesJson: $statesJson, ')
          ..write('isBookmarked: $isBookmarked, ')
          ..write('observationCount: $observationCount, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      commonName,
      scientificName,
      family,
      subfamily,
      primaryImageUrl,
      rarity,
      conservationStatus,
      descriptionShort,
      statesJson,
      isBookmarked,
      observationCount,
      cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedSpeciesRow &&
          other.id == this.id &&
          other.commonName == this.commonName &&
          other.scientificName == this.scientificName &&
          other.family == this.family &&
          other.subfamily == this.subfamily &&
          other.primaryImageUrl == this.primaryImageUrl &&
          other.rarity == this.rarity &&
          other.conservationStatus == this.conservationStatus &&
          other.descriptionShort == this.descriptionShort &&
          other.statesJson == this.statesJson &&
          other.isBookmarked == this.isBookmarked &&
          other.observationCount == this.observationCount &&
          other.cachedAt == this.cachedAt);
}

class CachedSpeciesTableCompanion extends UpdateCompanion<CachedSpeciesRow> {
  final Value<String> id;
  final Value<String> commonName;
  final Value<String> scientificName;
  final Value<String?> family;
  final Value<String?> subfamily;
  final Value<String?> primaryImageUrl;
  final Value<String?> rarity;
  final Value<String?> conservationStatus;
  final Value<String?> descriptionShort;
  final Value<String?> statesJson;
  final Value<bool> isBookmarked;
  final Value<int> observationCount;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CachedSpeciesTableCompanion({
    this.id = const Value.absent(),
    this.commonName = const Value.absent(),
    this.scientificName = const Value.absent(),
    this.family = const Value.absent(),
    this.subfamily = const Value.absent(),
    this.primaryImageUrl = const Value.absent(),
    this.rarity = const Value.absent(),
    this.conservationStatus = const Value.absent(),
    this.descriptionShort = const Value.absent(),
    this.statesJson = const Value.absent(),
    this.isBookmarked = const Value.absent(),
    this.observationCount = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedSpeciesTableCompanion.insert({
    required String id,
    required String commonName,
    required String scientificName,
    this.family = const Value.absent(),
    this.subfamily = const Value.absent(),
    this.primaryImageUrl = const Value.absent(),
    this.rarity = const Value.absent(),
    this.conservationStatus = const Value.absent(),
    this.descriptionShort = const Value.absent(),
    this.statesJson = const Value.absent(),
    this.isBookmarked = const Value.absent(),
    this.observationCount = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        commonName = Value(commonName),
        scientificName = Value(scientificName);
  static Insertable<CachedSpeciesRow> custom({
    Expression<String>? id,
    Expression<String>? commonName,
    Expression<String>? scientificName,
    Expression<String>? family,
    Expression<String>? subfamily,
    Expression<String>? primaryImageUrl,
    Expression<String>? rarity,
    Expression<String>? conservationStatus,
    Expression<String>? descriptionShort,
    Expression<String>? statesJson,
    Expression<bool>? isBookmarked,
    Expression<int>? observationCount,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (commonName != null) 'common_name': commonName,
      if (scientificName != null) 'scientific_name': scientificName,
      if (family != null) 'family': family,
      if (subfamily != null) 'subfamily': subfamily,
      if (primaryImageUrl != null) 'primary_image_url': primaryImageUrl,
      if (rarity != null) 'rarity': rarity,
      if (conservationStatus != null) 'conservation_status': conservationStatus,
      if (descriptionShort != null) 'description_short': descriptionShort,
      if (statesJson != null) 'states_json': statesJson,
      if (isBookmarked != null) 'is_bookmarked': isBookmarked,
      if (observationCount != null) 'observation_count': observationCount,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedSpeciesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? commonName,
      Value<String>? scientificName,
      Value<String?>? family,
      Value<String?>? subfamily,
      Value<String?>? primaryImageUrl,
      Value<String?>? rarity,
      Value<String?>? conservationStatus,
      Value<String?>? descriptionShort,
      Value<String?>? statesJson,
      Value<bool>? isBookmarked,
      Value<int>? observationCount,
      Value<DateTime>? cachedAt,
      Value<int>? rowid}) {
    return CachedSpeciesTableCompanion(
      id: id ?? this.id,
      commonName: commonName ?? this.commonName,
      scientificName: scientificName ?? this.scientificName,
      family: family ?? this.family,
      subfamily: subfamily ?? this.subfamily,
      primaryImageUrl: primaryImageUrl ?? this.primaryImageUrl,
      rarity: rarity ?? this.rarity,
      conservationStatus: conservationStatus ?? this.conservationStatus,
      descriptionShort: descriptionShort ?? this.descriptionShort,
      statesJson: statesJson ?? this.statesJson,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      observationCount: observationCount ?? this.observationCount,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (commonName.present) {
      map['common_name'] = Variable<String>(commonName.value);
    }
    if (scientificName.present) {
      map['scientific_name'] = Variable<String>(scientificName.value);
    }
    if (family.present) {
      map['family'] = Variable<String>(family.value);
    }
    if (subfamily.present) {
      map['subfamily'] = Variable<String>(subfamily.value);
    }
    if (primaryImageUrl.present) {
      map['primary_image_url'] = Variable<String>(primaryImageUrl.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (conservationStatus.present) {
      map['conservation_status'] = Variable<String>(conservationStatus.value);
    }
    if (descriptionShort.present) {
      map['description_short'] = Variable<String>(descriptionShort.value);
    }
    if (statesJson.present) {
      map['states_json'] = Variable<String>(statesJson.value);
    }
    if (isBookmarked.present) {
      map['is_bookmarked'] = Variable<bool>(isBookmarked.value);
    }
    if (observationCount.present) {
      map['observation_count'] = Variable<int>(observationCount.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedSpeciesTableCompanion(')
          ..write('id: $id, ')
          ..write('commonName: $commonName, ')
          ..write('scientificName: $scientificName, ')
          ..write('family: $family, ')
          ..write('subfamily: $subfamily, ')
          ..write('primaryImageUrl: $primaryImageUrl, ')
          ..write('rarity: $rarity, ')
          ..write('conservationStatus: $conservationStatus, ')
          ..write('descriptionShort: $descriptionShort, ')
          ..write('statesJson: $statesJson, ')
          ..write('isBookmarked: $isBookmarked, ')
          ..write('observationCount: $observationCount, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTableTable extends UserPreferencesTable
    with TableInfo<$UserPreferencesTableTable, UserPreferenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences';
  @override
  VerificationContext validateIntegrity(Insertable<UserPreferenceRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  UserPreferenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreferenceRow(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UserPreferencesTableTable createAlias(String alias) {
    return $UserPreferencesTableTable(attachedDatabase, alias);
  }
}

class UserPreferenceRow extends DataClass
    implements Insertable<UserPreferenceRow> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const UserPreferenceRow(
      {required this.key, required this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserPreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesTableCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserPreferenceRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreferenceRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserPreferenceRow copyWith(
          {String? key, String? value, DateTime? updatedAt}) =>
      UserPreferenceRow(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UserPreferenceRow copyWithCompanion(UserPreferencesTableCompanion data) {
    return UserPreferenceRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferenceRow(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreferenceRow &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class UserPreferencesTableCompanion extends UpdateCompanion<UserPreferenceRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserPreferencesTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPreferencesTableCompanion.insert({
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<UserPreferenceRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPreferencesTableCompanion copyWith(
      {Value<String>? key,
      Value<String>? value,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return UserPreferencesTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTableTable extends BookmarksTable
    with TableInfo<$BookmarksTableTable, BookmarkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
      'ref_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataJsonMeta =
      const VerificationMeta('dataJson');
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
      'data_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _savedAtMeta =
      const VerificationMeta('savedAt');
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
      'saved_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, type, refId, dataJson, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(Insertable<BookmarkRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
          _refIdMeta, refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta));
    } else if (isInserting) {
      context.missing(_refIdMeta);
    }
    if (data.containsKey('data_json')) {
      context.handle(_dataJsonMeta,
          dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta));
    }
    if (data.containsKey('saved_at')) {
      context.handle(_savedAtMeta,
          savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookmarkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      refId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ref_id'])!,
      dataJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data_json']),
      savedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}saved_at'])!,
    );
  }

  @override
  $BookmarksTableTable createAlias(String alias) {
    return $BookmarksTableTable(attachedDatabase, alias);
  }
}

class BookmarkRow extends DataClass implements Insertable<BookmarkRow> {
  final int id;
  final String type;
  final String refId;
  final String? dataJson;
  final DateTime savedAt;
  const BookmarkRow(
      {required this.id,
      required this.type,
      required this.refId,
      this.dataJson,
      required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['ref_id'] = Variable<String>(refId);
    if (!nullToAbsent || dataJson != null) {
      map['data_json'] = Variable<String>(dataJson);
    }
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  BookmarksTableCompanion toCompanion(bool nullToAbsent) {
    return BookmarksTableCompanion(
      id: Value(id),
      type: Value(type),
      refId: Value(refId),
      dataJson: dataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(dataJson),
      savedAt: Value(savedAt),
    );
  }

  factory BookmarkRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkRow(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      refId: serializer.fromJson<String>(json['refId']),
      dataJson: serializer.fromJson<String?>(json['dataJson']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'refId': serializer.toJson<String>(refId),
      'dataJson': serializer.toJson<String?>(dataJson),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  BookmarkRow copyWith(
          {int? id,
          String? type,
          String? refId,
          Value<String?> dataJson = const Value.absent(),
          DateTime? savedAt}) =>
      BookmarkRow(
        id: id ?? this.id,
        type: type ?? this.type,
        refId: refId ?? this.refId,
        dataJson: dataJson.present ? dataJson.value : this.dataJson,
        savedAt: savedAt ?? this.savedAt,
      );
  BookmarkRow copyWithCompanion(BookmarksTableCompanion data) {
    return BookmarkRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      refId: data.refId.present ? data.refId.value : this.refId,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('refId: $refId, ')
          ..write('dataJson: $dataJson, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, refId, dataJson, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.refId == this.refId &&
          other.dataJson == this.dataJson &&
          other.savedAt == this.savedAt);
}

class BookmarksTableCompanion extends UpdateCompanion<BookmarkRow> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> refId;
  final Value<String?> dataJson;
  final Value<DateTime> savedAt;
  const BookmarksTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.refId = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.savedAt = const Value.absent(),
  });
  BookmarksTableCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String refId,
    this.dataJson = const Value.absent(),
    this.savedAt = const Value.absent(),
  })  : type = Value(type),
        refId = Value(refId);
  static Insertable<BookmarkRow> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? refId,
    Expression<String>? dataJson,
    Expression<DateTime>? savedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (refId != null) 'ref_id': refId,
      if (dataJson != null) 'data_json': dataJson,
      if (savedAt != null) 'saved_at': savedAt,
    });
  }

  BookmarksTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<String>? refId,
      Value<String?>? dataJson,
      Value<DateTime>? savedAt}) {
    return BookmarksTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      refId: refId ?? this.refId,
      dataJson: dataJson ?? this.dataJson,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('refId: $refId, ')
          ..write('dataJson: $dataJson, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CachedObservationsTableTable cachedObservationsTable =
      $CachedObservationsTableTable(this);
  late final $OfflineQueueTableTable offlineQueueTable =
      $OfflineQueueTableTable(this);
  late final $CachedSpeciesTableTable cachedSpeciesTable =
      $CachedSpeciesTableTable(this);
  late final $UserPreferencesTableTable userPreferencesTable =
      $UserPreferencesTableTable(this);
  late final $BookmarksTableTable bookmarksTable = $BookmarksTableTable(this);
  late final ObservationsDao observationsDao =
      ObservationsDao(this as AppDatabase);
  late final SpeciesDao speciesDao = SpeciesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        cachedObservationsTable,
        offlineQueueTable,
        cachedSpeciesTable,
        userPreferencesTable,
        bookmarksTable
      ];
}

typedef $$CachedObservationsTableTableCreateCompanionBuilder
    = CachedObservationsTableCompanion Function({
  required String id,
  Value<String?> userId,
  Value<String?> title,
  Value<String?> notes,
  Value<int?> stateId,
  Value<String?> stateName,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> locationName,
  Value<String> privacy,
  Value<String> status,
  Value<String?> identificationStatus,
  Value<String?> identifiedSpeciesId,
  Value<String?> identifiedSpeciesName,
  Value<double?> identificationConfidence,
  Value<String?> primaryImageUrl,
  Value<String?> imageUrlsJson,
  Value<DateTime?> observedAt,
  Value<DateTime> createdAt,
  Value<DateTime> cachedAt,
  Value<bool> isSynced,
  Value<int> likeCount,
  Value<int> commentCount,
  Value<int> rowid,
});
typedef $$CachedObservationsTableTableUpdateCompanionBuilder
    = CachedObservationsTableCompanion Function({
  Value<String> id,
  Value<String?> userId,
  Value<String?> title,
  Value<String?> notes,
  Value<int?> stateId,
  Value<String?> stateName,
  Value<double?> latitude,
  Value<double?> longitude,
  Value<String?> locationName,
  Value<String> privacy,
  Value<String> status,
  Value<String?> identificationStatus,
  Value<String?> identifiedSpeciesId,
  Value<String?> identifiedSpeciesName,
  Value<double?> identificationConfidence,
  Value<String?> primaryImageUrl,
  Value<String?> imageUrlsJson,
  Value<DateTime?> observedAt,
  Value<DateTime> createdAt,
  Value<DateTime> cachedAt,
  Value<bool> isSynced,
  Value<int> likeCount,
  Value<int> commentCount,
  Value<int> rowid,
});

class $$CachedObservationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CachedObservationsTableTable> {
  $$CachedObservationsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stateId => $composableBuilder(
      column: $table.stateId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get stateName => $composableBuilder(
      column: $table.stateName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get privacy => $composableBuilder(
      column: $table.privacy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get identificationStatus => $composableBuilder(
      column: $table.identificationStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get identifiedSpeciesId => $composableBuilder(
      column: $table.identifiedSpeciesId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get identifiedSpeciesName => $composableBuilder(
      column: $table.identifiedSpeciesName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get identificationConfidence => $composableBuilder(
      column: $table.identificationConfidence,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primaryImageUrl => $composableBuilder(
      column: $table.primaryImageUrl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrlsJson => $composableBuilder(
      column: $table.imageUrlsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get observedAt => $composableBuilder(
      column: $table.observedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get likeCount => $composableBuilder(
      column: $table.likeCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get commentCount => $composableBuilder(
      column: $table.commentCount, builder: (column) => ColumnFilters(column));
}

class $$CachedObservationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedObservationsTableTable> {
  $$CachedObservationsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stateId => $composableBuilder(
      column: $table.stateId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stateName => $composableBuilder(
      column: $table.stateName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get latitude => $composableBuilder(
      column: $table.latitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get longitude => $composableBuilder(
      column: $table.longitude, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationName => $composableBuilder(
      column: $table.locationName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get privacy => $composableBuilder(
      column: $table.privacy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get identificationStatus => $composableBuilder(
      column: $table.identificationStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get identifiedSpeciesId => $composableBuilder(
      column: $table.identifiedSpeciesId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get identifiedSpeciesName => $composableBuilder(
      column: $table.identifiedSpeciesName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get identificationConfidence => $composableBuilder(
      column: $table.identificationConfidence,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryImageUrl => $composableBuilder(
      column: $table.primaryImageUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrlsJson => $composableBuilder(
      column: $table.imageUrlsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get observedAt => $composableBuilder(
      column: $table.observedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get likeCount => $composableBuilder(
      column: $table.likeCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get commentCount => $composableBuilder(
      column: $table.commentCount,
      builder: (column) => ColumnOrderings(column));
}

class $$CachedObservationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedObservationsTableTable> {
  $$CachedObservationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get stateId =>
      $composableBuilder(column: $table.stateId, builder: (column) => column);

  GeneratedColumn<String> get stateName =>
      $composableBuilder(column: $table.stateName, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get locationName => $composableBuilder(
      column: $table.locationName, builder: (column) => column);

  GeneratedColumn<String> get privacy =>
      $composableBuilder(column: $table.privacy, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get identificationStatus => $composableBuilder(
      column: $table.identificationStatus, builder: (column) => column);

  GeneratedColumn<String> get identifiedSpeciesId => $composableBuilder(
      column: $table.identifiedSpeciesId, builder: (column) => column);

  GeneratedColumn<String> get identifiedSpeciesName => $composableBuilder(
      column: $table.identifiedSpeciesName, builder: (column) => column);

  GeneratedColumn<double> get identificationConfidence => $composableBuilder(
      column: $table.identificationConfidence, builder: (column) => column);

  GeneratedColumn<String> get primaryImageUrl => $composableBuilder(
      column: $table.primaryImageUrl, builder: (column) => column);

  GeneratedColumn<String> get imageUrlsJson => $composableBuilder(
      column: $table.imageUrlsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get observedAt => $composableBuilder(
      column: $table.observedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<int> get likeCount =>
      $composableBuilder(column: $table.likeCount, builder: (column) => column);

  GeneratedColumn<int> get commentCount => $composableBuilder(
      column: $table.commentCount, builder: (column) => column);
}

class $$CachedObservationsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedObservationsTableTable,
    CachedObservationRow,
    $$CachedObservationsTableTableFilterComposer,
    $$CachedObservationsTableTableOrderingComposer,
    $$CachedObservationsTableTableAnnotationComposer,
    $$CachedObservationsTableTableCreateCompanionBuilder,
    $$CachedObservationsTableTableUpdateCompanionBuilder,
    (
      CachedObservationRow,
      BaseReferences<_$AppDatabase, $CachedObservationsTableTable,
          CachedObservationRow>
    ),
    CachedObservationRow,
    PrefetchHooks Function()> {
  $$CachedObservationsTableTableTableManager(
      _$AppDatabase db, $CachedObservationsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedObservationsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedObservationsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedObservationsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> userId = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> stateId = const Value.absent(),
            Value<String?> stateName = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<String?> locationName = const Value.absent(),
            Value<String> privacy = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> identificationStatus = const Value.absent(),
            Value<String?> identifiedSpeciesId = const Value.absent(),
            Value<String?> identifiedSpeciesName = const Value.absent(),
            Value<double?> identificationConfidence = const Value.absent(),
            Value<String?> primaryImageUrl = const Value.absent(),
            Value<String?> imageUrlsJson = const Value.absent(),
            Value<DateTime?> observedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> likeCount = const Value.absent(),
            Value<int> commentCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedObservationsTableCompanion(
            id: id,
            userId: userId,
            title: title,
            notes: notes,
            stateId: stateId,
            stateName: stateName,
            latitude: latitude,
            longitude: longitude,
            locationName: locationName,
            privacy: privacy,
            status: status,
            identificationStatus: identificationStatus,
            identifiedSpeciesId: identifiedSpeciesId,
            identifiedSpeciesName: identifiedSpeciesName,
            identificationConfidence: identificationConfidence,
            primaryImageUrl: primaryImageUrl,
            imageUrlsJson: imageUrlsJson,
            observedAt: observedAt,
            createdAt: createdAt,
            cachedAt: cachedAt,
            isSynced: isSynced,
            likeCount: likeCount,
            commentCount: commentCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> userId = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> stateId = const Value.absent(),
            Value<String?> stateName = const Value.absent(),
            Value<double?> latitude = const Value.absent(),
            Value<double?> longitude = const Value.absent(),
            Value<String?> locationName = const Value.absent(),
            Value<String> privacy = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> identificationStatus = const Value.absent(),
            Value<String?> identifiedSpeciesId = const Value.absent(),
            Value<String?> identifiedSpeciesName = const Value.absent(),
            Value<double?> identificationConfidence = const Value.absent(),
            Value<String?> primaryImageUrl = const Value.absent(),
            Value<String?> imageUrlsJson = const Value.absent(),
            Value<DateTime?> observedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> likeCount = const Value.absent(),
            Value<int> commentCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedObservationsTableCompanion.insert(
            id: id,
            userId: userId,
            title: title,
            notes: notes,
            stateId: stateId,
            stateName: stateName,
            latitude: latitude,
            longitude: longitude,
            locationName: locationName,
            privacy: privacy,
            status: status,
            identificationStatus: identificationStatus,
            identifiedSpeciesId: identifiedSpeciesId,
            identifiedSpeciesName: identifiedSpeciesName,
            identificationConfidence: identificationConfidence,
            primaryImageUrl: primaryImageUrl,
            imageUrlsJson: imageUrlsJson,
            observedAt: observedAt,
            createdAt: createdAt,
            cachedAt: cachedAt,
            isSynced: isSynced,
            likeCount: likeCount,
            commentCount: commentCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedObservationsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CachedObservationsTableTable,
        CachedObservationRow,
        $$CachedObservationsTableTableFilterComposer,
        $$CachedObservationsTableTableOrderingComposer,
        $$CachedObservationsTableTableAnnotationComposer,
        $$CachedObservationsTableTableCreateCompanionBuilder,
        $$CachedObservationsTableTableUpdateCompanionBuilder,
        (
          CachedObservationRow,
          BaseReferences<_$AppDatabase, $CachedObservationsTableTable,
              CachedObservationRow>
        ),
        CachedObservationRow,
        PrefetchHooks Function()>;
typedef $$OfflineQueueTableTableCreateCompanionBuilder
    = OfflineQueueTableCompanion Function({
  Value<int> localId,
  required String type,
  required String payload,
  required String endpoint,
  Value<String> httpMethod,
  Value<int> retryCount,
  Value<int> maxRetries,
  Value<bool> hasImages,
  Value<String?> localImagePaths,
  Value<String> status,
  Value<String?> errorMessage,
  Value<DateTime> createdAt,
  Value<DateTime?> lastAttemptAt,
});
typedef $$OfflineQueueTableTableUpdateCompanionBuilder
    = OfflineQueueTableCompanion Function({
  Value<int> localId,
  Value<String> type,
  Value<String> payload,
  Value<String> endpoint,
  Value<String> httpMethod,
  Value<int> retryCount,
  Value<int> maxRetries,
  Value<bool> hasImages,
  Value<String?> localImagePaths,
  Value<String> status,
  Value<String?> errorMessage,
  Value<DateTime> createdAt,
  Value<DateTime?> lastAttemptAt,
});

class $$OfflineQueueTableTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineQueueTableTable> {
  $$OfflineQueueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endpoint => $composableBuilder(
      column: $table.endpoint, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get httpMethod => $composableBuilder(
      column: $table.httpMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxRetries => $composableBuilder(
      column: $table.maxRetries, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasImages => $composableBuilder(
      column: $table.hasImages, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localImagePaths => $composableBuilder(
      column: $table.localImagePaths,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => ColumnFilters(column));
}

class $$OfflineQueueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineQueueTableTable> {
  $$OfflineQueueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endpoint => $composableBuilder(
      column: $table.endpoint, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get httpMethod => $composableBuilder(
      column: $table.httpMethod, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxRetries => $composableBuilder(
      column: $table.maxRetries, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasImages => $composableBuilder(
      column: $table.hasImages, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localImagePaths => $composableBuilder(
      column: $table.localImagePaths,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt,
      builder: (column) => ColumnOrderings(column));
}

class $$OfflineQueueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineQueueTableTable> {
  $$OfflineQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get endpoint =>
      $composableBuilder(column: $table.endpoint, builder: (column) => column);

  GeneratedColumn<String> get httpMethod => $composableBuilder(
      column: $table.httpMethod, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<int> get maxRetries => $composableBuilder(
      column: $table.maxRetries, builder: (column) => column);

  GeneratedColumn<bool> get hasImages =>
      $composableBuilder(column: $table.hasImages, builder: (column) => column);

  GeneratedColumn<String> get localImagePaths => $composableBuilder(
      column: $table.localImagePaths, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => column);
}

class $$OfflineQueueTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OfflineQueueTableTable,
    OfflineQueueRow,
    $$OfflineQueueTableTableFilterComposer,
    $$OfflineQueueTableTableOrderingComposer,
    $$OfflineQueueTableTableAnnotationComposer,
    $$OfflineQueueTableTableCreateCompanionBuilder,
    $$OfflineQueueTableTableUpdateCompanionBuilder,
    (
      OfflineQueueRow,
      BaseReferences<_$AppDatabase, $OfflineQueueTableTable, OfflineQueueRow>
    ),
    OfflineQueueRow,
    PrefetchHooks Function()> {
  $$OfflineQueueTableTableTableManager(
      _$AppDatabase db, $OfflineQueueTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineQueueTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> localId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<String> endpoint = const Value.absent(),
            Value<String> httpMethod = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<int> maxRetries = const Value.absent(),
            Value<bool> hasImages = const Value.absent(),
            Value<String?> localImagePaths = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
          }) =>
              OfflineQueueTableCompanion(
            localId: localId,
            type: type,
            payload: payload,
            endpoint: endpoint,
            httpMethod: httpMethod,
            retryCount: retryCount,
            maxRetries: maxRetries,
            hasImages: hasImages,
            localImagePaths: localImagePaths,
            status: status,
            errorMessage: errorMessage,
            createdAt: createdAt,
            lastAttemptAt: lastAttemptAt,
          ),
          createCompanionCallback: ({
            Value<int> localId = const Value.absent(),
            required String type,
            required String payload,
            required String endpoint,
            Value<String> httpMethod = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<int> maxRetries = const Value.absent(),
            Value<bool> hasImages = const Value.absent(),
            Value<String?> localImagePaths = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
          }) =>
              OfflineQueueTableCompanion.insert(
            localId: localId,
            type: type,
            payload: payload,
            endpoint: endpoint,
            httpMethod: httpMethod,
            retryCount: retryCount,
            maxRetries: maxRetries,
            hasImages: hasImages,
            localImagePaths: localImagePaths,
            status: status,
            errorMessage: errorMessage,
            createdAt: createdAt,
            lastAttemptAt: lastAttemptAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OfflineQueueTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OfflineQueueTableTable,
    OfflineQueueRow,
    $$OfflineQueueTableTableFilterComposer,
    $$OfflineQueueTableTableOrderingComposer,
    $$OfflineQueueTableTableAnnotationComposer,
    $$OfflineQueueTableTableCreateCompanionBuilder,
    $$OfflineQueueTableTableUpdateCompanionBuilder,
    (
      OfflineQueueRow,
      BaseReferences<_$AppDatabase, $OfflineQueueTableTable, OfflineQueueRow>
    ),
    OfflineQueueRow,
    PrefetchHooks Function()>;
typedef $$CachedSpeciesTableTableCreateCompanionBuilder
    = CachedSpeciesTableCompanion Function({
  required String id,
  required String commonName,
  required String scientificName,
  Value<String?> family,
  Value<String?> subfamily,
  Value<String?> primaryImageUrl,
  Value<String?> rarity,
  Value<String?> conservationStatus,
  Value<String?> descriptionShort,
  Value<String?> statesJson,
  Value<bool> isBookmarked,
  Value<int> observationCount,
  Value<DateTime> cachedAt,
  Value<int> rowid,
});
typedef $$CachedSpeciesTableTableUpdateCompanionBuilder
    = CachedSpeciesTableCompanion Function({
  Value<String> id,
  Value<String> commonName,
  Value<String> scientificName,
  Value<String?> family,
  Value<String?> subfamily,
  Value<String?> primaryImageUrl,
  Value<String?> rarity,
  Value<String?> conservationStatus,
  Value<String?> descriptionShort,
  Value<String?> statesJson,
  Value<bool> isBookmarked,
  Value<int> observationCount,
  Value<DateTime> cachedAt,
  Value<int> rowid,
});

class $$CachedSpeciesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CachedSpeciesTableTable> {
  $$CachedSpeciesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get commonName => $composableBuilder(
      column: $table.commonName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scientificName => $composableBuilder(
      column: $table.scientificName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get family => $composableBuilder(
      column: $table.family, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subfamily => $composableBuilder(
      column: $table.subfamily, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get primaryImageUrl => $composableBuilder(
      column: $table.primaryImageUrl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conservationStatus => $composableBuilder(
      column: $table.conservationStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descriptionShort => $composableBuilder(
      column: $table.descriptionShort,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get statesJson => $composableBuilder(
      column: $table.statesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBookmarked => $composableBuilder(
      column: $table.isBookmarked, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get observationCount => $composableBuilder(
      column: $table.observationCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnFilters(column));
}

class $$CachedSpeciesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedSpeciesTableTable> {
  $$CachedSpeciesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get commonName => $composableBuilder(
      column: $table.commonName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scientificName => $composableBuilder(
      column: $table.scientificName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get family => $composableBuilder(
      column: $table.family, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subfamily => $composableBuilder(
      column: $table.subfamily, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryImageUrl => $composableBuilder(
      column: $table.primaryImageUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conservationStatus => $composableBuilder(
      column: $table.conservationStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descriptionShort => $composableBuilder(
      column: $table.descriptionShort,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get statesJson => $composableBuilder(
      column: $table.statesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBookmarked => $composableBuilder(
      column: $table.isBookmarked,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get observationCount => $composableBuilder(
      column: $table.observationCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
      column: $table.cachedAt, builder: (column) => ColumnOrderings(column));
}

class $$CachedSpeciesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedSpeciesTableTable> {
  $$CachedSpeciesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get commonName => $composableBuilder(
      column: $table.commonName, builder: (column) => column);

  GeneratedColumn<String> get scientificName => $composableBuilder(
      column: $table.scientificName, builder: (column) => column);

  GeneratedColumn<String> get family =>
      $composableBuilder(column: $table.family, builder: (column) => column);

  GeneratedColumn<String> get subfamily =>
      $composableBuilder(column: $table.subfamily, builder: (column) => column);

  GeneratedColumn<String> get primaryImageUrl => $composableBuilder(
      column: $table.primaryImageUrl, builder: (column) => column);

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<String> get conservationStatus => $composableBuilder(
      column: $table.conservationStatus, builder: (column) => column);

  GeneratedColumn<String> get descriptionShort => $composableBuilder(
      column: $table.descriptionShort, builder: (column) => column);

  GeneratedColumn<String> get statesJson => $composableBuilder(
      column: $table.statesJson, builder: (column) => column);

  GeneratedColumn<bool> get isBookmarked => $composableBuilder(
      column: $table.isBookmarked, builder: (column) => column);

  GeneratedColumn<int> get observationCount => $composableBuilder(
      column: $table.observationCount, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CachedSpeciesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CachedSpeciesTableTable,
    CachedSpeciesRow,
    $$CachedSpeciesTableTableFilterComposer,
    $$CachedSpeciesTableTableOrderingComposer,
    $$CachedSpeciesTableTableAnnotationComposer,
    $$CachedSpeciesTableTableCreateCompanionBuilder,
    $$CachedSpeciesTableTableUpdateCompanionBuilder,
    (
      CachedSpeciesRow,
      BaseReferences<_$AppDatabase, $CachedSpeciesTableTable, CachedSpeciesRow>
    ),
    CachedSpeciesRow,
    PrefetchHooks Function()> {
  $$CachedSpeciesTableTableTableManager(
      _$AppDatabase db, $CachedSpeciesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedSpeciesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedSpeciesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedSpeciesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> commonName = const Value.absent(),
            Value<String> scientificName = const Value.absent(),
            Value<String?> family = const Value.absent(),
            Value<String?> subfamily = const Value.absent(),
            Value<String?> primaryImageUrl = const Value.absent(),
            Value<String?> rarity = const Value.absent(),
            Value<String?> conservationStatus = const Value.absent(),
            Value<String?> descriptionShort = const Value.absent(),
            Value<String?> statesJson = const Value.absent(),
            Value<bool> isBookmarked = const Value.absent(),
            Value<int> observationCount = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedSpeciesTableCompanion(
            id: id,
            commonName: commonName,
            scientificName: scientificName,
            family: family,
            subfamily: subfamily,
            primaryImageUrl: primaryImageUrl,
            rarity: rarity,
            conservationStatus: conservationStatus,
            descriptionShort: descriptionShort,
            statesJson: statesJson,
            isBookmarked: isBookmarked,
            observationCount: observationCount,
            cachedAt: cachedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String commonName,
            required String scientificName,
            Value<String?> family = const Value.absent(),
            Value<String?> subfamily = const Value.absent(),
            Value<String?> primaryImageUrl = const Value.absent(),
            Value<String?> rarity = const Value.absent(),
            Value<String?> conservationStatus = const Value.absent(),
            Value<String?> descriptionShort = const Value.absent(),
            Value<String?> statesJson = const Value.absent(),
            Value<bool> isBookmarked = const Value.absent(),
            Value<int> observationCount = const Value.absent(),
            Value<DateTime> cachedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CachedSpeciesTableCompanion.insert(
            id: id,
            commonName: commonName,
            scientificName: scientificName,
            family: family,
            subfamily: subfamily,
            primaryImageUrl: primaryImageUrl,
            rarity: rarity,
            conservationStatus: conservationStatus,
            descriptionShort: descriptionShort,
            statesJson: statesJson,
            isBookmarked: isBookmarked,
            observationCount: observationCount,
            cachedAt: cachedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CachedSpeciesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CachedSpeciesTableTable,
    CachedSpeciesRow,
    $$CachedSpeciesTableTableFilterComposer,
    $$CachedSpeciesTableTableOrderingComposer,
    $$CachedSpeciesTableTableAnnotationComposer,
    $$CachedSpeciesTableTableCreateCompanionBuilder,
    $$CachedSpeciesTableTableUpdateCompanionBuilder,
    (
      CachedSpeciesRow,
      BaseReferences<_$AppDatabase, $CachedSpeciesTableTable, CachedSpeciesRow>
    ),
    CachedSpeciesRow,
    PrefetchHooks Function()>;
typedef $$UserPreferencesTableTableCreateCompanionBuilder
    = UserPreferencesTableCompanion Function({
  required String key,
  required String value,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$UserPreferencesTableTableUpdateCompanionBuilder
    = UserPreferencesTableCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$UserPreferencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UserPreferencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UserPreferencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserPreferencesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserPreferencesTableTable,
    UserPreferenceRow,
    $$UserPreferencesTableTableFilterComposer,
    $$UserPreferencesTableTableOrderingComposer,
    $$UserPreferencesTableTableAnnotationComposer,
    $$UserPreferencesTableTableCreateCompanionBuilder,
    $$UserPreferencesTableTableUpdateCompanionBuilder,
    (
      UserPreferenceRow,
      BaseReferences<_$AppDatabase, $UserPreferencesTableTable,
          UserPreferenceRow>
    ),
    UserPreferenceRow,
    PrefetchHooks Function()> {
  $$UserPreferencesTableTableTableManager(
      _$AppDatabase db, $UserPreferencesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserPreferencesTableCompanion(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UserPreferencesTableCompanion.insert(
            key: key,
            value: value,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserPreferencesTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $UserPreferencesTableTable,
        UserPreferenceRow,
        $$UserPreferencesTableTableFilterComposer,
        $$UserPreferencesTableTableOrderingComposer,
        $$UserPreferencesTableTableAnnotationComposer,
        $$UserPreferencesTableTableCreateCompanionBuilder,
        $$UserPreferencesTableTableUpdateCompanionBuilder,
        (
          UserPreferenceRow,
          BaseReferences<_$AppDatabase, $UserPreferencesTableTable,
              UserPreferenceRow>
        ),
        UserPreferenceRow,
        PrefetchHooks Function()>;
typedef $$BookmarksTableTableCreateCompanionBuilder = BookmarksTableCompanion
    Function({
  Value<int> id,
  required String type,
  required String refId,
  Value<String?> dataJson,
  Value<DateTime> savedAt,
});
typedef $$BookmarksTableTableUpdateCompanionBuilder = BookmarksTableCompanion
    Function({
  Value<int> id,
  Value<String> type,
  Value<String> refId,
  Value<String?> dataJson,
  Value<DateTime> savedAt,
});

class $$BookmarksTableTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTableTable> {
  $$BookmarksTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get refId => $composableBuilder(
      column: $table.refId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dataJson => $composableBuilder(
      column: $table.dataJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnFilters(column));
}

class $$BookmarksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTableTable> {
  $$BookmarksTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get refId => $composableBuilder(
      column: $table.refId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dataJson => $composableBuilder(
      column: $table.dataJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
      column: $table.savedAt, builder: (column) => ColumnOrderings(column));
}

class $$BookmarksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTableTable> {
  $$BookmarksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);
}

class $$BookmarksTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BookmarksTableTable,
    BookmarkRow,
    $$BookmarksTableTableFilterComposer,
    $$BookmarksTableTableOrderingComposer,
    $$BookmarksTableTableAnnotationComposer,
    $$BookmarksTableTableCreateCompanionBuilder,
    $$BookmarksTableTableUpdateCompanionBuilder,
    (
      BookmarkRow,
      BaseReferences<_$AppDatabase, $BookmarksTableTable, BookmarkRow>
    ),
    BookmarkRow,
    PrefetchHooks Function()> {
  $$BookmarksTableTableTableManager(
      _$AppDatabase db, $BookmarksTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> refId = const Value.absent(),
            Value<String?> dataJson = const Value.absent(),
            Value<DateTime> savedAt = const Value.absent(),
          }) =>
              BookmarksTableCompanion(
            id: id,
            type: type,
            refId: refId,
            dataJson: dataJson,
            savedAt: savedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String type,
            required String refId,
            Value<String?> dataJson = const Value.absent(),
            Value<DateTime> savedAt = const Value.absent(),
          }) =>
              BookmarksTableCompanion.insert(
            id: id,
            type: type,
            refId: refId,
            dataJson: dataJson,
            savedAt: savedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BookmarksTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BookmarksTableTable,
    BookmarkRow,
    $$BookmarksTableTableFilterComposer,
    $$BookmarksTableTableOrderingComposer,
    $$BookmarksTableTableAnnotationComposer,
    $$BookmarksTableTableCreateCompanionBuilder,
    $$BookmarksTableTableUpdateCompanionBuilder,
    (
      BookmarkRow,
      BaseReferences<_$AppDatabase, $BookmarksTableTable, BookmarkRow>
    ),
    BookmarkRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CachedObservationsTableTableTableManager get cachedObservationsTable =>
      $$CachedObservationsTableTableTableManager(
          _db, _db.cachedObservationsTable);
  $$OfflineQueueTableTableTableManager get offlineQueueTable =>
      $$OfflineQueueTableTableTableManager(_db, _db.offlineQueueTable);
  $$CachedSpeciesTableTableTableManager get cachedSpeciesTable =>
      $$CachedSpeciesTableTableTableManager(_db, _db.cachedSpeciesTable);
  $$UserPreferencesTableTableTableManager get userPreferencesTable =>
      $$UserPreferencesTableTableTableManager(_db, _db.userPreferencesTable);
  $$BookmarksTableTableTableManager get bookmarksTable =>
      $$BookmarksTableTableTableManager(_db, _db.bookmarksTable);
}
