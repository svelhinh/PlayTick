import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/presentation/providers/library_search_notifier_provider.dart';
import 'package:playtick/features/library/providers/library_search_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_search_games_provider.g.dart';

Duration? _skipIgdbSearchRetry(int _, Object _) => null;

@Riverpod(retry: _skipIgdbSearchRetry)
Future<List<Game>> librarySearchGames(Ref ref) async {
  final query = ref.watch(librarySearchProvider).trim();
  if (query.isEmpty) return [];

  await Future<void>.delayed(const Duration(milliseconds: 300));
  if (!ref.mounted) return [];

  return ref.read(librarySearchRepositoryProvider).searchGames(query);
}
