import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:playtick/app/router/app_router.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/features/library/domain/library_filter.dart';
import 'package:playtick/features/library/presentation/extensions/library_filter_extension.dart';
import 'package:playtick/features/library/presentation/providers/library_filter_notifier_provider.dart';
import 'package:playtick/features/library/presentation/providers/library_games_provider.dart';
import 'package:playtick/features/library/presentation/providers/library_repository_provider.dart';
import 'package:playtick/features/library/presentation/temporary_game_factory.dart';
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
    final filter = ref.watch(libraryFilterProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(appLoc.libraryTitle, style: theme.textTheme.headlineLarge),
                const SizedBox(height: 4),
                Text(appLoc.librarySubtitle, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Expanded(
            child: games.when(
              data: (games) {
                if (games.isEmpty) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: EmptyStateCard(
                        icon: Icons.library_books_outlined,
                        title: appLoc.libraryEmptyStateTitle,
                        description: appLoc.libraryEmptyStateDescription,
                        action: const _AddGameButton(),
                      ),
                    ),
                  );
                }

                final filteredGames = filter == LibraryFilter.all
                    ? games
                    : games
                          .where(
                            (game) => filter.matchesGameStatus(game.status),
                          )
                          .toList();

                return ListView(
                  children: [
                    const _AddGameButton(key: Key('add-game-button')),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Row(
                          children: LibraryFilter.values
                              .map(
                                (libraryFilter) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: ChoiceChip(
                                    label: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minWidth: 72,
                                      ),
                                      child: Text(
                                        libraryFilter.localize(context),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ),
                                    ),
                                    side: BorderSide(
                                      color: theme.colorScheme.outline,
                                    ),
                                    selectedColor: theme.colorScheme.primary,
                                    showCheckmark: false,
                                    labelStyle: theme.textTheme.bodyLarge
                                        ?.copyWith(
                                          color: libraryFilter == filter
                                              ? theme.colorScheme.onPrimary
                                              : theme.colorScheme.onSurface,
                                        ),
                                    selected: libraryFilter == filter,
                                    onSelected: (value) {
                                      if (value) {
                                        ref
                                            .read(
                                              libraryFilterProvider.notifier,
                                            )
                                            .select(libraryFilter);
                                      }
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          if (filteredGames.isEmpty)
                            EmptyStateCard(
                              icon: Icons.library_books_outlined,
                              title: appLoc.libraryFilterEmptyStateTitle,
                              description:
                                  appLoc.libraryFilterEmptyStateDescription,
                              action: FilledButton(
                                onPressed: () {
                                  ref
                                      .read(libraryFilterProvider.notifier)
                                      .select(LibraryFilter.all);
                                },
                                child: Text(
                                  appLoc.libraryFilterEmptyStateButtonText,
                                ),
                              ),
                            )
                          else ...[
                            Text(
                              appLoc.libraryGamesCount(filteredGames.length),
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
                                    game: filteredGames[index],
                                    onStatusChange: (status) => ref
                                        .read(libraryRepositoryProvider)
                                        .updateGameStatus(
                                          filteredGames[index].gameId,
                                          status,
                                        ),
                                    onTap: () => context.push(
                                      AppRoutes.gameDetailsPath(
                                        filteredGames[index].gameId.toString(),
                                      ),
                                    ),
                                    onSeeDetails: () => context.push(
                                      AppRoutes.gameDetailsPath(
                                        filteredGames[index].gameId.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                itemCount: filteredGames.length,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              },
              error: (error, stackTrace) => Text(error.toString()),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
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
      onPressed: () async {
        final temporaryGame = createTemporaryGame();
        final status = randomTemporaryGameStatus();

        await showModalBottomSheet<void>(
          context: context,
          useSafeArea: true,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (context) => AddGameSheet(
            onAdd: (game) async {
              try {
                await ref
                    .read(libraryRepositoryProvider)
                    .addGame(game, status: status);

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
            game: temporaryGame,
          ),
        );
      },
      label: const Text('Add a game'),
    );
  }
}
