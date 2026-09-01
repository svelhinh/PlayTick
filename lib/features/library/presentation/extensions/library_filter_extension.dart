import 'package:flutter/material.dart';
import 'package:playtick/features/library/domain/library_filter.dart';
import 'package:playtick/l10n/app_localizations.dart';

extension LibraryFilterExtension on LibraryFilter {
  String localize(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    switch (this) {
      case LibraryFilter.all:
        return appLoc.libraryFilterAll;
      case LibraryFilter.wantToPlay:
        return appLoc.libraryFilterWantToPlay;
      case LibraryFilter.playing:
        return appLoc.libraryFilterPlaying;
      case LibraryFilter.completed:
        return appLoc.libraryFilterCompleted;
      case LibraryFilter.dropped:
        return appLoc.libraryFilterDropped;
    }
  }
}
