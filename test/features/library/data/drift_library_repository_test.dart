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
      now = DateTime(2026, 8, 27, 12);
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

    test('updates a play session and derives total playtime', () async {
      await repository.addGame(game);
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

      var details = await repository.watchGame(game.id).first;
      final sessionId = details!.playSessions.last.id;

      await repository.updatePlaySession(
        sessionId,
        DateTime.utc(2026, 9, 6),
        const Duration(hours: 2),
        note: 'chapitre 7',
      );

      details = await repository.watchGame(game.id).first;
      final libraryGames = await repository.watchLibraryGames().first;
      final updated = details!.playSessions.singleWhere(
        (session) => session.id == sessionId,
      );

      expect(details.totalPlaytime, const Duration(hours: 2, minutes: 45));
      expect(libraryGames.single.totalPlaytime, details.totalPlaytime);
      expect(updated.date.isAtSameMomentAs(DateTime.utc(2026, 9, 6)), isTrue);
      expect(updated.duration, const Duration(hours: 2));
      expect(updated.note, 'chapitre 7');
    });

    test(
      'stores a blank play session note as null when updating',
      () async {
        await repository.addGame(game);
        await repository.addPlaySession(
          game.id,
          DateTime.utc(2026, 9, 7),
          const Duration(hours: 1),
          note: 'boss',
        );

        final sessionId =
            (await repository.watchGame(game.id).first)!.playSessions.single.id;

        await repository.updatePlaySession(
          sessionId,
          DateTime.utc(2026, 9, 7),
          const Duration(hours: 1),
          note: '   ',
        );

        final details = await repository.watchGame(game.id).first;

        expect(details!.playSessions.single.note, isNull);
      },
    );

    test(
      'throws when updating a missing play session',
      () async {
        await expectLater(
          repository.updatePlaySession(
            999,
            DateTime.utc(2026, 9, 7),
            const Duration(hours: 1),
          ),
          throwsA(isA<PlaySessionNotFoundException>()),
        );
      },
    );

    test(
      'throws when updating a play session with a non-positive duration',
      () async {
        await repository.addGame(game);
        await repository.addPlaySession(
          game.id,
          DateTime.utc(2026, 9, 7),
          const Duration(hours: 1),
        );

        final sessionId =
            (await repository.watchGame(game.id).first)!.playSessions.single.id;

        await expectLater(
          repository.updatePlaySession(
            sessionId,
            DateTime.utc(2026, 9, 7),
            Duration.zero,
          ),
          throwsA(isA<InvalidPlaySessionException>()),
        );
      },
    );

    test('removes a play session and derives total playtime', () async {
      await repository.addGame(game);
      await repository.addPlaySession(
        game.id,
        DateTime.utc(2026, 9, 7),
        const Duration(hours: 1, minutes: 30),
      );
      await repository.addPlaySession(
        game.id,
        DateTime.utc(2026, 9, 8),
        const Duration(minutes: 45),
      );

      var details = await repository.watchGame(game.id).first;
      final sessionId = details!.playSessions.first.id;

      await repository.removePlaySession(sessionId);

      details = await repository.watchGame(game.id).first;
      final libraryGames = await repository.watchLibraryGames().first;

      expect(details!.playSessions, hasLength(1));
      expect(details.totalPlaytime, const Duration(hours: 1, minutes: 30));
      expect(libraryGames.single.totalPlaytime, details.totalPlaytime);
    });

    test(
      'throws when removing a missing play session',
      () async {
        await expectLater(
          repository.removePlaySession(999),
          throwsA(isA<PlaySessionNotFoundException>()),
        );
      },
    );

    test(
      'watchGame emits after a play session is updated and removed',
      () async {
        await repository.addGame(game);
        await repository.addPlaySession(
          game.id,
          DateTime.utc(2026, 9, 7),
          const Duration(hours: 1),
        );

        final iterator = StreamIterator(repository.watchGame(game.id));
        addTearDown(iterator.cancel);

        expect(await iterator.moveNext(), isTrue);
        expect(iterator.current?.playSessions, hasLength(1));

        final sessionId = iterator.current!.playSessions.single.id;

        await repository.updatePlaySession(
          sessionId,
          DateTime.utc(2026, 9, 8),
          const Duration(hours: 2),
        );

        expect(await iterator.moveNext(), isTrue);
        expect(
          iterator.current?.totalPlaytime,
          const Duration(hours: 2),
        );

        await repository.removePlaySession(sessionId);

        expect(await iterator.moveNext(), isTrue);
        expect(iterator.current?.playSessions, isEmpty);
        expect(iterator.current?.totalPlaytime, Duration.zero);
      },
    );

    test(
      'watchWeeklyPlaytime sums only sessions in the current week',
      () async {
        await repository.addGame(game);
        await repository.addPlaySession(
          game.id,
          DateTime(2026, 8, 23),
          const Duration(hours: 2),
        );
        await repository.addPlaySession(
          game.id,
          DateTime(2026, 8, 26),
          const Duration(hours: 1),
        );

        expect(
          await repository.watchWeeklyPlaytime().first,
          const Duration(hours: 1),
        );
      },
    );

    test(
      'watchWeeklyPlaytime emits after a play session is added, updated, and removed',
      () async {
        await repository.addGame(game);

        final iterator = StreamIterator(repository.watchWeeklyPlaytime());
        addTearDown(iterator.cancel);

        expect(await iterator.moveNext(), isTrue);
        expect(iterator.current, Duration.zero);

        await repository.addPlaySession(
          game.id,
          DateTime(2026, 8, 26),
          const Duration(hours: 1),
        );

        expect(await iterator.moveNext(), isTrue);
        expect(iterator.current, const Duration(hours: 1));

        final sessionId =
            (await repository.watchGame(game.id).first)!.playSessions.single.id;

        await repository.updatePlaySession(
          sessionId,
          DateTime(2026, 8, 23),
          const Duration(hours: 1),
        );

        expect(await iterator.moveNext(), isTrue);
        expect(iterator.current, Duration.zero);

        await repository.removePlaySession(sessionId);

        expect(await iterator.moveNext(), isTrue);
        expect(iterator.current, Duration.zero);
      },
    );

    test(
      'active play session does not affect weekly or total playtime until finished',
      () async {
        await repository.addGame(game, status: GameStatus.playing);
        await repository.addPlaySession(
          game.id,
          DateTime(2026, 8, 26),
          const Duration(hours: 1),
        );

        expect(
          await repository.watchWeeklyPlaytime().first,
          const Duration(hours: 1),
        );
        expect(
          (await repository.watchGame(game.id).first)!.totalPlaytime,
          const Duration(hours: 1),
        );

        await repository.startActivePlaySession(game.id);

        expect(
          await repository.watchWeeklyPlaytime().first,
          const Duration(hours: 1),
        );
        expect(
          (await repository.watchGame(game.id).first)!.totalPlaytime,
          const Duration(hours: 1),
        );
        expect(await repository.watchActivePlaySession().first, isNotNull);

        await repository.finishActivePlaySession(
          const Duration(minutes: 30),
        );

        expect(
          await repository.watchWeeklyPlaytime().first,
          const Duration(hours: 1, minutes: 30),
        );
        expect(
          (await repository.watchGame(game.id).first)!.totalPlaytime,
          const Duration(hours: 1, minutes: 30),
        );
        expect(await repository.watchActivePlaySession().first, isNull);
      },
    );

    test(
      'watchActivePlaySession emits after a active play session is started',
      () async {
        await repository.addGame(game, status: GameStatus.playing);
        await repository.startActivePlaySession(game.id);

        final iterator = StreamIterator(repository.watchActivePlaySession());
        addTearDown(iterator.cancel);

        expect(await iterator.moveNext(), isTrue);
        expect(iterator.current, isNotNull);
        expect(iterator.current!.gameId, game.id);
        expect(iterator.current!.startedAt.isAtSameMomentAs(now), isTrue);
      },
    );

    test(
      'startActivePlaySession throws invalid active play session exception if '
      'the game is not playing',
      () async {
        await repository.addGame(game, status: GameStatus.playing);
        await repository.updateGameStatus(game.id, GameStatus.wantToPlay);
        await expectLater(
          repository.startActivePlaySession(game.id),
          throwsA(isA<InvalidActivePlaySessionException>()),
        );
      },
    );

    test(
      'startActivePlaySession throws duplicate active play session exception '
      'if the active play session already exists',
      () async {
        await repository.addGame(game, status: GameStatus.playing);
        await repository.startActivePlaySession(game.id);
        await expectLater(
          repository.startActivePlaySession(game.id),
          throwsA(isA<DuplicateActivePlaySessionException>()),
        );
      },
    );

    test(
      'startActivePlaySession throws game not found exception if the game is '
      'not in the library',
      () async {
        await expectLater(
          repository.startActivePlaySession(999),
          throwsA(isA<GameNotFoundException>()),
        );
      },
    );

    test(
      'clearActivePlaySession clears the active play session',
      () async {
        await repository.addGame(game, status: GameStatus.playing);
        await repository.startActivePlaySession(game.id);

        await repository.clearActivePlaySession();

        expect(
          await database.select(database.activePlaySessions).get(),
          isEmpty,
        );
        expect(await repository.watchActivePlaySession().first, isNull);

        final playSessions = await database.select(database.playSessions).get();
        expect(playSessions, isEmpty);
      },
    );

    test(
      'clearActivePlaySession does not throw if the active play session does '
      'not exist',
      () async {
        await repository.clearActivePlaySession();
        expect(
          await database.select(database.activePlaySessions).get(),
          isEmpty,
        );
      },
    );

    test(
      'finishActivePlaySession saves the corrected session and clears the active session',
      () async {
        await repository.addGame(game, status: GameStatus.playing);
        await repository.startActivePlaySession(game.id);

        await repository.finishActivePlaySession(
          const Duration(minutes: 47),
          note: '  Chapter complete  ',
        );

        final details = await repository.watchGame(game.id).first;

        expect(details, isNotNull);
        expect(details!.totalPlaytime, const Duration(minutes: 47));
        expect(details.playSessions, hasLength(1));
        expect(details.playSessions.single.gameId, game.id);
        expect(details.playSessions.single.date.isAtSameMomentAs(now), isTrue);
        expect(
          details.playSessions.single.duration,
          const Duration(minutes: 47),
        );
        expect(details.playSessions.single.note, 'Chapter complete');
        expect(await repository.watchActivePlaySession().first, isNull);
      },
    );

    test(
      'finishActivePlaySession keeps the active session when duration is invalid',
      () async {
        await repository.addGame(game, status: GameStatus.playing);
        await repository.startActivePlaySession(game.id);

        await expectLater(
          repository.finishActivePlaySession(Duration.zero),
          throwsA(isA<InvalidPlaySessionException>()),
        );

        expect(
          await database.select(database.playSessions).get(),
          isEmpty,
        );
        expect(await repository.watchActivePlaySession().first, isNotNull);
      },
    );

    test(
      'finishActivePlaySession throws when no active session exists',
      () async {
        await expectLater(
          repository.finishActivePlaySession(const Duration(minutes: 30)),
          throwsA(isA<ActivePlaySessionNotFoundException>()),
        );

        expect(
          await database.select(database.playSessions).get(),
          isEmpty,
        );
      },
    );

    test(
      'finishActivePlaySession rolls back the saved session if clearing fails',
      () async {
        await repository.addGame(game, status: GameStatus.playing);
        await repository.startActivePlaySession(game.id);
        await database.customStatement('''
          CREATE TRIGGER prevent_active_session_delete
          BEFORE DELETE ON active_play_sessions
          BEGIN
            SELECT RAISE(ABORT, 'delete blocked');
          END;
        ''');

        await expectLater(
          repository.finishActivePlaySession(const Duration(minutes: 30)),
          throwsA(anything),
        );

        expect(
          await database.select(database.playSessions).get(),
          isEmpty,
        );
        expect(await repository.watchActivePlaySession().first, isNotNull);
      },
    );

    test(
      'game notes are trimmed, isolated by game, and newest first',
      () async {
        final otherGame = Game(id: 201, name: 'Celeste');
        await repository.addGame(game);
        await repository.addGame(otherGame);

        now = DateTime(2026, 8, 27, 10);
        await repository.addGameNote(game.id, '  First note  ');
        now = DateTime(2026, 8, 27, 11);
        await repository.addGameNote(otherGame.id, 'Other game note');
        now = DateTime(2026, 8, 27, 12);
        await repository.addGameNote(game.id, 'Latest note');

        final notes = await repository.watchGameNotes(game.id).first;

        expect(notes.map((note) => note.content), [
          'Latest note',
          'First note',
        ]);
        expect(notes.every((note) => note.gameId == game.id), isTrue);
        expect(notes.first.createdAt, DateTime(2026, 8, 27, 12));
      },
    );

    test('adding a game note validates its game and content', () async {
      await expectLater(
        repository.addGameNote(999, 'Note'),
        throwsA(isA<GameNotFoundException>()),
      );

      await repository.addGame(game);

      await expectLater(
        repository.addGameNote(game.id, '   '),
        throwsA(isA<InvalidGameNoteException>()),
      );
      expect(await repository.watchGameNotes(game.id).first, isEmpty);
    });

    test('updates a game note without changing its creation date', () async {
      await repository.addGame(game);
      await repository.addGameNote(game.id, 'Initial note');
      final initial = (await repository.watchGameNotes(game.id).first).single;

      now = now.add(const Duration(days: 1));
      await repository.updateGameNote(initial.id, '  Updated note  ');

      final updated = (await repository.watchGameNotes(game.id).first).single;
      expect(updated.content, 'Updated note');
      expect(updated.createdAt, initial.createdAt);

      await expectLater(
        repository.updateGameNote(initial.id, '   '),
        throwsA(isA<InvalidGameNoteException>()),
      );
      await expectLater(
        repository.updateGameNote(999, 'Missing'),
        throwsA(isA<GameNoteNotFoundException>()),
      );
    });

    test('removes a game note and reports a missing note', () async {
      await repository.addGame(game);
      await repository.addGameNote(game.id, 'Temporary note');
      final note = (await repository.watchGameNotes(game.id).first).single;

      await repository.removeGameNote(note.id);

      expect(await repository.watchGameNotes(game.id).first, isEmpty);
      await expectLater(
        repository.removeGameNote(note.id),
        throwsA(isA<GameNoteNotFoundException>()),
      );
    });

    test('deleting a game cascades its general notes', () async {
      await repository.addGame(game);
      await repository.addGameNote(game.id, 'Persisted note');

      await repository.removeGame(game.id);

      expect(await database.select(database.gameNotes).get(), isEmpty);
    });
  });
}
