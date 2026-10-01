import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/data/demo/demo_library_helper.dart';
import 'package:playtick/features/library/data/demo/library_demo_catalog.dart';
import 'package:playtick/features/library/data/drift_library_repository.dart';

void main() {
  test('demo seed runs only when the database file is created', () async {
    final file = File(
      '${Directory.systemTemp.path}${Platform.pathSeparator}'
      'playtick_demo_seed_${DateTime.now().microsecondsSinceEpoch}.sqlite',
    );
    final now = DateTime(2026, 10, 1, 12);

    addTearDown(() {
      for (final suffix in ['', '-wal', '-shm']) {
        final sidecar = File('${file.path}$suffix');
        if (sidecar.existsSync()) {
          sidecar.deleteSync();
        }
      }
    });

    AppDatabase open() {
      late final AppDatabase database;
      database = AppDatabase(
        NativeDatabase(file),
        onCreated: () => seedDemoLibrary(
          DriftLibraryRepository(database, now: () => now),
          now: now,
        ),
      );
      return database;
    }

    final created = open();
    final createdRepository = DriftLibraryRepository(created, now: () => now);
    expect(await createdRepository.watchLibraryGames().first, hasLength(5));

    for (final game in LibraryDemoCatalog.games.take(5)) {
      await createdRepository.removeGame(game.id);
    }
    expect(await createdRepository.watchLibraryGames().first, isEmpty);
    await created.close();

    final reopened = open();
    addTearDown(reopened.close);
    final reopenedRepository = DriftLibraryRepository(reopened, now: () => now);

    expect(await reopenedRepository.watchLibraryGames().first, isEmpty);
  });
}
