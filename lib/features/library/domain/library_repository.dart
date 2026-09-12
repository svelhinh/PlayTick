import 'package:playtick/features/library/domain/active_play_session.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_note.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/features/library/domain/library_game_details.dart';

abstract interface class LibraryRepository {
  // Games
  Stream<List<LibraryGame>> watchLibraryGames();
  Stream<LibraryGameDetails?> watchGame(int gameId);
  Future<void> addGame(Game game, {GameStatus status = GameStatus.wantToPlay});
  Future<void> updateGameStatus(int gameId, GameStatus status);
  Future<void> removeGame(int gameId);

  // Play Sessions
  Future<void> addPlaySession(
    int gameId,
    DateTime date,
    Duration duration, {
    String? note,
  });
  Future<void> updatePlaySession(
    int sessionId,
    DateTime date,
    Duration duration, {
    String? note,
  });
  Future<void> removePlaySession(int sessionId);

  // Weekly Playtime
  Stream<Duration> watchWeeklyPlaytime();

  // Active Play Session
  Stream<ActivePlaySession?> watchActivePlaySession();
  Future<void> startActivePlaySession(int gameId);
  Future<void> clearActivePlaySession();
  Future<void> finishActivePlaySession(Duration duration, {String? note});

  // Game Notes
  Stream<List<GameNote>> watchGameNotes(int gameId);
  Future<void> addGameNote(int gameId, String content);
  Future<void> updateGameNote(int noteId, String content);
  Future<void> removeGameNote(int noteId);
}
