import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/errors/failure.dart';
import 'package:butterfly_india/core/network/connectivity_service.dart';
import 'package:butterfly_india/features/ai_identification/data/classifier/butterfly_classifier.dart';
import 'package:butterfly_india/features/ai_identification/data/repositories/ai_repository.dart';
import 'package:butterfly_india/features/home/data/models/species_summary.dart';
import 'package:butterfly_india/features/species/data/models/species_detail.dart';
import 'package:butterfly_india/features/species/data/models/species_filter.dart';
import 'package:butterfly_india/features/species/data/repositories/species_repository.dart';
import '../../mocks/mock_services.dart';
import '../observations/fake_observation_datasource.dart';
import 'fake_ai_datasource.dart';

/// Classifier stub: configurable availability + canned predictions.
class _StubClassifier implements IButterflyClassifier {
  _StubClassifier({this.available = false, this.predictions = const []});
  bool available;
  List<Classification> predictions;
  int classifyCalls = 0;

  @override
  Future<bool> ensureLoaded() async => available;

  @override
  Future<List<Classification>> classify(File image, {int topK = 3}) async {
    classifyCalls++;
    if (!available) throw ClassifierUnavailable();
    return predictions.take(topK).toList();
  }

  @override
  void dispose() {}
}

/// Species repo whose search() returns canned summaries; rest unused.
class _FakeSpeciesRepo implements ISpeciesRepository {
  _FakeSpeciesRepo({this.results = const []});
  List<SpeciesSummary> results;

  @override
  Future<Either<Failure, List<SpeciesSummary>>> search(String query) async =>
      Right(results);

  @override
  Future<Either<Failure, List<SpeciesSummary>>> getSpecies({
    required int page,
    int perPage = 20,
    SpeciesFilter filter = const SpeciesFilter(),
  }) =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, SpeciesDetail>> getDetail(String id) =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, List<SpeciesSummary>>> getSimilar(String id) =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, bool>> toggleBookmark(String id) =>
      throw UnimplementedError();
  @override
  Stream<Set<String>> watchBookmarkedIds() => throw UnimplementedError();
  @override
  Stream<List<SpeciesSummary>> watchBookmarkedSpecies() =>
      throw UnimplementedError();
}

void main() {
  late FakeObservationRemoteDataSource obs;
  late FakeAiRemoteDataSource ai;
  late MockConnectivityService connectivity;

  AiRepository build({
    IButterflyClassifier? classifier,
    _FakeSpeciesRepo? species,
  }) =>
      AiRepository(
        observationRemote: obs,
        aiRemote: ai,
        classifier: classifier ?? _StubClassifier(),
        speciesRepository: species ?? _FakeSpeciesRepo(),
        connectivity: connectivity,
      );

  setUp(() {
    obs = FakeObservationRemoteDataSource();
    ai = FakeAiRemoteDataSource();
    connectivity = MockConnectivityService();
  });

  File fakeImage() => File('no_such_image.jpg');

  group('identifyFromImage (backend fallback when model absent)', () {
    test('creates sighting, uploads, then identifies via backend', () async {
      final result = await build().identifyFromImage(
        image: fakeImage(),
        stateId: 11,
        privacy: 'private',
      );

      expect(result.isRight(), isTrue);
      final scan = result.getOrElse(() => throw 'x');
      expect(obs.createCalls, 1);
      expect(obs.uploadCalls, 1);
      expect(ai.triggerCalls, 1); // fell back to backend
      expect(scan.result.topMatch!.commonName, 'Crimson Rose');
    });

    test('reports progress stages in order', () async {
      final stages = <ScanStage>[];
      await build().identifyFromImage(
        image: fakeImage(),
        stateId: 11,
        privacy: 'private',
        onProgress: stages.add,
      );
      expect(stages.first, ScanStage.compressing);
      expect(stages, contains(ScanStage.analysing));
      expect(stages.last, ScanStage.done);
    });

    test('offline → network failure, no calls made', () async {
      connectivity.setStatus(ConnectivityStatus.offline);
      final result = await build().identifyFromImage(
        image: fakeImage(),
        stateId: 11,
        privacy: 'private',
      );
      expect(result.isLeft(), isTrue);
      expect(obs.createCalls, 0);
      expect(ai.triggerCalls, 0);
    });
  });

  group('identifyFromImage (on-device model present)', () {
    test('uses on-device predictions and does NOT call the backend', () async {
      final classifier = _StubClassifier(available: true, predictions: const [
        Classification(label: 'Crimson Rose', confidence: 0.91),
        Classification(label: 'Common Mormon', confidence: 0.06),
      ]);
      final species = _FakeSpeciesRepo(results: const [
        SpeciesSummary(
          id: 'sp-1',
          commonName: 'Crimson Rose',
          scientificName: 'Pachliopta hector',
          primaryImageUrl: 'https://x/img.jpg',
        ),
      ]);

      final result = await build(classifier: classifier, species: species)
          .identifyFromImage(image: fakeImage(), stateId: 11, privacy: 'public');

      expect(result.isRight(), isTrue);
      final scan = result.getOrElse(() => throw 'x');
      expect(ai.triggerCalls, 0); // backend NOT used
      expect(classifier.classifyCalls, 1);
      expect(scan.result.matches.length, 2);
      final top = scan.result.topMatch!;
      expect(top.commonName, 'Crimson Rose');
      expect(top.speciesId, 'sp-1'); // resolved via species search
      expect(top.confidenceScore, closeTo(0.91, 1e-6));
    });

    test('still builds matches when species lookup finds nothing', () async {
      final classifier = _StubClassifier(available: true, predictions: const [
        Classification(label: 'Mystery Flutter', confidence: 0.5),
      ]);
      final result = await build(classifier: classifier)
          .identifyFromImage(image: fakeImage(), stateId: 1, privacy: 'public');

      final scan = result.getOrElse(() => throw 'x');
      expect(scan.result.topMatch!.commonName, 'Mystery Flutter');
      expect(scan.result.topMatch!.speciesId, isNull);
    });

    test('low top confidence → no-match (couldn\'t identify)', () async {
      final classifier = _StubClassifier(available: true, predictions: const [
        Classification(label: 'BLUE MORPHO', confidence: 0.10),
        Classification(label: 'ATLAS MOTH', confidence: 0.05),
      ]);
      final result = await build(classifier: classifier)
          .identifyFromImage(image: fakeImage(), stateId: 1, privacy: 'public');

      final scan = result.getOrElse(() => throw 'x');
      expect(scan.result.matches, isEmpty);
      expect(scan.result.hasNoMatch, isTrue);
    });

    test('prettifies UPPERCASE labels for display', () async {
      final classifier = _StubClassifier(available: true, predictions: const [
        Classification(label: 'BLUE MORPHO', confidence: 0.88),
      ]);
      final result = await build(classifier: classifier)
          .identifyFromImage(image: fakeImage(), stateId: 1, privacy: 'public');

      final scan = result.getOrElse(() => throw 'x');
      expect(scan.result.topMatch!.commonName, 'Blue Morpho');
    });
  });
}
