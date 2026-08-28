import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/features/library/presentation/providers/library_games_provider.dart';
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
                        ],
                      )
                    : ListView(
                        children: [
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
                                child: LibraryGameCard(game: games[index]),
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
