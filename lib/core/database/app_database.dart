import 'package:drift/drift.dart';

part 'app_database.g.dart';

class PlayTickTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 6, max: 32)();
}

@DriftDatabase(tables: [PlayTickTable])
final class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
