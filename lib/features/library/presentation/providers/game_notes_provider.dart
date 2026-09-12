import 'package:playtick/features/library/domain/game_note.dart';
import 'package:playtick/features/library/providers/library_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_notes_provider.g.dart';

@riverpod
Stream<List<GameNote>> gameNotes(Ref ref, int gameId) {
  return ref.read(libraryRepositoryProvider).watchGameNotes(gameId);
}
