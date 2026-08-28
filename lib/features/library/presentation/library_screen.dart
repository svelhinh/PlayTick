import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/features/library/domain/estimated_playtimes.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/presentation/providers/library_games_provider.dart';
import 'package:playtick/features/library/presentation/providers/library_repository_provider.dart';
import 'package:playtick/features/library/presentation/widgets/add_game_sheet.dart';
import 'package:playtick/features/library/presentation/widgets/library_game_card.dart';
import 'package:playtick/l10n/app_localizations.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLoc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final games = ref.watch(libraryGamesProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(appLoc.libraryTitle, style: theme.textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text(appLoc.librarySubtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            Expanded(
              child: games.when(
                data: (games) => games.isEmpty
                    ? ListView(
                        children: [
                          EmptyStateCard(
                            icon: Icons.library_books_outlined,
                            title: appLoc.libraryEmptyStateTitle,
                            description: appLoc.libraryEmptyStateDescription,
                          ),
                          const SizedBox(height: 12),
                          const _AddGameButton(),
                        ],
                      )
                    : ListView(
                        children: [
                          const _AddGameButton(key: Key('add-game-button')),
                          const SizedBox(height: 12),
                          Text(
                            appLoc.libraryGamesCount(games.length),
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          Card(
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(12),
                              separatorBuilder: (context, index) =>
                                  const Divider(),
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: LibraryGameCard(
                                  game: games[index],
                                  onRemove: () => ref
                                      .read(libraryRepositoryProvider)
                                      .removeGame(games[index].gameId),
                                  onStatusChange: (status) => ref
                                      .read(libraryRepositoryProvider)
                                      .updateGameStatus(
                                        games[index].gameId,
                                        status,
                                      ),
                                ),
                              ),
                              itemCount: games.length,
                            ),
                          ),
                        ],
                      ),
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddGameButton extends ConsumerWidget {
  const _AddGameButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.icon(
      icon: const Icon(Icons.add),
      onPressed: () => showModalBottomSheet<AddGameSheet>(
        context: context,
        useSafeArea: true,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) => AddGameSheet(
          onAdd: (game) async {
            try {
              await ref.read(libraryRepositoryProvider).addGame(game);

              if (context.mounted) {
                Navigator.pop(context);
              }
            } on Exception catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString()),
                  ),
                );
              }
            }
          },
          game: Game(
            id: 1,
            name: 'Hollow Knight',
            summary:
                'A game about a knight who fights '
                'monsters',
            releaseDate: DateTime(2017, 2, 24),
            genres: ['Action', 'Adventure', 'Platformer'],
            developer: 'Team Cherry',
            publisher: 'Team Cherry',
            estimatedPlaytimes: const EstimatedPlaytimes(
              story: Duration(hours: 10),
              main: Duration(hours: 20),
              completion: Duration(hours: 30),
            ),
            platforms: ['PC', 'Switch'],
            coverUrl: 'https://example.com/cover.jpg',
          ),
        ),
      ),
      label: const Text('Add a game'),
    );
  }
}
