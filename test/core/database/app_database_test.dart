import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/data/database/database_provider.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('games, user games and play sessions tables start empty', () async {
    final games = await database.select(database.games).get();
    final userGames = await database.select(database.userGames).get();
    final playSessions = await database.select(database.playSessions).get();

    expect(games, isEmpty);
    expect(userGames, isEmpty);
    expect(playSessions, isEmpty);
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
