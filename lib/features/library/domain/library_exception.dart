final class DuplicateGameException implements Exception {
  const DuplicateGameException(this.gameId);

  final int gameId;

  @override
  String toString() {
    return 'This game is already in your library.';
  }
}

final class GameNotFoundException implements Exception {
  const GameNotFoundException(this.gameId);

  final int gameId;

  @override
  String toString() {
    return 'Game not found in your library.';
  }
}
