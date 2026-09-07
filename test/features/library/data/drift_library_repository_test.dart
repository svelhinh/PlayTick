import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/data/drift_library_repository.dart';
import 'package:playtick/features/library/domain/estimated_playtimes.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_exception.dart';

void main() {
  group('DriftLibraryRepository', () {
    late AppDatabase database;
    late DriftLibraryRepository repository;
    late DateTime now;
    late Game game;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      now = DateTime.utc(2026, 8, 27, 12);
      repository = DriftLibraryRepository(database, now: () => now);
      game = Game(
        id: 200,
        name: 'Hollow Knight',
        coverUrl: 'https://example.com/hollow-knight.jpg',
        summary: 'A challenging platformer with a unique art style.',
        releaseDate: DateTime.utc(2017, 2, 24),
        genres: ['Platformer', 'Action-Adventure'],
        developer: 'Team Cherry',
        publisher: 'Team Cherry',
        platforms: ['PC', 'PlayStation 4', 'Xbox One', 'Nintendo Switch'],
        estimatedPlaytimes: const EstimatedPlaytimes(
          story: Duration(hours: 10, minutes: 10),
          main: Duration(hours: 15, minutes: 13),
          completion: Duration(hours: 20, minutes: 30),
        ),
      );
    });

    tearDown(() async {
      await database.close();
    });

    test('add game to library', () async {
      var libraryGames = await repository.watchLibraryGames().first;
      var userGames = await database.select(database.userGames).get();
      var storedGames = await database.select(database.games).get();

      expect(libraryGames, isEmpty);
      expect(userGames, isEmpty);
      expect(storedGames, isEmpty);

      await repository.addGame(game);

      libraryGames = await repository.watchLibraryGames().first;
      userGames = await database.select(database.userGames).get();
      storedGames = await database.select(database.games).get();

      expect(libraryGames, hasLength(1));
      expect(userGames, hasLength(1));
      expect(storedGames, hasLength(1));

      final libraryGame = libraryGames.single;

      expect(libraryGame.gameId, game.id);
      expect(libraryGame.name, game.name);
      expect(libraryGame.coverUrl, game.coverUrl);
      expect(libraryGame.status, GameStatus.wantToPlay);
      expect(libraryGame.totalPlaytime, Duration.zero);

      final userGame = userGames.single;

      expect(userGame.gameId, game.id);
      expect(userGame.status, GameStatus.wantToPlay);
      expect(userGame.addedAt.isAtSameMomentAs(now), isTrue);

      final storedGame = storedGames.single;

      expect(storedGame.id, game.id);
      expect(storedGame.name, game.name);
      expect(storedGame.coverUrl, game.coverUrl);
      expect(storedGame.summary, game.summary);
      expect(
        storedGame.releaseDate?.isAtSameMomentAs(game.releaseDate!),
        isTrue,
      );
      expect(storedGame.genres, orderedEquals(game.genres));
      expect(storedGame.platforms, orderedEquals(game.platforms));
      expect(storedGame.developer, game.developer);
      expect(storedGame.publisher, game.publisher);
      expect(
        storedGame.estimatedPlaytimesStory,
        game.estimatedPlaytimes?.story?.inSeconds,
      );
      expect(
        storedGame.estimatedPlaytimesMain,
        game.estimatedPlaytimes?.main?.inSeconds,
      );
      expect(
        storedGame.estimatedPlaytimesCompletion,
        game.estimatedPlaytimes?.completion?.inSeconds,
      );
    });

    test(
      'updates game status and throws when the game is not found',
      () async {
        await repository.addGame(game);

        var libraryGames = await repository.watchLibraryGames().first;

        expect(libraryGames, hasLength(1));
        expect(libraryGames.single.status, GameStatus.wantToPlay);

        await repository.updateGameStatus(game.id, GameStatus.completed);

        libraryGames = await repository.watchLibraryGames().first;

        expect(libraryGames, hasLength(1));
        expect(libraryGames.single.status, GameStatus.completed);

        await expectLater(
          repository.updateGameStatus(999, GameStatus.completed),
          throwsA(isA<GameNotFoundException>()),
        );
      },
    );

    test(
      'throws game not found exception if game not found when updating game',
      () async {
        await expectLater(
          repository.updateGameStatus(999, GameStatus.completed),
          throwsA(isA<GameNotFoundException>()),
        );
      },
    );

    test(
      'adds a game with the selected status',
      () async {
        await repository.addGame(game, status: GameStatus.playing);

        final libraryGames = await repository.watchLibraryGames().first;

        expect(libraryGames, hasLength(1));
        expect(libraryGames.single.status, GameStatus.playing);
      },
    );

    test('watches a library game by id', () async {
      expect(await repository.watchGame(game.id).first, isNull);

      await repository.addGame(game, status: GameStatus.playing);

      final details = await repository.watchGame(game.id).first;

      expect(details, isNotNull);
      expect(details!.status, GameStatus.playing);
      expect(details.totalPlaytime, Duration.zero);
      expect(details.playSessions, isEmpty);
      expect(details.game.id, game.id);
      expect(details.game.name, game.name);
      expect(details.game.coverUrl, game.coverUrl);
      expect(details.game.summary, game.summary);
      expect(
        details.game.releaseDate?.isAtSameMomentAs(game.releaseDate!),
        isTrue,
      );
      expect(details.game.genres, orderedEquals(game.genres));
      expect(details.game.platforms, orderedEquals(game.platforms));
      expect(details.game.developer, game.developer);
      expect(details.game.publisher, game.publisher);
      expect(
        details.game.estimatedPlaytimes?.story,
        game.estimatedPlaytimes?.story,
      );
      expect(
        details.game.estimatedPlaytimes?.main,
        game.estimatedPlaytimes?.main,
      );
      expect(
        details.game.estimatedPlaytimes?.completion,
        game.estimatedPlaytimes?.completion,
      );

      expect(await repository.watchGame(999).first, isNull);

      await repository.updateGameStatus(game.id, GameStatus.completed);

      final updatedDetails = await repository.watchGame(game.id).first;

      expect(updatedDetails?.status, GameStatus.completed);

      await repository.removeGame(game.id);

      expect(await repository.watchGame(game.id).first, isNull);
    });

    test(
      'throws a duplicate game exception if game is already in library',
      () async {
        await repository.addGame(game);

        var libraryGames = await repository.watchLibraryGames().first;
        var storedGames = await database.select(database.games).get();
        var userGames = await database.select(database.userGames).get();

        expect(libraryGames, hasLength(1));
        expect(storedGames, hasLength(1));
        expect(userGames, hasLength(1));

        await expectLater(
          repository.addGame(game),
          throwsA(isA<DuplicateGameException>()),
        );

        libraryGames = await repository.watchLibraryGames().first;
        storedGames = await database.select(database.games).get();
        userGames = await database.select(database.userGames).get();

        expect(libraryGames, hasLength(1));
        expect(storedGames, hasLength(1));
        expect(userGames, hasLength(1));
      },
    );

    test('removes a game from library', () async {
      await repository.addGame(game);

      var libraryGames = await repository.watchLibraryGames().first;
      var storedGames = await database.select(database.games).get();
      var userGames = await database.select(database.userGames).get();

      expect(libraryGames, hasLength(1));
      expect(storedGames, hasLength(1));
      expect(userGames, hasLength(1));

      await repository.removeGame(game.id);

      libraryGames = await repository.watchLibraryGames().first;
      storedGames = await database.select(database.games).get();
      userGames = await database.select(database.userGames).get();

      expect(libraryGames, isEmpty);
      expect(storedGames, hasLength(1));
      expect(storedGames.single.id, game.id);
      expect(userGames, isEmpty);
    });

    test(
      'throws game not found exception if game not found when removing game',
      () async {
        await expectLater(
          repository.removeGame(999),
          throwsA(isA<GameNotFoundException>()),
        );
      },
    );

    test('watch emits after add, update, and removal', () async {
      final iterator = StreamIterator(
        repository.watchLibraryGames(),
      );
      addTearDown(iterator.cancel);

      expect(await iterator.moveNext(), isTrue);
      expect(iterator.current, isEmpty);

      await repository.addGame(game);

      expect(await iterator.moveNext(), isTrue);
      expect(
        iterator.current.single.status,
        GameStatus.wantToPlay,
      );

      await repository.updateGameStatus(
        game.id,
        GameStatus.completed,
      );

      expect(await iterator.moveNext(), isTrue);
      expect(
        iterator.current.single.status,
        GameStatus.completed,
      );

      await repository.removeGame(game.id);

      expect(await iterator.moveNext(), isTrue);
      expect(iterator.current, isEmpty);
    });

    test('adds play sessions and derives total playtime', () async {
      await repository.addGame(game, status: GameStatus.playing);

      await repository.addPlaySession(
        game.id,
        DateTime.utc(2026, 9, 7),
        const Duration(hours: 1, minutes: 30),
        note: 'boss',
      );
      await repository.addPlaySession(
        game.id,
        DateTime.utc(2026, 9, 8),
        const Duration(minutes: 45),
      );

      final details = await repository.watchGame(game.id).first;
      final libraryGames = await repository.watchLibraryGames().first;

      expect(details, isNotNull);
      expect(details!.totalPlaytime, const Duration(hours: 2, minutes: 15));
      expect(details.playSessions, hasLength(2));
      expect(libraryGames.single.totalPlaytime, details.totalPlaytime);

      final latest = details.playSessions.first;
      expect(latest.gameId, game.id);
      expect(latest.date.isAtSameMomentAs(DateTime.utc(2026, 9, 8)), isTrue);
      expect(latest.duration, const Duration(minutes: 45));
      expect(latest.note, isNull);

      final oldest = details.playSessions.last;
      expect(oldest.date.isAtSameMomentAs(DateTime.utc(2026, 9, 7)), isTrue);
      expect(oldest.duration, const Duration(hours: 1, minutes: 30));
      expect(oldest.note, 'boss');
    });

    test(
      'stores a blank play session note as null',
      () async {
        await repository.addGame(game);

        await repository.addPlaySession(
          game.id,
          DateTime.utc(2026, 9, 7),
          const Duration(hours: 1),
          note: '   ',
        );

        final details = await repository.watchGame(game.id).first;

        expect(details!.playSessions.single.note, isNull);
      },
    );

    test(
      'throws when adding a play session for a missing game',
      () async {
        await expectLater(
          repository.addPlaySession(
            999,
            DateTime.utc(2026, 9, 7),
            const Duration(hours: 1),
          ),
          throwsA(isA<GameNotFoundException>()),
        );
      },
    );

    test(
      'throws when adding a play session with a non-positive duration',
      () async {
        await repository.addGame(game);

        await expectLater(
          repository.addPlaySession(
            game.id,
            DateTime.utc(2026, 9, 7),
            Duration.zero,
          ),
          throwsA(isA<InvalidPlaySessionException>()),
        );
      },
    );

    test('deleting a game cascades its play sessions', () async {
      await repository.addGame(game);
      await repository.addPlaySession(
        game.id,
        DateTime.utc(2026, 9, 7),
        const Duration(hours: 2),
      );

      await repository.removeGame(game.id);

      final sessions = await database.select(database.playSessions).get();

      expect(sessions, isEmpty);
      expect(await repository.watchGame(game.id).first, isNull);
    });

    test(
      'watchGame emits after a play session is added',
      () async {
        await repository.addGame(game);

        final iterator = StreamIterator(repository.watchGame(game.id));
        addTearDown(iterator.cancel);

        expect(await iterator.moveNext(), isTrue);
        expect(iterator.current?.playSessions, isEmpty);

        await repository.addPlaySession(
          game.id,
          DateTime.utc(2026, 9, 7),
          const Duration(hours: 1),
        );

        expect(await iterator.moveNext(), isTrue);
        expect(iterator.current?.playSessions, hasLength(1));
        expect(
          iterator.current?.totalPlaytime,
          const Duration(hours: 1),
        );
      },
    );
  });
}
