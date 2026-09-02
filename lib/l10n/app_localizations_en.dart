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
  String get cancel => 'Cancel';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get gameAlreadyInLibrary => 'This game is already in your library.';

  @override
  String get gameNotFoundInLibrary => 'Game not found in your library.';

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

  @override
  String get gameDetailsDeleteGameTitle => 'Delete this game';

  @override
  String gameDetailsDeleteGameDescription(String name) {
    return 'Are you sure you want to delete \"$name\" from your library?\n\nThe game, its notes and all recorded sessions will be removed from this device. This action is irreversible.';
  }

  @override
  String get gameDetailsDeleteWarning => 'No data will be saved locally.';

  @override
  String get gameDetailsDeleteButton => 'Delete game';

  @override
  String get gameDetailsAboutGameTitle => 'About the game';

  @override
  String get gameDetailsGenresTitle => 'Genres';

  @override
  String get gameDetailsDeveloperTitle => 'Developer';

  @override
  String get gameDetailsPublisherTitle => 'Publisher';

  @override
  String get gameDetailsPlatformsTitle => 'Platforms';

  @override
  String get gameDetailsEstimatedPlaytimesTitle => 'Estimated playtimes';

  @override
  String gameDetailsEstimatedPlaytimesStory(String playtime) {
    return 'Story: $playtime';
  }

  @override
  String gameDetailsEstimatedPlaytimesMain(String playtime) {
    return 'Main: $playtime';
  }

  @override
  String gameDetailsEstimatedPlaytimesCompletion(String playtime) {
    return 'Completion: $playtime';
  }
}
