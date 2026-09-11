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
  String get add => 'Add';

  @override
  String get cancel => 'Cancel';

  @override
  String get retry => 'Retry';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get date => 'Date';

  @override
  String get hours => 'hours';

  @override
  String get minutes => 'minutes';

  @override
  String get validate => 'Validate';

  @override
  String get save => 'Save';

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
  String get homeWeeklyPlaytime => 'Playtime this week';

  @override
  String get homeTotalGames => 'Games in progress';

  @override
  String get homeActivePlaySession => 'Active session';

  @override
  String get homeActivePlaySessionStopButton => 'Stop';

  @override
  String get homeFinishActivePlaySession => 'Finished session';

  @override
  String get homeFinishActivePlaySessionEditDurationButton => 'Edit duration';

  @override
  String get homeFinishActivePlaySessionDurationLabel => 'Duration';

  @override
  String get homeFinishActivePlaySessionDeleteTitle =>
      'Delete the active session';

  @override
  String get homeFinishActivePlaySessionDeleteDescription =>
      'Are you sure you want to delete the active session?\n\nThe session and its note will be removed from this device. This action is irreversible.';

  @override
  String get homeFinishActivePlaySessionDeleteButton => 'Delete session';

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
  String get librarySearchHintText => 'Search for a game';

  @override
  String get librarySearchResultsTitle => 'In your library';

  @override
  String get librarySearchNoResultsTitle => 'No games found';

  @override
  String get librarySearchNoResultsDescription =>
      'No games match your search in your library or on IGDB.\n\nTry a different name or check the spelling.';

  @override
  String get igdbSearchResultsTitle => 'IGDB results';

  @override
  String get igdbSearchCardErrorTitle =>
      'Unable to retrieve external results at the moment.';

  @override
  String get igdbSearchCardErrorDescription =>
      'Check your connection or try again later.';

  @override
  String get addGameSheetSelectStatus => 'Add as';

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
  String gamePlaytimeMinutes(String minutes) {
    return '$minutes min';
  }

  @override
  String gamePlaytimeHoursMinutes(int hours, String minutes) {
    return '$hours h $minutes min';
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

  @override
  String get gameDetailsPlaySessionsTitle => 'Sessions';

  @override
  String get gameDetailsPlaySessionsAddButton => 'Add a session';

  @override
  String get gameDetailsPlaySessionsAddTitle => 'Add a session';

  @override
  String get gameDetailsPlaySessionsEditTitle => 'Edit a session';

  @override
  String get gameDetailsPlaySessionsDurationLabel => 'Session duration';

  @override
  String get gameDetailsPlaySessionsNoteLabel => 'Note (optional)';

  @override
  String get gameDetailsPlaySessionsHintText =>
      'What happened during this session?';

  @override
  String get gameDetailsPlaySessionsAddSaveButton => 'Add session';

  @override
  String get gameDetailsPlaySessionsEditSaveButton => 'Save session';

  @override
  String get gameDetailsPlaySessionsDeleteTitle => 'Delete this session';

  @override
  String get gameDetailsPlaySessionsDeleteDescription =>
      'Are you sure you want to delete this session?\n\nThe session and its note will be removed from this device. This action is irreversible.';

  @override
  String get gameDetailsPlaySessionsDeleteButton => 'Delete session';

  @override
  String get invalidPlaySessionException => 'Invalid play session.';

  @override
  String get playSessionNotFoundException => 'Play session not found.';
}
