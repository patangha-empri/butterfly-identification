import 'dart:io';
import 'package:butterfly_india/features/ai_identification/data/datasources/ai_remote_datasource.dart';
import 'package:butterfly_india/features/ai_identification/data/models/ai_result.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// FAKE AI REMOTE DATASOURCE
/// ─────────────────────────────────────────────────────────────────────────────

class FakeAiRemoteDataSource implements IAiRemoteDataSource {
  FakeAiRemoteDataSource({
    this.fail = false,
    this.status = 'completed',
    this.withMatches = true,
  });

  bool fail;
  String status;
  bool withMatches;
  int triggerCalls = 0;

  AiResult _result(String obsId) => AiResult(
        id: 'res-1',
        observationId: obsId,
        status: status,
        matches: withMatches
            ? [
                const AiMatch(
                  id: 1,
                  rank: 1,
                  confidenceScore: 0.94,
                  commonName: 'Crimson Rose',
                  scientificName: 'Pachliopta hector',
                  speciesId: 'sp-1',
                  species: {
                    'primary_image_url': 'https://cdn.test/1.jpg',
                    'rarity': 'uncommon',
                  },
                ),
                const AiMatch(
                  id: 2,
                  rank: 2,
                  confidenceScore: 0.42,
                  commonName: 'Common Rose',
                  scientificName: 'Pachliopta aristolochiae',
                  speciesId: 'sp-2',
                ),
              ]
            : const [],
      );

  @override
  Future<AiResult> triggerIdentify(String observationId) async {
    triggerCalls++;
    if (fail) throw Exception('ai failed');
    return _result(observationId);
  }

  @override
  Future<AiResult> getResult(String observationId) async {
    if (fail) throw Exception('ai failed');
    return _result(observationId);
  }

  int quickScanCalls = 0;

  @override
  Future<QuickScanResult> quickScan(File image) async {
    quickScanCalls++;
    if (fail) throw Exception('ai failed');
    return QuickScanResult(
      isButterfly: withMatches,
      identified: withMatches,
      matches: withMatches
          ? const [
              QuickScanMatch(
                commonName: 'Crimson Rose',
                scientificName: 'Pachliopta hector',
                confidence: 0.94,
              ),
            ]
          : const [],
    );
  }
}
