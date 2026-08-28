import 'package:playtick/features/library/domain/game_status.dart';

final class LibraryGame {
  const LibraryGame({
    required this.gameId,
    required this.name,
    required this.status,
    this.coverUrl,
    this.totalPlaytime = Duration.zero,
  });

  final int gameId;
  final String name;
  final GameStatus status;
  final String? coverUrl;
  final Duration totalPlaytime;
}
