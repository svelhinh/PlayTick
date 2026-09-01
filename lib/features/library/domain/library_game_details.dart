import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';

final class LibraryGameDetails {
  const LibraryGameDetails({
    required this.game,
    required this.status,
    this.totalPlaytime = Duration.zero,
  });

  final Game game;
  final Duration totalPlaytime;
  final GameStatus status;
}
