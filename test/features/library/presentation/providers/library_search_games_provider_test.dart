import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/library_search_repository.dart';
import 'package:playtick/features/library/presentation/providers/debounced_library_search_provider.dart';
import 'package:playtick/features/library/presentation/providers/library_search_games_provider.dart';
import 'package:playtick/features/library/presentation/providers/library_search_notifier_provider.dart';
import 'package:playtick/features/library/providers/library_search_repository_provider.dart';

class _CountingSearchRepository implements LibrarySearchRepository {
  final List<String> queries = [];

  @override
  Future<List<Game>> searchGames(String query) async {
    queries.add(query);
    return [Game(id: 1, name: query)];
  }
}

void main() {
  testWidgets(
    'debounces IGDB search until the query settles for 300 ms',
    (tester) async {
      final searchRepository = _CountingSearchRepository();
      final container = ProviderContainer(
        overrides: [
          librarySearchRepositoryProvider.overrideWith(
            (_) => searchRepository,
          ),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(
        librarySearchGamesProvider,
        (_, _) {},
      );
      addTearDown(subscription.close);

      container.read(librarySearchProvider.notifier).search('ho');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(searchRepository.queries, isEmpty);
      expect(container.read(debouncedLibrarySearchProvider), isEmpty);
      expect(container.read(librarySearchGamesProvider).isLoading, isFalse);

      container.read(librarySearchProvider.notifier).search('hollow');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(searchRepository.queries, ['hollow']);
      final games = await container.read(librarySearchGamesProvider.future);
      expect(games, hasLength(1));
      expect(games.single.id, 1);
      expect(games.single.name, 'hollow');
    },
  );
}
