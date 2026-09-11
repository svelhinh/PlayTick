import 'package:flutter/material.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
import 'package:playtick/features/library/presentation/widgets/game_cover_image.dart';
import 'package:playtick/features/library/presentation/widgets/game_status_row.dart';
import 'package:playtick/l10n/app_localizations.dart';

final class GamesList extends StatelessWidget {
  const GamesList({
    required this.games,
    required this.onGamePressed,
    super.key,
  });

  final List<LibraryGame> games;
  final Future<void> Function(LibraryGame) onGamePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(appLoc.homeGamesListTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
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
              child: _GameCard(
                game: games[index],
                onPressed: () => onGamePressed(games[index]),
              ),
            ),
            itemCount: games.length,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

final class _GameCard extends StatelessWidget {
  const _GameCard({
    required this.game,
    this.onPressed,
  });

  final LibraryGame game;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return Row(
      children: [
        GameCoverImage(coverUrl: game.coverUrl),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                game.name,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              GameStatusRow(status: game.status),
              if (game.totalPlaytime.inSeconds > 0) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.schedule_outlined, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      game.totalPlaytime.localize(appLoc, withMinutes: false),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(appLoc.homeGamesListButtonText),
        ),
      ],
    );
  }
}
