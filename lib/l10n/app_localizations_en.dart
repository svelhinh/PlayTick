// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Play Tick';

  @override
  String get navigationLabelHome => 'Home';

  @override
  String get navigationLabelLibrary => 'Library';

  @override
  String get homeEmptyCardTitle => 'No game in progress';

  @override
  String get homeEmptyCardDescription =>
      'Add a game to your library to start tracking your sessions.';

  @override
  String get homeEmptyCardButtonText => 'Go to library';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your game collection';

  @override
  String get libraryEmptyStateTitle => 'Your library is empty';

  @override
  String get libraryEmptyStateDescription =>
      'Add your first game to start tracking your progress.';
}
