import 'package:playtick/features/library/domain/library_game_details.dart';
import 'package:playtick/features/library/presentation/providers/library_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_game_provider.g.dart';

@riverpod
Stream<LibraryGameDetails?> libraryGame(Ref ref, int gameId) {
  return ref.read(libraryRepositoryProvider).watchGame(gameId);
}
