import 'package:drift/drift.dart';
import 'package:playtick/core/database/app_database.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_exception.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/features/library/domain/library_repository.dart';

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
        ])..orderBy([
          OrderingTerm.desc(_database.userGames.addedAt),
        ]);

    return query.watch().map((rows) {
      return rows
          .map((row) {
            final game = row.readTable(_database.games);
            final userGame = row.readTable(_database.userGames);

            return LibraryGame(
              gameId: game.id,
              name: game.name,
              coverUrl: game.coverUrl,
              status: userGame.status,
            );
          })
          .toList(growable: false);
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
        throw DuplicateGameException(game.id);
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
      throw GameNotFoundException(gameId);
    }
  }

  @override
  Future<void> removeGame(int gameId) async {
    final deletedRows = await (_database.delete(
      _database.userGames,
    )..where((row) => row.gameId.equals(gameId))).go();

    if (deletedRows == 0) {
      throw GameNotFoundException(gameId);
    }
  }
}
