import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/domain/library_exception.dart';
import 'package:playtick/features/library/presentation/extensions/library_exception_extension.dart';
import 'package:playtick/l10n/app_localizations.dart';

void main() {
  test('localizes known library exceptions and falls back otherwise', () async {
    final appLoc = await AppLocalizations.delegate.load(const Locale('en'));

    expect(
      const DuplicateGameException().localizeLibraryError(appLoc),
      'This game is already in your library.',
    );
    expect(
      const GameNotFoundException().localizeLibraryError(appLoc),
      'Game not found in your library.',
    );
    expect(
      const InvalidPlaySessionException().localizeLibraryError(appLoc),
      'Invalid play session.',
    );
    expect(
      const PlaySessionNotFoundException().localizeLibraryError(appLoc),
      'Play session not found.',
    );
    expect(
      const InvalidActivePlaySessionException().localizeLibraryError(appLoc),
      'Invalid active play session.',
    );
    expect(
      const DuplicateActivePlaySessionException().localizeLibraryError(appLoc),
      'Duplicate active play session.',
    );
    expect(
      const ActivePlaySessionNotFoundException().localizeLibraryError(appLoc),
      'Active play session not found.',
    );
    expect(
      const InvalidGameNoteException().localizeLibraryError(appLoc),
      'Invalid game note.',
    );
    expect(
      const GameNoteNotFoundException().localizeLibraryError(appLoc),
      'Game note not found.',
    );
    expect(
      Exception('drift connection failed').localizeLibraryError(appLoc),
      'Something went wrong',
    );
  });

  test('localizes known library exceptions in French', () async {
    final appLoc = await AppLocalizations.delegate.load(const Locale('fr'));

    expect(
      const DuplicateGameException().localizeLibraryError(appLoc),
      'Ce jeu est déjà dans votre bibliothèque.',
    );
    expect(
      const GameNotFoundException().localizeLibraryError(appLoc),
      "Ce jeu n'est pas dans votre bibliothèque.",
    );
    expect(
      const InvalidPlaySessionException().localizeLibraryError(appLoc),
      'Session de jeu invalide.',
    );
    expect(
      const PlaySessionNotFoundException().localizeLibraryError(appLoc),
      'Session de jeu introuvable.',
    );
    expect(
      const InvalidActivePlaySessionException().localizeLibraryError(appLoc),
      'Session en cours invalide.',
    );
    expect(
      const DuplicateActivePlaySessionException().localizeLibraryError(appLoc),
      'Session en cours déjà existante.',
    );
    expect(
      const ActivePlaySessionNotFoundException().localizeLibraryError(appLoc),
      'Session en cours introuvable.',
    );
    expect(
      const InvalidGameNoteException().localizeLibraryError(appLoc),
      'Note de jeu invalide.',
    );
    expect(
      const GameNoteNotFoundException().localizeLibraryError(appLoc),
      'Note de jeu introuvable.',
    );
    expect(
      Exception('drift connection failed').localizeLibraryError(appLoc),
      'Une erreur est survenue',
    );
  });
}
