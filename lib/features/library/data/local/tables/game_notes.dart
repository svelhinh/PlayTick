import 'package:drift/drift.dart';
import 'package:playtick/features/library/data/local/tables/user_games.dart';

@DataClassName('GameNoteRow')
class GameNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gameId =>
      integer().references(UserGames, #gameId, onDelete: KeyAction.cascade)();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
}
