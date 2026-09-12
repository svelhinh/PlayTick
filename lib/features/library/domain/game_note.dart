final class GameNote {
  GameNote({
    required this.id,
    required this.gameId,
    required this.content,
    required this.createdAt,
  });

  final int id;
  final int gameId;
  final String content;
  final DateTime createdAt;
}
