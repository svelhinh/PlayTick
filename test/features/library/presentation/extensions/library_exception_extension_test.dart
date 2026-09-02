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
      Exception('drift connection failed').localizeLibraryError(appLoc),
      'Something went wrong',
    );
  });
}
