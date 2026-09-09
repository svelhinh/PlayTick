import 'package:playtick/features/library/providers/library_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weekly_playtime_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<Duration> weeklyPlaytime(Ref ref) {
  return ref.read(libraryRepositoryProvider).watchWeeklyPlaytime();
}
