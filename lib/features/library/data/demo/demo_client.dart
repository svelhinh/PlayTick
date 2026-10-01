import 'package:playtick/features/library/data/demo/library_demo_catalog.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/library_search_repository.dart';

final class DemoClient implements LibrarySearchRepository {
  @override
  Future<List<Game>> searchGames(String query) async {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return [];
    }

    return LibraryDemoCatalog.games
        .where((game) => game.name.toLowerCase().contains(normalizedQuery))
        .toList();
  }
}
