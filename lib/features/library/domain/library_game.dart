enum GameStatus {
  wantToPlay,
  playing,
  completed,
  dropped,
}

final class LibraryGame {
  const LibraryGame({
    required this.igdbId,
    required this.title,
    required this.status,
    this.totalPlaytime = Duration.zero,
  });

  final int igdbId;
  final String title;
  final GameStatus status;
  final Duration totalPlaytime;
}
