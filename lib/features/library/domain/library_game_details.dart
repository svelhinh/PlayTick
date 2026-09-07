import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/play_session.dart';

final class LibraryGameDetails {
  const LibraryGameDetails({
    required this.game,
    required this.status,
    this.totalPlaytime = Duration.zero,
    this.playSessions = const [],
  });

  final Game game;
  final Duration totalPlaytime;
  final GameStatus status;
  final List<PlaySession> playSessions;
}
