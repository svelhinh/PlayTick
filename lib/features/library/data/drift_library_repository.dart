import 'package:drift/drift.dart';
import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/domain/estimated_playtimes.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_exception.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/features/library/domain/library_game_details.dart';
import 'package:playtick/features/library/domain/library_repository.dart';
import 'package:playtick/features/library/domain/play_session.dart';

class DriftLibraryRepository implements LibraryRepository {
  DriftLibraryRepository(
    this._database, {
    DateTime Function()? now,
  }) : _now = now ?? (() => DateTime.now().toUtc());

  final AppDatabase _database;
  final DateTime Function() _now;

  @override
  Stream<List<LibraryGame>> watchLibraryGames() {
    final query =
        _database.select(_database.userGames).join([
          innerJoin(
            _database.games,
            _database.games.id.equalsExp(_database.userGames.gameId),
          ),
          leftOuterJoin(
            _database.playSessions,
            _database.playSessions.gameId.equalsExp(_database.userGames.gameId),
          ),
        ])..orderBy([
          OrderingTerm.desc(_database.userGames.addedAt),
        ]);

    return query.watch().map((rows) {
      final games = <int, LibraryGame>{};

      for (final row in rows) {
        final game = row.readTable(_database.games);
        final userGame = row.readTable(_database.userGames);
        final session = row.readTableOrNull(_database.playSessions);
        final sessionDuration = session == null
            ? Duration.zero
            : Duration(seconds: session.duration);

        final existing = games[game.id];
        if (existing == null) {
          games[game.id] = LibraryGame(
            gameId: game.id,
            name: game.name,
            coverUrl: game.coverUrl,
            status: userGame.status,
            totalPlaytime: sessionDuration,
          );
        } else {
          games[game.id] = LibraryGame(
            gameId: existing.gameId,
            name: existing.name,
            coverUrl: existing.coverUrl,
            status: existing.status,
            totalPlaytime: existing.totalPlaytime + sessionDuration,
          );
        }
      }

      return games.values.toList(growable: false);
    });
  }

  @override
  Stream<LibraryGameDetails?> watchGame(int gameId) {
    final query =
        _database.select(_database.userGames).join([
            innerJoin(
              _database.games,
              _database.games.id.equalsExp(_database.userGames.gameId),
            ),
            leftOuterJoin(
              _database.playSessions,
              _database.playSessions.gameId.equalsExp(
                _database.userGames.gameId,
              ),
            ),
          ])
          ..where(_database.userGames.gameId.equals(gameId))
          ..orderBy([OrderingTerm.desc(_database.playSessions.date)]);

    return query.watch().map((rows) {
      if (rows.isEmpty) {
        return null;
      }

      final game = rows.first.readTable(_database.games);
      final userGame = rows.first.readTable(_database.userGames);
      final playSessions = <PlaySession>[];

      for (final row in rows) {
        final session = row.readTableOrNull(_database.playSessions);
        if (session != null) {
          playSessions.add(_toPlaySession(session));
        }
      }

      return LibraryGameDetails(
        game: _toGame(game),
        status: userGame.status,
        playSessions: playSessions,
        totalPlaytime: playSessions.fold(
          Duration.zero,
          (sum, session) => sum + session.duration,
        ),
      );
    });
  }

  @override
  Future<void> addGame(
    Game game, {
    GameStatus status = GameStatus.wantToPlay,
  }) async {
    await _database.transaction(() async {
      await _database
          .into(_database.games)
          .insertOnConflictUpdate(
            GamesCompanion.insert(
              id: Value(game.id),
              name: game.name,
              coverUrl: Value(game.coverUrl),
              summary: Value(game.summary),
              releaseDate: Value(game.releaseDate),
              genres: game.genres,
              platforms: game.platforms,
              developer: Value(game.developer),
              publisher: Value(game.publisher),
              estimatedPlaytimesStory: Value(
                game.estimatedPlaytimes?.story?.inSeconds,
              ),
              estimatedPlaytimesMain: Value(
                game.estimatedPlaytimes?.main?.inSeconds,
              ),
              estimatedPlaytimesCompletion: Value(
                game.estimatedPlaytimes?.completion?.inSeconds,
              ),
            ),
          );

      final insertedUserGame = await _database
          .into(_database.userGames)
          .insertReturningOrNull(
            UserGamesCompanion.insert(
              gameId: Value(game.id),
              status: status,
              addedAt: _now(),
            ),
            mode: InsertMode.insertOrIgnore,
          );

      if (insertedUserGame == null) {
        throw const DuplicateGameException();
      }
    });
  }

  @override
  Future<void> updateGameStatus(int gameId, GameStatus status) async {
    final updatedRows =
        await (_database.update(
          _database.userGames,
        )..where((row) => row.gameId.equals(gameId))).write(
          UserGamesCompanion(
            status: Value(status),
          ),
        );

    if (updatedRows == 0) {
      throw const GameNotFoundException();
    }
  }

  @override
  Future<void> removeGame(int gameId) async {
    final deletedRows = await (_database.delete(
      _database.userGames,
    )..where((row) => row.gameId.equals(gameId))).go();

    if (deletedRows == 0) {
      throw const GameNotFoundException();
    }
  }

  @override
  Future<void> addPlaySession(
    int gameId,
    DateTime date,
    Duration duration, {
    String? note,
  }) async {
    final userGame = await (_database.select(
      _database.userGames,
    )..where((row) => row.gameId.equals(gameId))).getSingleOrNull();

    if (userGame == null) {
      throw const GameNotFoundException();
    }

    if (duration <= Duration.zero) {
      throw const InvalidPlaySessionException();
    }

    final trimmedNote = note?.trim();

    await _database
        .into(_database.playSessions)
        .insert(
          PlaySessionsCompanion.insert(
            gameId: gameId,
            date: date,
            duration: duration.inSeconds,
            note: Value(
              trimmedNote == null || trimmedNote.isEmpty ? null : trimmedNote,
            ),
          ),
        );
  }

  Game _toGame(GameRow game) {
    return Game(
      id: game.id,
      name: game.name,
      coverUrl: game.coverUrl,
      summary: game.summary,
      releaseDate: game.releaseDate,
      genres: game.genres,
      platforms: game.platforms,
      developer: game.developer,
      publisher: game.publisher,
      estimatedPlaytimes: EstimatedPlaytimes(
        story: game.estimatedPlaytimesStory != null
            ? Duration(seconds: game.estimatedPlaytimesStory!)
            : null,
        main: game.estimatedPlaytimesMain != null
            ? Duration(seconds: game.estimatedPlaytimesMain!)
            : null,
        completion: game.estimatedPlaytimesCompletion != null
            ? Duration(seconds: game.estimatedPlaytimesCompletion!)
            : null,
      ),
    );
  }

  PlaySession _toPlaySession(PlaySessionRow session) {
    return PlaySession(
      id: session.id,
      gameId: session.gameId,
      date: session.date,
      duration: Duration(seconds: session.duration),
      note: session.note,
    );
  }
}
