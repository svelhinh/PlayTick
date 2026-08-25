import 'package:playtick/features/library/domain/library_game.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'temporary_library_games_provider.g.dart';

@riverpod
List<LibraryGame> temporaryLibraryGames(Ref ref) {
  return const [
    LibraryGame(
      igdbId: 123,
      title: 'Doom Eternal',
      status: GameStatus.wantToPlay,
    ),
    LibraryGame(
      igdbId: 124,
      title: 'Final Fantasy VII',
      status: GameStatus.playing,
      totalPlaytime: Duration(hours: 20),
    ),
    LibraryGame(
      igdbId: 125,
      title: 'The Legend of Zelda: Breath of the Wild',
      status: GameStatus.completed,
      totalPlaytime: Duration(hours: 30, minutes: 15),
    ),
    LibraryGame(
      igdbId: 126,
      title: 'The Last of Us II',
      status: GameStatus.dropped,
      totalPlaytime: Duration(hours: 5),
    ),
  ];
}
