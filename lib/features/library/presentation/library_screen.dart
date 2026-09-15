import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:playtick/app/router/app_router.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/core/presentation/widgets/error_state_card.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_filter.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/features/library/domain/library_search_results.dart';
import 'package:playtick/features/library/presentation/extensions/game_status_extension.dart';
import 'package:playtick/features/library/presentation/extensions/game_subtitle_extension.dart';
import 'package:playtick/features/library/presentation/extensions/library_exception_extension.dart';
import 'package:playtick/features/library/presentation/extensions/library_filter_extension.dart';
import 'package:playtick/features/library/presentation/providers/library_filter_notifier_provider.dart';
import 'package:playtick/features/library/presentation/providers/library_games_provider.dart';
import 'package:playtick/features/library/presentation/providers/library_search_games_provider.dart';
import 'package:playtick/features/library/presentation/providers/library_search_notifier_provider.dart';
import 'package:playtick/features/library/presentation/widgets/game_cover_image.dart';
import 'package:playtick/features/library/presentation/widgets/igdb_game_card.dart';
import 'package:playtick/features/library/presentation/widgets/library_game_card.dart';
import 'package:playtick/features/library/providers/library_repository_provider.dart';
import 'package:playtick/l10n/app_localizations.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLoc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final gamesAsync = ref.watch(libraryGamesProvider);
    final filter = ref.watch(libraryFilterProvider);
    final search = ref.watch(librarySearchProvider);
    final igdbGamesAsync = ref.watch(librarySearchGamesProvider);

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
                const SizedBox(height: 12),
                const _SearchBar(),
              ],
            ),
          ),
          Expanded(
            child: gamesAsync.when(
              data: (games) {
                if (games.isEmpty && search.isEmpty) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: EmptyStateCard(
                        icon: Icons.library_books_outlined,
                        title: appLoc.libraryEmptyStateTitle,
                        description: appLoc.libraryEmptyStateDescription,
                      ),
                    ),
                  );
                }

                if (search.isNotEmpty) {
                  final igdbGames = igdbGamesAsync.value ?? [];
                  final searchResults = LibrarySearchResults.merge(
                    search,
                    games,
                    igdbGames,
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ListView(
                      children: [
                        if (searchResults.libraryGames.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _LibraryGamesList(
                            games: searchResults.libraryGames,
                            showTitle: true,
                          ),
                        ],

                        const SizedBox(height: 12),

                        if (searchResults.igdbGames.isEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appLoc.igdbSearchResultsTitle,
                                style: theme.textTheme.titleSmall,
                              ),
                              const SizedBox(height: 12),
                              if (igdbGamesAsync.isLoading)
                                const Center(child: CircularProgressIndicator())
                              else if (igdbGamesAsync.hasError)
                                ErrorStateCard(
                                  title: appLoc.igdbSearchCardErrorTitle,
                                  description:
                                      appLoc.igdbSearchCardErrorDescription,
                                  onRetry: () => ref.invalidate(
                                    librarySearchGamesProvider,
                                  ),
                                  compact: true,
                                )
                              else
                                EmptyStateCard(
                                  icon: Icons.search_off_outlined,
                                  title: appLoc.librarySearchNoResultsTitle,
                                  description:
                                      appLoc.librarySearchNoResultsDescription,
                                ),
                            ],
                          )
                        else if (searchResults.igdbGames.isNotEmpty) ...[
                          _IgdbGamesList(games: searchResults.igdbGames),
                        ],
                      ],
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
                    const SizedBox(height: 12),
                    if (search.isEmpty) ...[
                      const _LibraryGamesFilters(),
                      if (filteredGames.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          child: EmptyStateCard(
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
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 24,
                            left: 24,
                            top: 12,
                          ),
                          child: _LibraryGamesList(games: filteredGames),
                        ),
                    ],
                    const SizedBox(height: 12),
                  ],
                );
              },
              error: (error, stackTrace) => Center(
                child: ErrorStateCard(
                  title: appLoc.somethingWentWrong,
                  description: appLoc.somethingWentWrongDescription,
                  onRetry: () => ref.invalidate(libraryGamesProvider),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}

final class _SearchBar extends ConsumerStatefulWidget {
  const _SearchBar();

  @override
  ConsumerState<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<_SearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    ref.read(librarySearchProvider.notifier).search('');
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hasQuery = ref.watch(librarySearchProvider).isNotEmpty;

    return Focus(
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return TextField(
            controller: _controller,
            onChanged: (value) {
              ref.read(librarySearchProvider.notifier).search(value);
            },
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: appLoc.librarySearchHintText,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: hasQuery
                  ? IconButton(
                      onPressed: _clear,
                      icon: const Icon(Icons.close),
                    )
                  : null,
              filled: true,
              fillColor: isFocused
                  ? theme.colorScheme.surface
                  : theme.colorScheme.surfaceContainerLow,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline,
                  width: 2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

final class _LibraryGamesFilters extends ConsumerWidget {
  const _LibraryGamesFilters();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filter = ref.watch(libraryFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    labelStyle: theme.textTheme.bodyLarge?.copyWith(
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
    );
  }
}

final class _LibraryGamesList extends StatelessWidget {
  const _LibraryGamesList({
    required this.games,
    this.showTitle = false,
  });

  final List<LibraryGame> games;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (showTitle)
              Text(
                appLoc.librarySearchResultsTitle,
                style: theme.textTheme.titleSmall,
              ),
            Text(
              appLoc.libraryGamesCount(games.length),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: LibraryGameCard(
                game: games[index],
                onPressed: () => context.push(
                  AppRoutes.gameDetailsPath(
                    games[index].gameId.toString(),
                  ),
                ),
              ),
            ),
            itemCount: games.length,
          ),
        ),
      ],
    );
  }
}

final class _IgdbGamesList extends ConsumerWidget {
  const _IgdbGamesList({
    required this.games,
  });

  final List<Game> games;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLoc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLoc.igdbSearchResultsTitle,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              child: IgdbGameCard(
                game: games[index],
                onPressed: () async {
                  await showModalBottomSheet<void>(
                    context: context,
                    useSafeArea: true,
                    showDragHandle: true,
                    isScrollControlled: true,
                    builder: (context) => _AddGameSheet(
                      onAdd: (game, status) async {
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
                                content: Text(e.localizeLibraryError(appLoc)),
                              ),
                            );
                          }
                        }
                      },
                      game: games[index],
                    ),
                  );
                },
              ),
            ),
            itemCount: games.length,
          ),
        ),
      ],
    );
  }
}

class _AddGameSheet extends StatefulWidget {
  const _AddGameSheet({required this.game, required this.onAdd});

  final Game game;
  final void Function(Game, GameStatus) onAdd;

  @override
  State<_AddGameSheet> createState() => _AddGameSheetState();
}

class _AddGameSheetState extends State<_AddGameSheet> {
  GameStatus _selectedStatus = GameStatus.wantToPlay;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GameCoverImage(coverUrl: widget.game.coverUrl),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.game.name, style: theme.textTheme.titleMedium),
                  if (widget.game.subtitle != null) ...[
                    Text(
                      widget.game.subtitle!,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            appLoc.addGameSheetSelectStatus,
            style: theme.textTheme.titleSmall,
          ),
          RadioGroup<GameStatus>(
            groupValue: _selectedStatus,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedStatus = value);
              }
            },
            child: Column(
              children: [
                for (final status in GameStatus.values)
                  InkWell(
                    onTap: () => setState(() => _selectedStatus = status),
                    child: Row(
                      children: [
                        Radio<GameStatus>(value: status),
                        Text(
                          status.localize(context),
                          style: theme.textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => widget.onAdd(widget.game, _selectedStatus),
              child: Text(appLoc.add),
            ),
          ),
        ],
      ),
    );
  }
}
