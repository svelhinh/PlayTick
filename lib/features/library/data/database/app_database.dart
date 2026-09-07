import 'package:drift/drift.dart';
import 'package:playtick/features/library/data/local/converters/game_status_converter.dart';
import 'package:playtick/features/library/data/local/converters/string_list_converter.dart';
import 'package:playtick/features/library/data/local/tables/games.dart';
import 'package:playtick/features/library/data/local/tables/play_sessions.dart';
import 'package:playtick/features/library/data/local/tables/user_games.dart';
import 'package:playtick/features/library/domain/game_status.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Games, UserGames, PlaySessions])
final class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(games);
        await migrator.createTable(userGames);
        await migrator.deleteTable('play_tick_table');
      }

      if (from < 3) {
        await migrator.createTable(playSessions);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
