import 'package:playtick/features/library/domain/game_status.dart';

enum LibraryFilter {
  all,
  wantToPlay,
  playing,
  completed,
  dropped;

  bool matchesGameStatus(GameStatus status) {
    switch (this) {
      case LibraryFilter.all:
        return true;
      case LibraryFilter.wantToPlay:
        return status == GameStatus.wantToPlay;
      case LibraryFilter.playing:
        return status == GameStatus.playing;
      case LibraryFilter.completed:
        return status == GameStatus.completed;
      case LibraryFilter.dropped:
        return status == GameStatus.dropped;
    }
  }
}
