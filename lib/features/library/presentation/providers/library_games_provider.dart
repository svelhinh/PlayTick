import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/features/library/providers/library_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_games_provider.g.dart';

@riverpod
Stream<List<LibraryGame>> libraryGames(Ref ref) {
  return ref.read(libraryRepositoryProvider).watchLibraryGames();
}
