import 'package:flutter/material.dart';
import 'package:playtick/features/library/domain/library_exception.dart';
import 'package:playtick/l10n/app_localizations.dart';

extension LibraryExceptionExtension on Exception {
  String localizeLibraryError(AppLocalizations appLoc) {
    return switch (this) {
      DuplicateGameException() => appLoc.gameAlreadyInLibrary,
      GameNotFoundException() => appLoc.gameNotFoundInLibrary,
      InvalidPlaySessionException() => appLoc.invalidPlaySessionException,
      PlaySessionNotFoundException() => appLoc.playSessionNotFoundException,
      InvalidActivePlaySessionException() =>
        appLoc.invalidActivePlaySessionException,
      DuplicateActivePlaySessionException() =>
        appLoc.duplicateActivePlaySessionException,
      ActivePlaySessionNotFoundException() =>
        appLoc.activePlaySessionNotFoundException,
      InvalidGameNoteException() => appLoc.invalidGameNoteException,
      GameNoteNotFoundException() => appLoc.gameNoteNotFoundException,
      _ => appLoc.somethingWentWrong,
    };
  }
}

extension LibraryErrorSnackBarExtension on BuildContext {
  void showLibraryErrorSnackBar(Exception e) {
    final theme = Theme.of(this);

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          e.localizeLibraryError(AppLocalizations.of(this)!),
          style: TextStyle(color: theme.colorScheme.onError),
        ),
        backgroundColor: theme.colorScheme.error,
      ),
    );
  }
}
