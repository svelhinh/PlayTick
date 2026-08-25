import 'package:flutter/material.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/l10n/app_localizations.dart';

extension GameStatusLocalization on GameStatus {
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
