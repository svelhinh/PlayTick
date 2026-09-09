import 'package:flutter/material.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
import 'package:playtick/features/library/presentation/widgets/game_cover_image.dart';
import 'package:playtick/features/library/presentation/widgets/game_status_row.dart';
import 'package:playtick/l10n/app_localizations.dart';

class LibraryGameCard extends StatelessWidget {
  const LibraryGameCard({
    required this.game,
    super.key,
    this.onPressed,
  });

  final LibraryGame game;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onPressed,
      child: Row(
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
          SizedBox(
            height: 40,
            child: FilledButton(
              onPressed: onPressed,
              child: Text(appLoc.libraryGameCardSeeDetails),
            ),
          ),
        ],
      ),
    );
  }
}
