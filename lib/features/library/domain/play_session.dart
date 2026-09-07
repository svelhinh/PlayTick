final class PlaySession {
  const PlaySession({
    required this.id,
    required this.gameId,
    required this.date,
    required this.duration,
    this.note,
  });

  final int id;
  final int gameId;
  final DateTime date;
  final Duration duration;
  final String? note;
}
