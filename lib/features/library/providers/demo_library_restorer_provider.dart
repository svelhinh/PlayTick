import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/data/database/database_provider.dart';
import 'package:playtick/features/library/data/demo/demo_library_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'demo_library_restorer_provider.g.dart';

@Riverpod(keepAlive: true)
DemoLibraryRestorer demoLibraryRestorer(Ref ref) {
  return DemoLibraryRestorer(ref.watch(databaseProvider));
}

final class DemoLibraryRestorer {
  const DemoLibraryRestorer(this._database);

  final AppDatabase _database;

  Future<void> restore() {
    return restoreDemoLibrary(_database, now: DateTime.now());
  }
}
