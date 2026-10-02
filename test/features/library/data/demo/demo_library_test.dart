import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/data/demo/demo_library_helper.dart';
import 'package:playtick/features/library/data/demo/library_demo_catalog.dart';
import 'package:playtick/features/library/data/drift_library_repository.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';

void main() {
  test(
    'seedDemoLibrary fills a representative library without an active session',
    () async {
      final database = AppDatabase(NativeDatabase.memory());
      final now = DateTime(2026, 10, 1, 12);
      final repository = DriftLibraryRepository(database, now: () => now);
      addTearDown(database.close);

      await seedDemoLibrary(repository, now: now);

      final games = await repository.watchLibraryGames().first;
      expect(games, hasLength(5));
      expect(
        games.map((game) => game.status).toSet(),
        {
          GameStatus.playing,
          GameStatus.completed,
          GameStatus.wantToPlay,
          GameStatus.dropped,
        },
      );

      final catalog = LibraryDemoCatalog.games;
      final playing = await repository.watchGame(catalog[0].id).first;
      final completed = await repository.watchGame(catalog[1].id).first;
      final wantToPlay = await repository.watchGame(catalog[2].id).first;

      expect(playing!.status, GameStatus.playing);
      expect(playing.game.coverUrl, catalog[0].coverUrl);
      expect(playing.playSessions.single.duration, const Duration(hours: 1));
      expect(completed!.playSessions.single.duration, const Duration(hours: 2));
      expect(
        wantToPlay!.playSessions.single.duration,
        const Duration(hours: 3),
      );

      final notes = await repository.watchGameNotes(catalog[0].id).first;
      expect(notes, hasLength(1));
      expect(notes.single.content, 'This is a note for the first game');

      expect(await repository.watchActivePlaySession().first, isNull);
      expect(
        await repository.watchWeeklyPlaytime().first,
        const Duration(hours: 6),
      );
    },
  );

  test('restoreDemoLibrary returns the seeded library and clears the active session', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final now = DateTime(2026, 10, 1, 12);
    final repository = DriftLibraryRepository(database, now: () => now);
    addTearDown(database.close);

    await seedDemoLibrary(repository, now: now);

    final catalog = LibraryDemoCatalog.games;
    await repository.updateGameStatus(catalog[1].id, GameStatus.wantToPlay);
    await repository.startActivePlaySession(catalog[0].id);

    final note = (await repository.watchGameNotes(catalog[0].id).first).single;
    await repository.updateGameNote(note.id, 'Changed note');

    await restoreDemoLibrary(database, now: now);

    final games = await repository.watchLibraryGames().first;
    expect(games, hasLength(5));

    final completed = await repository.watchGame(catalog[1].id).first;
    expect(completed!.status, GameStatus.completed);
    expect(completed.playSessions.single.duration, const Duration(hours: 2));

    final notes = await repository.watchGameNotes(catalog[0].id).first;
    expect(notes.single.content, 'This is a note for the first game');
    expect(await repository.watchActivePlaySession().first, isNull);
    expect(
      await repository.watchWeeklyPlaytime().first,
      const Duration(hours: 6),
    );
  });

  test('fillMissingDemoCovers sets a cover only when one is missing', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final repository = DriftLibraryRepository(
      database,
      now: () => DateTime(2026, 10),
    );
    addTearDown(database.close);

    final witcher = LibraryDemoCatalog.games.first;
    await repository.addGame(Game(id: witcher.id, name: witcher.name));

    await fillMissingDemoCovers(database);

    final filled = await repository.watchGame(witcher.id).first;
    expect(filled!.game.coverUrl, witcher.coverUrl);

    await (database.update(database.games)..where(
          (row) => row.id.equals(witcher.id),
        ))
        .write(
          const GamesCompanion(
            coverUrl: Value('https://example.com/custom.jpg'),
          ),
        );

    await fillMissingDemoCovers(database);

    final kept = await repository.watchGame(witcher.id).first;
    expect(kept!.game.coverUrl, 'https://example.com/custom.jpg');
  });
}
