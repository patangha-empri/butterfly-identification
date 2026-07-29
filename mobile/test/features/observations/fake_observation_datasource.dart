import 'dart:io';
import 'package:butterfly_india/features/ai_identification/data/models/ai_result.dart';
import 'package:butterfly_india/features/home/data/models/observation_summary.dart';
import 'package:butterfly_india/features/observations/data/datasources/observation_remote_datasource.dart';
import 'package:butterfly_india/features/observations/data/models/observation.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FAKE OBSERVATION REMOTE DATASOURCE
/// ─────────────────────────────────────────────────────────────────────────────

class FakeObservationRemoteDataSource implements IObservationRemoteDataSource {
  FakeObservationRemoteDataSource({this.fail = false});

  bool fail;
  int createCalls = 0;
  int uploadCalls = 0;
  int identifyCalls = 0;
  int deleteCalls = 0;
  Map<String, dynamic>? lastCreateBody;

  @override
  Future<Observation> create(Map<String, dynamic> body) async {
    createCalls++;
    lastCreateBody = body;
    if (fail) throw Exception('network');
    return Observation(
      id: 'obs-new',
      title: body['title'] as String?,
      stateId: body['state_id'] as int?,
      privacy: (body['privacy'] as String?) ?? 'public',
      identificationStatus: 'processing',
    );
  }

  @override
  Future<ObservationImage> uploadImage(
    String observationId,
    File image, {
    void Function(int sent, int total)? onProgress,
  }) async {
    uploadCalls++;
    onProgress?.call(100, 100);
    if (fail) throw Exception('upload failed');
    return const ObservationImage(optimizedUrl: 'https://cdn.test/img.jpg');
  }

  @override
  Future<Observation> getDetail(String id) async {
    if (fail) throw Exception('network');
    return Observation(
      id: id,
      title: 'Crimson Rose sighting',
      stateName: 'Kerala',
      identifiedSpeciesId: 'sp-1',
      identifiedSpeciesName: 'Pachliopta hector',
      identificationConfidence: 0.93,
      identificationStatus: 'identified',
      primaryImageUrl: 'https://cdn.test/obs.jpg',
      likeCount: 4,
    );
  }

  @override
  Future<List<ObservationSummary>> listMine({int page = 1, int perPage = 20}) async {
    if (fail) throw Exception('network');
    return [
      const ObservationSummary(id: 'obs-1', title: 'My first sighting'),
      const ObservationSummary(id: 'obs-2', title: 'Second'),
    ];
  }

  /// Result returned by [triggerIdentify]; defaults to a confident butterfly
  /// match so submit tests pass the butterfly-only gate.
  AiResult identifyResult = const AiResult(
    id: 'result-1',
    status: 'completed',
    matches: [
      AiMatch(
        id: 1,
        rank: 1,
        confidenceScore: 0.93,
        commonName: 'Crimson Rose',
        scientificName: 'Pachliopta hector',
      ),
    ],
  );

  @override
  Future<AiResult> triggerIdentify(String observationId) async {
    identifyCalls++;
    if (fail) throw Exception('identify failed');
    return identifyResult;
  }

  @override
  Future<Observation> updatePrivacy(String id, String privacy) async {
    if (fail) throw Exception('network');
    return Observation(
      id: id,
      title: 'Sighting with updated privacy',
      privacy: privacy,
      identificationStatus: 'identified',
    );
  }

  @override
  Future<Observation> update(String id, Map<String, dynamic> body) async {
    if (fail) throw Exception('network');
    return Observation(
      id: id,
      title: 'Updated sighting',
      identifiedSpeciesId: body['species_id'] as String?,
      identificationStatus: 'identified',
    );
  }

  @override
  Future<void> delete(String id) async {
    deleteCalls++;
    if (fail) throw Exception('network');
  }
}
