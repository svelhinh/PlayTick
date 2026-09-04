import 'package:flutter/material.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/presentation/extensions/game_subtitle_extension.dart';
import 'package:playtick/features/library/presentation/widgets/game_cover_image.dart';
import 'package:playtick/l10n/app_localizations.dart';

class IgdbGameCard extends StatelessWidget {
  const IgdbGameCard({
    required this.game,
    super.key,
    this.onPressed,
  });

  final Game game;
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
                if (game.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    game.subtitle!,
                    style: theme.textTheme.bodySmall,
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
              child: Row(
                children: [
                  const Icon(Icons.add),
                  const SizedBox(width: 4),
                  Text(appLoc.add),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
