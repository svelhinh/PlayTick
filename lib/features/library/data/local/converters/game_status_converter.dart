import 'package:drift/drift.dart';
import 'package:playtick/features/library/domain/game_status.dart';

final class GameStatusConverter extends TypeConverter<GameStatus, String> {
  const GameStatusConverter();

  @override
  GameStatus fromSql(String fromDb) {
    return GameStatus.values.byName(fromDb);
  }

  @override
  String toSql(GameStatus value) {
    return value.name;
  }
}
