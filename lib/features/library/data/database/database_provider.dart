import 'dart:async';

import 'package:drift_flutter/drift_flutter.dart';
import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/data/demo/demo_library_helper.dart';
import 'package:playtick/features/library/data/drift_library_repository.dart';
import 'package:playtick/features/library/data/igdb/igdb_credentials.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

String databaseNameFor(IgdbCredentials credentials) {
  return credentials.isConfigured ? 'playtick' : 'playtick_demo';
}

@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  final name = databaseNameFor(IgdbCredentials.fromEnvironment());
  late final AppDatabase database;

  database = AppDatabase(
    driftDatabase(name: name),
    onCreated: name == 'playtick_demo'
        ? () => seedDemoLibrary(
            DriftLibraryRepository(database),
            now: DateTime.now(),
          )
        : null,
  );

  if (name == 'playtick_demo') {
    unawaited(fillMissingDemoCovers(database));
  }

  ref.onDispose(database.close);
  return database;
}
