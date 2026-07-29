import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/models/home_feed.dart';
import '../../data/repositories/home_repository.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// HOME PROVIDERS
/// ─────────────────────────────────────────────────────────────────────────────

final homeRemoteDataSourceProvider = Provider<IHomeRemoteDataSource>(
  (ref) => HomeRemoteDataSource(dio: ref.read(dioProvider)),
  name: 'homeRemoteDataSource',
);

final homeRepositoryProvider = Provider<IHomeRepository>(
  (ref) {
    final db = ref.read(appDatabaseProvider);
    return HomeRepository(
      remote: ref.read(homeRemoteDataSourceProvider),
      speciesDao: db.speciesDao,
      observationsDao: db.observationsDao,
      connectivity: ref.read(connectivityServiceProvider),
      location: ref.read(locationServiceProvider),
    );
  },
  name: 'homeRepository',
);

/// Loads the aggregate home feed. Use `ref.refresh(homeFeedProvider)` for
/// pull-to-refresh.
final homeFeedProvider = FutureProvider.autoDispose<HomeFeed>(
  (ref) async {
    final result = await ref
        .read(homeRepositoryProvider)
        .getHomeFeed(forceRefresh: true);
    return result.fold(
      (failure) => throw HomeFeedException(failure.message),
      (feed) => feed,
    );
  },
  name: 'homeFeed',
);

/// Lightweight exception carrying the failure message to the UI.
class HomeFeedException implements Exception {
  HomeFeedException(this.message);
  final String message;
  @override
  String toString() => message;
}
