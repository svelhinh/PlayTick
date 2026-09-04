import 'package:playtick/features/library/domain/game.dart';

extension GameSubtitleExtension on Game {
  String? get subtitle {
    if (developer != null) {
      if (releaseDate != null) {
        return '$developer • ${releaseDate!.year}';
      }
      return developer!;
    } else if (publisher != null) {
      if (releaseDate != null) {
        return '$publisher • ${releaseDate!.year}';
      }
      return publisher!;
    } else if (releaseDate != null) {
      return '${releaseDate!.year}';
    }

    return null;
  }
}
