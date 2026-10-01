import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/data/demo/demo_library.dart';
import 'package:playtick/features/library/data/demo/library_demo_catalog.dart';
import 'package:playtick/features/library/data/drift_library_repository.dart';
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
}
