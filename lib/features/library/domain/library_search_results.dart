import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/library_game.dart';

final class LibrarySearchResults {
  LibrarySearchResults({
    required this.libraryGames,
    required this.igdbGames,
  });

  factory LibrarySearchResults.merge(
    String query,
    List<LibraryGame> libraryGames,
    List<Game> igdbGames,
  ) {
    final searchQuery = query.toLowerCase().trim();

    if (searchQuery.isEmpty) {
      return LibrarySearchResults(
        libraryGames: [],
        igdbGames: [],
      );
    }

    final matchingLibraryGames = <LibraryGame>[];
    final libraryIds = {for (final game in libraryGames) game.gameId};

    final matchingIgdbGames = [
      for (final game in igdbGames)
        if (!libraryIds.contains(game.id)) game,
    ];

    for (final libraryGame in libraryGames) {
      if (libraryGame.name.toLowerCase().contains(searchQuery)) {
        matchingLibraryGames.add(libraryGame);
      }
    }

    return LibrarySearchResults(
      libraryGames: matchingLibraryGames,
      igdbGames: matchingIgdbGames,
    );
  }

  final List<LibraryGame> libraryGames;
  final List<Game> igdbGames;
}
