import 'package:drift_flutter/drift_flutter.dart';
import 'package:playtick/core/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase database(Ref ref) {
  final database = AppDatabase(driftDatabase(name: 'playtick'));

  ref.onDispose(database.close);

  return database;
}
