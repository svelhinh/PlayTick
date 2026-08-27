import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'temporary_library_games_provider.g.dart';

@riverpod
List<LibraryGame> temporaryLibraryGames(Ref ref) {
  return const [
    LibraryGame(
      gameId: 123,
      name: 'Doom Eternal',
      status: GameStatus.wantToPlay,
    ),
    LibraryGame(
      gameId: 124,
      name: 'Final Fantasy VII',
      status: GameStatus.playing,
      totalPlaytime: Duration(hours: 20),
    ),
    LibraryGame(
      gameId: 125,
      name: 'The Legend of Zelda: Breath of the Wild',
      status: GameStatus.completed,
      totalPlaytime: Duration(hours: 30, minutes: 15),
    ),
    LibraryGame(
      gameId: 126,
      name: 'The Last of Us II',
      status: GameStatus.dropped,
      totalPlaytime: Duration(hours: 5),
    ),
  ];
}
