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

  @override
  String get libraryFilterEmptyStateTitle => 'No games matching your filter';

  @override
  String get libraryFilterEmptyStateDescription =>
      'Try a different filter to see your games.';

  @override
  String get libraryFilterEmptyStateButtonText => 'See all games';

  @override
  String get libraryFilterAll => 'All';

  @override
  String get libraryFilterWantToPlay => 'Want to play';

  @override
  String get libraryFilterPlaying => 'Playing';

  @override
  String get libraryFilterCompleted => 'Completed';

  @override
  String get libraryFilterDropped => 'Dropped';

  @override
  String get gameStatusWantToPlay => 'Want to play';

  @override
  String get gameStatusPlaying => 'Playing';

  @override
  String get gameStatusCompleted => 'Completed';

  @override
  String get gameStatusDropped => 'Dropped';

  @override
  String gamePlaytime(int hours, String minutes) {
    return '$hours h $minutes';
  }

  @override
  String libraryGamesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count games',
      one: '1 game',
      zero: 'No games',
    );
    return '$_temp0';
  }

  @override
  String get libraryGameCardSeeDetails => 'See';
}
