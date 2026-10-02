import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app.dart';
import 'package:playtick/features/home/presentation/providers/timer_now_provider.dart';
import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/data/database/database_provider.dart';
import 'package:playtick/features/library/data/demo/demo_library_helper.dart';
import 'package:playtick/features/library/data/demo/library_demo_catalog.dart';
import 'package:playtick/features/library/data/drift_library_repository.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/providers/library_repository_provider.dart';

void main() {
  testWidgets(
    'the demo badge restores the seeded library after confirmation',
    (tester) async {
      final now = DateTime(2026, 10, 1, 12);
      final database = AppDatabase(NativeDatabase.memory());
      final repository = DriftLibraryRepository(database, now: () => now);
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWith((_) => database),
          libraryRepositoryProvider.overrideWith((_) => repository),
          timerNowProvider.overrideWith((_) => Stream.value(now)),
        ],
      );
      addTearDown(() {
        container.dispose();
        unawaited(database.close());
      });

      await seedDemoLibrary(repository, now: now);

      final catalog = LibraryDemoCatalog.games;
      await repository.updateGameStatus(catalog[1].id, GameStatus.wantToPlay);
      await repository.updateGameStatus(catalog[4].id, GameStatus.dropped);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const PlayTick(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(
        find.widgetWithText(OutlinedButton, 'Launch'),
        warnIfMissed: false,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Active session'), findsOneWidget);
      expect(find.text('The Witcher 3: Wild Hunt'), findsOneWidget);

      await tester.tap(find.text('Demo'), warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(
        find.widgetWithText(FilledButton, 'Restore demo data'),
        warnIfMissed: false,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Cancel'), warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Active session'), findsOneWidget);
      final keptSession = await database
          .select(database.activePlaySessions)
          .get();
      expect(keptSession, hasLength(1));

      await tester.tap(
        find.widgetWithText(FilledButton, 'Restore demo data'),
        warnIfMissed: false,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(
        find.widgetWithText(TextButton, 'Restore demo data'),
        warnIfMissed: false,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Active session').evaluate().length, 0);
      final clearedSession = await database
          .select(database.activePlaySessions)
          .get();
      expect(clearedSession, isEmpty);

      final restoredMario = await (database.select(
        database.userGames,
      )..where((row) => row.gameId.equals(catalog[1].id))).getSingle();
      final restoredSouls = await (database.select(
        database.userGames,
      )..where((row) => row.gameId.equals(catalog[4].id))).getSingle();
      expect(restoredMario.status, GameStatus.completed);
      expect(restoredSouls.status, GameStatus.playing);

      final notes = await (database.select(
        database.gameNotes,
      )..where((row) => row.gameId.equals(catalog[0].id))).get();
      expect(notes.single.content, 'This is a note for the first game');
    },
  );
}
