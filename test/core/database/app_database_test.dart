import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/core/database/app_database.dart';
import 'package:playtick/core/database/database_provider.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('should be able to add a row', () async {
    final insertedId = await database
        .into(database.playTickTable)
        .insert(const PlayTickTableCompanion(title: Value('Test title')));

    final rows = await database.select(database.playTickTable).get();

    expect(rows.length, 1);
    expect(rows.single.id, insertedId);
    expect(rows.single.title, 'Test title');
  });

  test('riverpod can replace production database on tests', () async {
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
    );

    addTearDown(container.dispose);

    expect(container.read(databaseProvider), same(database));
  });
}
