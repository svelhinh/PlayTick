import 'package:drift/drift.dart';
import 'package:playtick/features/library/data/local/converters/game_status_converter.dart';
import 'package:playtick/features/library/data/local/tables/games.dart';

@DataClassName('UserGameRow')
class UserGames extends Table {
  IntColumn get gameId => integer().references(Games, #id)();
  TextColumn get status => text().map(const GameStatusConverter())();
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {gameId};
}
