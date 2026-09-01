import 'package:flutter/material.dart';
import 'package:playtick/app/app_theme.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/l10n/app_localizations.dart';

extension GameStatusExtension on GameStatus {
  Color statusColor(BuildContext context) {
    final theme = Theme.of(context);

    switch (this) {
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

  String localize(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    switch (this) {
      case GameStatus.wantToPlay:
        return appLoc.gameStatusWantToPlay;
      case GameStatus.playing:
        return appLoc.gameStatusPlaying;
      case GameStatus.completed:
        return appLoc.gameStatusCompleted;
      case GameStatus.dropped:
        return appLoc.gameStatusDropped;
    }
  }
}
