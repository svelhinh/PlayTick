import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// The name of the app
  ///
  /// In en, this message translates to:
  /// **'Play Tick'**
  String get appName;

  /// The text of the button to add an item
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// The text of the button to cancel an action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// The text of the button to retry an action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// The error message general
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// The description of the error message general
  ///
  /// In en, this message translates to:
  /// **'Please try again later.'**
  String get somethingWentWrongDescription;

  /// The label of the date field in the add session sheet
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// The label of the hours field in the duration picker dialog
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// The label of the minutes field in the duration picker dialog
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// The text of the button to validate an action
  ///
  /// In en, this message translates to:
  /// **'Validate'**
  String get validate;

  /// The text of the button to save an action
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// The error message when a game is already in the library
  ///
  /// In en, this message translates to:
  /// **'This game is already in your library.'**
  String get gameAlreadyInLibrary;

  /// The error message when a game is not found in the library
  ///
  /// In en, this message translates to:
  /// **'Game not found in your library.'**
  String get gameNotFoundInLibrary;

  /// The label of the home navigation item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navigationLabelHome;

  /// The label of the library navigation item
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navigationLabelLibrary;

  /// The title of the empty card in the home screen
  ///
  /// In en, this message translates to:
  /// **'No game in progress'**
  String get homeEmptyCardTitle;

  /// The description of the empty card in the home screen
  ///
  /// In en, this message translates to:
  /// **'Add a game to your library to start tracking your sessions.'**
  String get homeEmptyCardDescription;

  /// The text of the button in the empty card in the home screen
  ///
  /// In en, this message translates to:
  /// **'Go to library'**
  String get homeEmptyCardButtonText;

  /// The title of the playtime this week section in the home screen
  ///
  /// In en, this message translates to:
  /// **'Playtime this week'**
  String get homeWeeklyPlaytime;

  /// The title of the games in progress section in the home screen
  ///
  /// In en, this message translates to:
  /// **'Games in progress'**
  String get homeTotalGames;

  /// The title of the active session section in the home screen
  ///
  /// In en, this message translates to:
  /// **'Active session'**
  String get homeActivePlaySession;

  /// The text of the button to stop the active session in the home screen
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get homeActivePlaySessionStopButton;

  /// The title of the finished session section in the home screen
  ///
  /// In en, this message translates to:
  /// **'Finished session'**
  String get homeFinishActivePlaySession;

  /// The text of the button to edit the duration of the active session in the home screen
  ///
  /// In en, this message translates to:
  /// **'Edit duration'**
  String get homeFinishActivePlaySessionEditDurationButton;

  /// The label of the duration label in the finish active play session sheet
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get homeFinishActivePlaySessionDurationLabel;

  /// The title of the delete active session dialog in the home screen
  ///
  /// In en, this message translates to:
  /// **'Delete the active session'**
  String get homeFinishActivePlaySessionDeleteTitle;

  /// The description of the delete active session dialog in the home screen
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the active session?\n\nThe session and its note will be removed from this device. This action is irreversible.'**
  String get homeFinishActivePlaySessionDeleteDescription;

  /// The text of the button to delete the active session in the home screen
  ///
  /// In en, this message translates to:
  /// **'Delete session'**
  String get homeFinishActivePlaySessionDeleteButton;

  /// The title of the games list in the home screen
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get homeGamesListTitle;

  /// The text of the button to launch a game in the home screen
  ///
  /// In en, this message translates to:
  /// **'Launch'**
  String get homeGamesListButtonText;

  /// The title of the library screen
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTitle;

  /// The subtitle of the library screen
  ///
  /// In en, this message translates to:
  /// **'Your game collection'**
  String get librarySubtitle;

  /// The title of the empty card in the library screen
  ///
  /// In en, this message translates to:
  /// **'Your library is empty'**
  String get libraryEmptyStateTitle;

  /// The description of the empty card in the library screen
  ///
  /// In en, this message translates to:
  /// **'Add your first game to start tracking your progress.'**
  String get libraryEmptyStateDescription;

  /// The title of the empty card in the library filter screen
  ///
  /// In en, this message translates to:
  /// **'No games matching your filter'**
  String get libraryFilterEmptyStateTitle;

  /// The description of the empty card in the library filter screen
  ///
  /// In en, this message translates to:
  /// **'Try a different filter to see your games.'**
  String get libraryFilterEmptyStateDescription;

  /// The text of the button in the empty card in the library filter screen to see all games
  ///
  /// In en, this message translates to:
  /// **'See all games'**
  String get libraryFilterEmptyStateButtonText;

  /// The filter for all games in the library
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get libraryFilterAll;

  /// The filter for want to play games in the library
  ///
  /// In en, this message translates to:
  /// **'Want to play'**
  String get libraryFilterWantToPlay;

  /// The filter for playing games in the library
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get libraryFilterPlaying;

  /// The filter for completed games in the library
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get libraryFilterCompleted;

  /// The filter for dropped games in the library
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get libraryFilterDropped;

  /// The hint text of the search bar in the library screen
  ///
  /// In en, this message translates to:
  /// **'Search for a game'**
  String get librarySearchHintText;

  /// The title of the search results in the library screen for games in your library
  ///
  /// In en, this message translates to:
  /// **'In your library'**
  String get librarySearchResultsTitle;

  /// The title of the no results card in the library screen for games not in your library
  ///
  /// In en, this message translates to:
  /// **'No games found'**
  String get librarySearchNoResultsTitle;

  /// The description of the no results card in the library screen for games not in your library
  ///
  /// In en, this message translates to:
  /// **'No games match your search in your library or on IGDB.\n\nTry a different name or check the spelling.'**
  String get librarySearchNoResultsDescription;

  /// The title of the IGDB search results in the library screen
  ///
  /// In en, this message translates to:
  /// **'IGDB results'**
  String get igdbSearchResultsTitle;

  /// The title of the error card in the IGDB search results
  ///
  /// In en, this message translates to:
  /// **'Unable to retrieve external results at the moment.'**
  String get igdbSearchCardErrorTitle;

  /// The description of the error card in the IGDB search results
  ///
  /// In en, this message translates to:
  /// **'Check your connection or try again later.'**
  String get igdbSearchCardErrorDescription;

  /// The label of the select status sheet in the add game sheet
  ///
  /// In en, this message translates to:
  /// **'Add as'**
  String get addGameSheetSelectStatus;

  /// The status of the game 'Want to play'
  ///
  /// In en, this message translates to:
  /// **'Want to play'**
  String get gameStatusWantToPlay;

  /// The status of the game 'Playing'
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get gameStatusPlaying;

  /// The status of the game 'Completed'
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get gameStatusCompleted;

  /// The status of the game 'Dropped'
  ///
  /// In en, this message translates to:
  /// **'Dropped'**
  String get gameStatusDropped;

  /// The playtime of the game
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes}'**
  String gamePlaytime(int hours, String minutes);

  /// The playtime of the game in minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String gamePlaytimeMinutes(String minutes);

  /// The playtime of the game in hours and minutes
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String gamePlaytimeHoursMinutes(int hours, String minutes);

  /// Number of games in the library
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No games} =1{1 game} other{{count} games}}'**
  String libraryGamesCount(int count);

  /// The text of the button to see the details of the game in the library game card
  ///
  /// In en, this message translates to:
  /// **'See'**
  String get libraryGameCardSeeDetails;

  /// The title of the delete game sheet
  ///
  /// In en, this message translates to:
  /// **'Delete this game'**
  String get gameDetailsDeleteGameTitle;

  /// The description of the delete game sheet
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\" from your library?\n\nThe game, its notes and all recorded sessions will be removed from this device. This action is irreversible.'**
  String gameDetailsDeleteGameDescription(String name);

  /// The warning of the delete game sheet
  ///
  /// In en, this message translates to:
  /// **'No data will be saved locally.'**
  String get gameDetailsDeleteWarning;

  /// The text of the button to delete a game
  ///
  /// In en, this message translates to:
  /// **'Delete game'**
  String get gameDetailsDeleteButton;

  /// The title of the section 'About the game' in the game details
  ///
  /// In en, this message translates to:
  /// **'About the game'**
  String get gameDetailsAboutGameTitle;

  /// The title of the section 'Genres' in the game details
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get gameDetailsGenresTitle;

  /// The name of the genre 'Pinball'
  ///
  /// In en, this message translates to:
  /// **'Pinball'**
  String get igdbGenrePinball;

  /// The name of the genre 'Adventure'
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get igdbGenreAdventure;

  /// The name of the genre 'Indie'
  ///
  /// In en, this message translates to:
  /// **'Indie'**
  String get igdbGenreIndie;

  /// The name of the genre 'Arcade'
  ///
  /// In en, this message translates to:
  /// **'Arcade'**
  String get igdbGenreArcade;

  /// The name of the genre 'Visual Novel'
  ///
  /// In en, this message translates to:
  /// **'Visual Novel'**
  String get igdbGenreVisualNovel;

  /// The name of the genre 'Card & Board Game'
  ///
  /// In en, this message translates to:
  /// **'Card & Board Game'**
  String get igdbGenreCardAndBoardGame;

  /// The name of the genre 'MOBA'
  ///
  /// In en, this message translates to:
  /// **'MOBA'**
  String get igdbGenreMoba;

  /// The name of the genre 'Point-and-click'
  ///
  /// In en, this message translates to:
  /// **'Point-and-click'**
  String get igdbGenrePointAndClick;

  /// The name of the genre 'Fighting'
  ///
  /// In en, this message translates to:
  /// **'Fighting'**
  String get igdbGenreFighting;

  /// The name of the genre 'Shooter'
  ///
  /// In en, this message translates to:
  /// **'Shooter'**
  String get igdbGenreShooter;

  /// The name of the genre 'Music'
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get igdbGenreMusic;

  /// The name of the genre 'Platform'
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get igdbGenrePlatform;

  /// The name of the genre 'Puzzle'
  ///
  /// In en, this message translates to:
  /// **'Puzzle'**
  String get igdbGenrePuzzle;

  /// The name of the genre 'Racing'
  ///
  /// In en, this message translates to:
  /// **'Racing'**
  String get igdbGenreRacing;

  /// The name of the genre 'Real Time Strategy (RTS)'
  ///
  /// In en, this message translates to:
  /// **'Real Time Strategy (RTS)'**
  String get igdbGenreRealTimeStrategy;

  /// The name of the genre 'Role-playing (RPG)'
  ///
  /// In en, this message translates to:
  /// **'Role-playing (RPG)'**
  String get igdbGenreRolePlaying;

  /// The name of the genre 'Simulator'
  ///
  /// In en, this message translates to:
  /// **'Simulator'**
  String get igdbGenreSimulator;

  /// The name of the genre 'Sport'
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get igdbGenreSport;

  /// The name of the genre 'Strategy'
  ///
  /// In en, this message translates to:
  /// **'Strategy'**
  String get igdbGenreStrategy;

  /// The name of the genre 'Turn-based strategy (TBS)'
  ///
  /// In en, this message translates to:
  /// **'Turn-based strategy (TBS)'**
  String get igdbGenreTurnBasedStrategy;

  /// The name of the genre 'Tactical'
  ///
  /// In en, this message translates to:
  /// **'Tactical'**
  String get igdbGenreTactical;

  /// The name of the genre 'Hack and slash/Beat 'em up'
  ///
  /// In en, this message translates to:
  /// **'Hack and slash/Beat \'em up'**
  String get igdbGenreHackAndSlash;

  /// The name of the genre 'Quiz/Trivia'
  ///
  /// In en, this message translates to:
  /// **'Quiz/Trivia'**
  String get igdbGenreQuizTrivia;

  /// The title of the section 'Developer' in the game details
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get gameDetailsDeveloperTitle;

  /// The title of the section 'Publisher' in the game details
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get gameDetailsPublisherTitle;

  /// The title of the section 'Platforms' in the game details
  ///
  /// In en, this message translates to:
  /// **'Platforms'**
  String get gameDetailsPlatformsTitle;

  /// The title of the section 'Estimated playtimes' in the game details
  ///
  /// In en, this message translates to:
  /// **'Estimated playtimes'**
  String get gameDetailsEstimatedPlaytimesTitle;

  /// The label of the section 'Story' in the game details
  ///
  /// In en, this message translates to:
  /// **'Story: {playtime}'**
  String gameDetailsEstimatedPlaytimesStory(String playtime);

  /// The label of the section 'Main' in the game details
  ///
  /// In en, this message translates to:
  /// **'Main: {playtime}'**
  String gameDetailsEstimatedPlaytimesMain(String playtime);

  /// The label of the section 'Completion' in the game details
  ///
  /// In en, this message translates to:
  /// **'Completion: {playtime}'**
  String gameDetailsEstimatedPlaytimesCompletion(String playtime);

  /// The title of the section 'Notes' in the game details
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get gameDetailsNotesTitle;

  /// The text of the button to add a note in the game details
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get gameDetailsNotesAddButton;

  /// The title of the add note sheet
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get gameDetailsNotesAddTitle;

  /// The title of the edit note sheet
  ///
  /// In en, this message translates to:
  /// **'Edit a note'**
  String get gameDetailsNotesEditTitle;

  /// The title of the delete note dialog
  ///
  /// In en, this message translates to:
  /// **'Delete this note'**
  String get gameDetailsNotesDeleteTitle;

  /// The description of the delete note dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this note?\n\nThe note will be removed from this device. This action is irreversible.'**
  String get gameDetailsNotesDeleteDescription;

  /// The text of the button to delete a note
  ///
  /// In en, this message translates to:
  /// **'Delete note'**
  String get gameDetailsNotesDeleteButton;

  /// The text of the button to add a note in the game notes sheet
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get gameDetailsNotesAddSaveButton;

  /// The text of the button to edit a note in the game notes sheet
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get gameDetailsNotesEditSaveButton;

  /// The label of the note field in the game notes sheet
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get gameDetailsNotesNoteLabel;

  /// The hint text of the note field in the game notes sheet
  ///
  /// In en, this message translates to:
  /// **'Write your note here...'**
  String get gameDetailsNotesNoteHintText;

  /// The title of the section 'Sessions' in the game details
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get gameDetailsPlaySessionsTitle;

  /// The text of the button to add a session in the game details
  ///
  /// In en, this message translates to:
  /// **'Add a session'**
  String get gameDetailsPlaySessionsAddButton;

  /// The title of the add session sheet
  ///
  /// In en, this message translates to:
  /// **'Add a session'**
  String get gameDetailsPlaySessionsAddTitle;

  /// The title of the add session sheet
  ///
  /// In en, this message translates to:
  /// **'Edit a session'**
  String get gameDetailsPlaySessionsEditTitle;

  /// The label of the duration field in the add session sheet
  ///
  /// In en, this message translates to:
  /// **'Session duration'**
  String get gameDetailsPlaySessionsDurationLabel;

  /// The label of the note field in the add session sheet
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get gameDetailsPlaySessionsNoteLabel;

  /// The hint text of the add session sheet
  ///
  /// In en, this message translates to:
  /// **'What happened during this session?'**
  String get gameDetailsPlaySessionsHintText;

  /// The text of the button to add a session in the add session sheet
  ///
  /// In en, this message translates to:
  /// **'Add session'**
  String get gameDetailsPlaySessionsAddSaveButton;

  /// The text of the button to edit a session in the edit session sheet
  ///
  /// In en, this message translates to:
  /// **'Save session'**
  String get gameDetailsPlaySessionsEditSaveButton;

  /// The title of the delete play session dialog
  ///
  /// In en, this message translates to:
  /// **'Delete this session'**
  String get gameDetailsPlaySessionsDeleteTitle;

  /// The description of the delete play session dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this session?\n\nThe session and its note will be removed from this device. This action is irreversible.'**
  String get gameDetailsPlaySessionsDeleteDescription;

  /// The text of the button to delete a play session
  ///
  /// In en, this message translates to:
  /// **'Delete session'**
  String get gameDetailsPlaySessionsDeleteButton;

  /// The error message when an invalid play session is provided
  ///
  /// In en, this message translates to:
  /// **'Invalid play session.'**
  String get invalidPlaySessionException;

  /// The error message when a play session is not found
  ///
  /// In en, this message translates to:
  /// **'Play session not found.'**
  String get playSessionNotFoundException;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
