import 'package:flutter/material.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
import 'package:playtick/features/library/presentation/widgets/game_status_row.dart';
import 'package:playtick/l10n/app_localizations.dart';

class LibraryGameCard extends StatelessWidget {
  const LibraryGameCard({
    required this.game,
    super.key,
    this.onTap,
    this.onSeeDetails,
  });

  final LibraryGame game;
  final VoidCallback? onTap;
  final VoidCallback? onSeeDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: game.coverUrl != null
                  ? Image.network(
                      game.coverUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.gamepad),
                    )
                  : const Icon(Icons.gamepad),
            ),
          ),
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
                if (game.status != GameStatus.wantToPlay &&
                    game.totalPlaytime.inSeconds > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.schedule_outlined, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        game.totalPlaytime.localizePlaytime(appLoc),
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
              onPressed: onSeeDetails,
              child: Text(appLoc.libraryGameCardSeeDetails),
            ),
          ),
        ],
      ),
    );
  }
}
