import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/features/library/domain/library_search_results.dart';

void main() {
  const zelda = LibraryGame(
    gameId: 1,
    name: 'The Legend of Zelda',
    status: GameStatus.wantToPlay,
  );
  final zeldaIgdb = Game(id: 1, name: 'The Legend of Zelda');
  final marioIgdb = Game(id: 2, name: 'Super Mario Odyssey');

  test('keeps a local match and drops the same IGDB id', () {
    final results = LibrarySearchResults.merge(
      'zelda',
      [zelda],
      [zeldaIgdb],
    );

    expect(results.libraryGames, hasLength(1));
    expect(results.libraryGames.single.gameId, 1);
    expect(results.igdbGames, isEmpty);
  });

  test('keeps a local match and an IGDB game with another id', () {
    final results = LibrarySearchResults.merge(
      'zelda',
      [zelda],
      [marioIgdb],
    );

    expect(results.libraryGames, hasLength(1));
    expect(results.libraryGames.single.gameId, 1);
    expect(results.igdbGames, hasLength(1));
    expect(results.igdbGames.single.id, 2);
  });

  test('returns nothing when the query is empty', () {
    final results = LibrarySearchResults.merge(
      '   ',
      [zelda],
      [marioIgdb],
    );

    expect(results.libraryGames, isEmpty);
    expect(results.igdbGames, isEmpty);
  });

  test('matches local names case-insensitively', () {
    final results = LibrarySearchResults.merge(
      'ZELDA',
      [zelda],
      const [],
    );

    expect(results.libraryGames, hasLength(1));
    expect(results.libraryGames.single.name, 'The Legend of Zelda');
    expect(results.igdbGames, isEmpty);
  });

  test('excludes local games whose name does not contain the query', () {
    final results = LibrarySearchResults.merge(
      'mario',
      [zelda],
      [marioIgdb],
    );

    expect(results.libraryGames, isEmpty);
    expect(results.igdbGames, hasLength(1));
    expect(results.igdbGames.single.id, 2);
  });

  test(
    'drops an IGDB id already in the library even when the local name does not match',
    () {
      final results = LibrarySearchResults.merge(
        'mario',
        [zelda],
        [zeldaIgdb, marioIgdb],
      );

      expect(results.libraryGames, isEmpty);
      expect(results.igdbGames, hasLength(1));
      expect(results.igdbGames.single.id, 2);
      expect(results.igdbGames.single.name, 'Super Mario Odyssey');
    },
  );
}
