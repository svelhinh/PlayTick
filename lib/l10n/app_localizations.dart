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

  /// The text of the button to cancel an action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// The error message general
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

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
