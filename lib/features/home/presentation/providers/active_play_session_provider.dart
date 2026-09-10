import 'package:playtick/features/library/domain/active_play_session.dart';
import 'package:playtick/features/library/providers/library_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_play_session_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<ActivePlaySession?> activePlaySession(Ref ref) {
  return ref.read(libraryRepositoryProvider).watchActivePlaySession();
}
