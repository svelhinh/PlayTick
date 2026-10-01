import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/data/demo/library_demo_catalog.dart';
import 'package:playtick/features/library/data/drift_library_repository.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_repository.dart';

Future<void> seedDemoLibrary(
  LibraryRepository repository, {
  required DateTime now,
}) async {
  final games = LibraryDemoCatalog.games;

  // Add games
  await repository.addGame(games[0], status: GameStatus.playing);
  await repository.addGame(games[1], status: GameStatus.completed);
  await repository.addGame(games[2]);
  await repository.addGame(games[3], status: GameStatus.dropped);
  await repository.addGame(games[4], status: GameStatus.playing);

  // Add play sessions
  await repository.addPlaySession(games[0].id, now, const Duration(hours: 1));
  await repository.addPlaySession(
    games[1].id,
    now.subtract(const Duration(days: 2)),
    const Duration(hours: 2),
  );
  await repository.addPlaySession(
    games[2].id,
    now.subtract(const Duration(days: 1)),
    const Duration(hours: 3),
  );

  // Add notes
  await repository.addGameNote(
    games[0].id,
    'This is a note for the first game',
  );
}

Future<void> restoreDemoLibrary(
  AppDatabase database, {
  required DateTime now,
}) async {
  await database.delete(database.userGames).go();
  await database.delete(database.games).go();

  await seedDemoLibrary(
    DriftLibraryRepository(database, now: () => now),
    now: now,
  );
}
