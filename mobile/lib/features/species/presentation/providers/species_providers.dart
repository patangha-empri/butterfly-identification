import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/core_providers.dart';
import '../../../home/data/models/species_summary.dart';
import '../../data/datasources/species_remote_datasource.dart';
import '../../data/models/species_detail.dart';
import '../../data/models/species_filter.dart';
import '../../data/repositories/species_repository.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// SPECIES PROVIDERS
/// ─────────────────────────────────────────────────────────────────────────────

final speciesRemoteDataSourceProvider = Provider<ISpeciesRemoteDataSource>(
  (ref) => SpeciesRemoteDataSource(dio: ref.read(dioProvider)),
  name: 'speciesRemoteDataSource',
);

final speciesRepositoryProvider = Provider<ISpeciesRepository>(
  (ref) => SpeciesRepository(
    remote: ref.read(speciesRemoteDataSourceProvider),
    dao: ref.read(appDatabaseProvider).speciesDao,
    connectivity: ref.read(connectivityServiceProvider),
  ),
  name: 'speciesRepository',
);

/// Active filter for the listing. Changing it rebuilds [speciesListProvider].
final speciesFilterProvider = StateProvider<SpeciesFilter>(
  (ref) => const SpeciesFilter(),
  name: 'speciesFilter',
);

/// Set of bookmarked species ids (reactive from the local DB).
final bookmarkedSpeciesProvider = StreamProvider<Set<String>>(
  (ref) => ref.read(speciesRepositoryProvider).watchBookmarkedIds(),
  name: 'bookmarkedSpecies',
);

/// Full list of saved/bookmarked species (reactive from the local DB).
final savedSpeciesProvider = StreamProvider<List<SpeciesSummary>>(
  (ref) => ref.read(speciesRepositoryProvider).watchBookmarkedSpecies(),
  name: 'savedSpecies',
);

/// Paginated species listing, parameterised by the current filter.
final speciesListProvider = StateNotifierProvider.autoDispose<
    SpeciesListNotifier, SpeciesListState>(
  (ref) {
    final filter = ref.watch(speciesFilterProvider);
    return SpeciesListNotifier(
      repository: ref.read(speciesRepositoryProvider),
      filter: filter,
    )..loadInitial();
  },
  name: 'speciesList',
);

/// Full detail for a species.
final speciesDetailProvider =
    FutureProvider.autoDispose.family<SpeciesDetail, String>(
  (ref, id) async {
    final result = await ref.read(speciesRepositoryProvider).getDetail(id);
    return result.fold((f) => throw SpeciesException(f.message), (d) => d);
  },
  name: 'speciesDetail',
);

/// Similar-species recommendations for a species.
final similarSpeciesProvider =
    FutureProvider.autoDispose.family<List<SpeciesSummary>, String>(
  (ref, id) async {
    final result = await ref.read(speciesRepositoryProvider).getSimilar(id);
    return result.fold((_) => <SpeciesSummary>[], (list) => list);
  },
  name: 'similarSpecies',
);

// ── Paginated list state + notifier ──────────────────────────────────────────

enum SpeciesListStatus { initial, loading, loadingMore, success, error }

class SpeciesListState extends Equatable {
  const SpeciesListState({
    this.items = const [],
    this.status = SpeciesListStatus.initial,
    this.hasMore = true,
    this.page = 1,
    this.error,
  });

  final List<SpeciesSummary> items;
  final SpeciesListStatus status;
  final bool hasMore;
  final int page;
  final String? error;

  bool get isInitialLoading =>
      status == SpeciesListStatus.loading && items.isEmpty;
  bool get isLoadingMore => status == SpeciesListStatus.loadingMore;
  bool get isEmpty => status == SpeciesListStatus.success && items.isEmpty;
  bool get hasError => status == SpeciesListStatus.error;

  SpeciesListState copyWith({
    List<SpeciesSummary>? items,
    SpeciesListStatus? status,
    bool? hasMore,
    int? page,
    String? error,
  }) =>
      SpeciesListState(
        items: items ?? this.items,
        status: status ?? this.status,
        hasMore: hasMore ?? this.hasMore,
        page: page ?? this.page,
        error: error,
      );

  @override
  List<Object?> get props => [items, status, hasMore, page, error];
}

class SpeciesListNotifier extends StateNotifier<SpeciesListState> {
  SpeciesListNotifier({
    required ISpeciesRepository repository,
    required SpeciesFilter filter,
    this.perPage = 20,
  })  : _repository = repository,
        _filter = filter,
        super(const SpeciesListState());

  final ISpeciesRepository _repository;
  final SpeciesFilter _filter;
  final int perPage;

  Future<void> loadInitial() async {
    if (state.status == SpeciesListStatus.loading) return;
    state = const SpeciesListState(status: SpeciesListStatus.loading);

    final result = await _repository.getSpecies(
      page: 1,
      perPage: perPage,
      filter: _filter,
    );

    state = result.fold(
      (failure) => state.copyWith(
        status: SpeciesListStatus.error,
        error: failure.message,
      ),
      (items) => SpeciesListState(
        items: items,
        status: SpeciesListStatus.success,
        page: 1,
        hasMore: items.length >= perPage,
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.status == SpeciesListStatus.loadingMore ||
        state.status == SpeciesListStatus.loading) {
      return;
    }
    state = state.copyWith(status: SpeciesListStatus.loadingMore);
    final nextPage = state.page + 1;

    final result = await _repository.getSpecies(
      page: nextPage,
      perPage: perPage,
      filter: _filter,
    );

    state = result.fold(
      (failure) => state.copyWith(
        status: SpeciesListStatus.success, // keep existing items visible
        hasMore: false,
      ),
      (items) => state.copyWith(
        items: [...state.items, ...items],
        status: SpeciesListStatus.success,
        page: nextPage,
        hasMore: items.length >= perPage,
      ),
    );
  }

  Future<void> refresh() => loadInitial();
}

class SpeciesException implements Exception {
  SpeciesException(this.message);
  final String message;
  @override
  String toString() => message;
}
