import 'package:playtick/features/library/domain/game.dart';

// A dedicated IGDB search port keeps presentation off the HTTP client.
// ignore: one_member_abstracts
abstract interface class LibrarySearchRepository {
  Future<List<Game>> searchGames(String query);
}
