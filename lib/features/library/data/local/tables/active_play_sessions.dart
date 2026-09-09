import 'package:drift/drift.dart';
import 'package:playtick/features/library/data/local/tables/user_games.dart';

@DataClassName('ActivePlaySessionRow')
class ActivePlaySessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get gameId =>
      integer().references(UserGames, #gameId, onDelete: KeyAction.cascade)();
  DateTimeColumn get startedAt => dateTime()();
}
