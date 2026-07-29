import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../observations/presentation/providers/observation_providers.dart';
import '../../../species/presentation/providers/species_providers.dart';
import '../../data/classifier/butterfly_classifier.dart';
import '../../data/datasources/ai_remote_datasource.dart';
import '../../data/models/ai_result.dart';
import '../../data/repositories/ai_repository.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AI PROVIDERS
/// ─────────────────────────────────────────────────────────────────────────────

final aiRemoteDataSourceProvider = Provider<IAiRemoteDataSource>(
  (ref) => AiRemoteDataSource(dio: ref.read(dioProvider)),
  name: 'aiRemoteDataSource',
);

/// On-device TFLite classifier (kept alive for the session; disposed with the
/// provider container).
final butterflyClassifierProvider = Provider<IButterflyClassifier>(
  (ref) {
    final classifier = TFLiteButterflyClassifier();
    ref.onDispose(classifier.dispose);
    return classifier;
  },
  name: 'butterflyClassifier',
);

final aiRepositoryProvider = Provider<IAiRepository>(
  (ref) => AiRepository(
    observationRemote: ref.read(observationRemoteDataSourceProvider),
    aiRemote: ref.read(aiRemoteDataSourceProvider),
    classifier: ref.read(butterflyClassifierProvider),
    speciesRepository: ref.read(speciesRepositoryProvider),
    connectivity: ref.read(connectivityServiceProvider),
  ),
  name: 'aiRepository',
);

// ── Scan state machine ───────────────────────────────────────────────────────

enum ScanStatus { idle, processing, success, error }

class AiScanState {
  const AiScanState({
    this.status = ScanStatus.idle,
    this.stage,
    this.scan,
    this.error,
    this.isRateLimited = false,
  });

  final ScanStatus status;
  final ScanStage? stage;
  final AiScanResult? scan;
  final String? error;

  /// The daily identification limit was hit — retrying now is pointless.
  final bool isRateLimited;

  bool get isProcessing => status == ScanStatus.processing;
  AiResult? get result => scan?.result;

  AiScanState copyWith({
    ScanStatus? status,
    ScanStage? stage,
    AiScanResult? scan,
    String? error,
    bool? isRateLimited,
  }) =>
      AiScanState(
        status: status ?? this.status,
        stage: stage ?? this.stage,
        scan: scan ?? this.scan,
        error: error,
        isRateLimited: isRateLimited ?? this.isRateLimited,
      );
}

class AiScanNotifier extends StateNotifier<AiScanState> {
  AiScanNotifier(this._repository) : super(const AiScanState());

  final IAiRepository _repository;

  Future<void> identify({
    required File image,
    required int stateId,
    required String privacy,
    double? latitude,
    double? longitude,
  }) async {
    state = const AiScanState(
      status: ScanStatus.processing,
      stage: ScanStage.compressing,
    );

    final result = await _repository.identifyFromImage(
      image: image,
      stateId: stateId,
      privacy: privacy,
      latitude: latitude,
      longitude: longitude,
      onProgress: (stage) =>
          state = state.copyWith(status: ScanStatus.processing, stage: stage),
    );

    state = result.fold(
      (failure) => AiScanState(
        status: ScanStatus.error,
        error: failure.message,
        isRateLimited: failure is RateLimitFailure,
      ),
      (scan) => AiScanState(status: ScanStatus.success, scan: scan),
    );
  }

  void reset() => state = const AiScanState();
}

final aiScanNotifierProvider =
    StateNotifierProvider.autoDispose<AiScanNotifier, AiScanState>(
  (ref) => AiScanNotifier(ref.read(aiRepositoryProvider)),
  name: 'aiScanNotifier',
);
