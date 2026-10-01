import 'package:drift_flutter/drift_flutter.dart';
import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/data/igdb/igdb_credentials.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

String databaseNameFor(IgdbCredentials credentials) {
  return credentials.isConfigured ? 'playtick' : 'playtick_demo';
}

@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  final database = AppDatabase(
    driftDatabase(
      name: databaseNameFor(IgdbCredentials.fromEnvironment()),
    ),
  );

  ref.onDispose(database.close);

  return database;
}
