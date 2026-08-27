import 'package:playtick/features/library/domain/game_status.dart';

final class UserGame {
  const UserGame({
    required this.gameId,
    required this.status,
    required this.addedAt,
  });

  final int gameId;
  final GameStatus status;
  final DateTime addedAt;
}
