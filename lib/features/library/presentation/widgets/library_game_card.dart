import 'package:flutter/material.dart';
import 'package:playtick/app/app_theme.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/features/library/presentation/extensions/game_status_localization.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
import 'package:playtick/l10n/app_localizations.dart';

class LibraryGameCard extends StatelessWidget {
  const LibraryGameCard({
    required this.game,
    super.key,
    this.onRemove,
    this.onStatusChange,
  });

  final LibraryGame game;
  final VoidCallback? onRemove;
  final ValueChanged<GameStatus>? onStatusChange;

  Color _statusCircleColor(BuildContext context) {
    final theme = Theme.of(context);

    switch (game.status) {
      case GameStatus.wantToPlay:
        return AppTheme.warning;
      case GameStatus.playing:
        return theme.colorScheme.primary;
      case GameStatus.completed:
        return AppTheme.success;
      case GameStatus.dropped:
        return AppTheme.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.gamepad),
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
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _statusCircleColor(context),
                    ),
                  ),
                  const SizedBox(width: 4),
                  PopupMenuButton<GameStatus>(
                    onSelected: onStatusChange,
                    initialValue: game.status,
                    child: Text(game.status.localize(context)),
                    itemBuilder: (context) => GameStatus.values
                        .map<PopupMenuItem<GameStatus>>(
                          (status) => PopupMenuItem(
                            value: status,
                            child: Text(status.localize(context)),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
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
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.delete, color: AppTheme.danger),
        ),
      ],
    );
  }
}
