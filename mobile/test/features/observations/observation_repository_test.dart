import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:butterfly_india/core/database/app_database.dart';
import 'package:butterfly_india/core/network/connectivity_service.dart';
import 'package:butterfly_india/features/ai_identification/data/models/ai_result.dart';
import 'package:butterfly_india/features/observations/data/models/observation_draft.dart';
import 'package:butterfly_india/features/observations/data/repositories/observation_repository.dart';
import '../../mocks/mock_services.dart';
import 'fake_observation_datasource.dart';

void main() {
  late AppDatabase db;
  late FakeObservationRemoteDataSource remote;
  late MockConnectivityService connectivity;

  ObservationRepository build() => ObservationRepository(
        remote: remote,
        dao: db.observationsDao,
        connectivity: connectivity,
      );

  setUp(() {
    db = AppDatabase.inMemory();
    remote = FakeObservationRemoteDataSource();
    connectivity = MockConnectivityService();
  });

  tearDown(() => db.close());

  // Drafts use no images so we don't touch the compression isolate / platform.
  ObservationDraft validDraft() => ObservationDraft(stateId: 11, title: 'Test');

  group('submit — online', () {
    test('creates; identification skipped when no photos attached', () async {
      final result = await build().submit(validDraft());

      expect(result.isRight(), isTrue);
      final outcome = result.getOrElse(() => throw 'x');
      expect(outcome, isA<SubmitSuccess>());
      expect(remote.createCalls, 1);
      // No photos → nothing for Gemini to analyse; identify must not fire.
      expect(remote.identifyCalls, 0);
      expect((outcome as SubmitSuccess).observation.id, 'obs-new');
    });

    test('reports progress stages', () async {
      final stages = <SubmitStage>[];
      await build().submit(validDraft(), onProgress: (s, _) => stages.add(s));
      expect(stages, contains(SubmitStage.creating));
      expect(stages.last, SubmitStage.done);
    });

    test('invalid draft (no state) → validation failure', () async {
      final result = await build().submit(ObservationDraft());
      expect(result.isLeft(), isTrue);
      expect(remote.createCalls, 0);
    });

    test('server error → failure', () async {
      remote.fail = true;
      final result = await build().submit(validDraft());
      expect(result.isLeft(), isTrue);
    });
  });

  group('submit — butterfly-only gate', () {
    // ImageHelper.compress falls back to the source file when it can't be
    // read, so a nonexistent path exercises the pipeline without platform IO.
    ObservationDraft draftWithImage() => ObservationDraft(
          stateId: 11,
          title: 'Test',
          images: [File('no_such_image.jpg')],
        );

    test('AI confirms no butterfly → rejected and observation deleted',
        () async {
      remote.identifyResult = const AiResult(
        id: 'result-1',
        status: 'completed',
        matches: [],
        rawResponse: {
          'detection': {'contains_butterfly': false},
        },
      );

      final result = await build().submit(draftWithImage());

      final outcome = result.getOrElse(() => throw 'x');
      expect(outcome, isA<SubmitRejected>());
      expect(remote.deleteCalls, 1);
    });

    test('butterfly present but unidentifiable → still submits', () async {
      remote.identifyResult = const AiResult(
        id: 'result-1',
        status: 'completed',
        matches: [],
        rawResponse: {
          'detection': {'contains_butterfly': true},
        },
      );

      final result = await build().submit(draftWithImage());

      final outcome = result.getOrElse(() => throw 'x');
      expect(outcome, isA<SubmitSuccess>());
      expect(remote.deleteCalls, 0);
    });

    test('confident butterfly match → success carries the AI result',
        () async {
      final result = await build().submit(draftWithImage());

      final outcome =
          result.getOrElse(() => throw 'x') as SubmitSuccess;
      expect(remote.identifyCalls, 1);
      expect(outcome.aiResult?.topMatch?.commonName, 'Crimson Rose');
      expect(remote.deleteCalls, 0);
    });
  });

  group('submit — offline', () {
    test('enqueues to offline queue and returns queued', () async {
      connectivity.setStatus(ConnectivityStatus.offline);
      final repo = build();

      final result = await repo.submit(validDraft());

      expect(result.getOrElse(() => throw 'x'), isA<SubmitQueued>());
      expect(remote.createCalls, 0);
      expect(await repo.pendingQueueCount(), 1);
    });
  });

  group('syncPending', () {
    test('drains the queue when back online', () async {
      // Queue one offline.
      connectivity.setStatus(ConnectivityStatus.offline);
      final repo = build();
      await repo.submit(validDraft());
      expect(await repo.pendingQueueCount(), 1);

      // Back online → sync.
      connectivity.setStatus(ConnectivityStatus.online);
      await repo.syncPending();

      expect(remote.createCalls, 1);
      expect(await repo.pendingQueueCount(), 0);
    });

    test('does nothing while offline', () async {
      connectivity.setStatus(ConnectivityStatus.offline);
      final repo = build();
      await repo.submit(validDraft());
      await repo.syncPending();
      expect(remote.createCalls, 0);
      expect(await repo.pendingQueueCount(), 1);
    });
  });

  group('reads', () {
    test('getDetail returns identified observation', () async {
      final result = await build().getDetail('obs-1');
      final obs = result.getOrElse(() => throw 'x');
      expect(obs.isIdentified, isTrue);
      expect(obs.identifiedSpeciesName, 'Pachliopta hector');
    });

    test('listMine returns user sightings', () async {
      final result = await build().listMine();
      expect(result.getOrElse(() => []), hasLength(2));
    });
  });
}
