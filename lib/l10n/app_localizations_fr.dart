// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Play Tick';

  @override
  String get cancel => 'Annuler';

  @override
  String get somethingWentWrong => 'Une erreur est survenue';

  @override
  String get gameAlreadyInLibrary => 'Ce jeu est déjà dans votre bibliothèque.';

  @override
  String get gameNotFoundInLibrary =>
      'Ce jeu n\'est pas dans votre bibliothèque.';

  @override
  String get navigationLabelHome => 'Accueil';

  @override
  String get navigationLabelLibrary => 'Bibliothèque';

  @override
  String get homeEmptyCardTitle => 'Aucun jeu en cours';

  @override
  String get homeEmptyCardDescription =>
      'Ajoutez un jeu à votre bibliothèque pour commencer à suivre vos sessions.';

  @override
  String get homeEmptyCardButtonText => 'Aller à la bibliothèque';

  @override
  String get libraryTitle => 'Bibliothèque';

  @override
  String get librarySubtitle => 'Votre collection de jeux';

  @override
  String get libraryEmptyStateTitle => 'Votre bibliothèque est vide';

  @override
  String get libraryEmptyStateDescription =>
      'Ajoutez votre premier jeu pour commencer à suivre votre progression.';

  @override
  String get libraryFilterEmptyStateTitle => 'Aucun jeu trouvé';

  @override
  String get libraryFilterEmptyStateDescription =>
      'Essayez un autre filtre pour trouver vos jeux.';

  @override
  String get libraryFilterEmptyStateButtonText => 'Voir tous mes jeux';

  @override
  String get libraryFilterAll => 'Tous';

  @override
  String get libraryFilterWantToPlay => 'À jouer';

  @override
  String get libraryFilterPlaying => 'En cours';

  @override
  String get libraryFilterCompleted => 'Terminé';

  @override
  String get libraryFilterDropped => 'Abandonné';

  @override
  String get gameStatusWantToPlay => 'À jouer';

  @override
  String get gameStatusPlaying => 'En cours';

  @override
  String get gameStatusCompleted => 'Terminé';

  @override
  String get gameStatusDropped => 'Abandonné';

  @override
  String gamePlaytime(int hours, String minutes) {
    return '$hours h $minutes';
  }

  @override
  String libraryGamesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jeux',
      one: '1 jeu',
      zero: 'Aucun jeu',
    );
    return '$_temp0';
  }

  @override
  String get libraryGameCardSeeDetails => 'Voir';

  @override
  String get gameDetailsDeleteGameTitle => 'Supprimer le jeu';

  @override
  String gameDetailsDeleteGameDescription(String name) {
    return 'Voulez-vous vraiment supprimer \"$name\" de votre bibliothèque ?\n\nLe jeu, ses notes et toutes les sessions enregistrées seront supprimés de cet appareil. Cette action est irréversible.';
  }

  @override
  String get gameDetailsDeleteWarning =>
      'Aucune donnée ne sera conservée localement.';

  @override
  String get gameDetailsDeleteButton => 'Supprimer le jeu';

  @override
  String get gameDetailsAboutGameTitle => 'À propos du jeu';

  @override
  String get gameDetailsGenresTitle => 'Genres';

  @override
  String get gameDetailsDeveloperTitle => 'Développeur';

  @override
  String get gameDetailsPublisherTitle => 'Éditeur';

  @override
  String get gameDetailsPlatformsTitle => 'Plateformes';

  @override
  String get gameDetailsEstimatedPlaytimesTitle => 'Temps de jeu estimé';

  @override
  String gameDetailsEstimatedPlaytimesStory(String playtime) {
    return 'Histoire: $playtime';
  }

  @override
  String gameDetailsEstimatedPlaytimesMain(String playtime) {
    return 'Principal: $playtime';
  }

  @override
  String gameDetailsEstimatedPlaytimesCompletion(String playtime) {
    return 'Complétion: $playtime';
  }
}
