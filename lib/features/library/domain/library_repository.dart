import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/features/library/domain/library_game_details.dart';

abstract interface class LibraryRepository {
  Stream<List<LibraryGame>> watchLibraryGames();
  Stream<LibraryGameDetails?> watchGame(int gameId);
  Future<void> addGame(Game game, {GameStatus status = GameStatus.wantToPlay});
  Future<void> updateGameStatus(int gameId, GameStatus status);
  Future<void> removeGame(int gameId);
}
