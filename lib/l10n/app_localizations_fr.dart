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
  String get add => 'Ajouter';

  @override
  String get cancel => 'Annuler';

  @override
  String get retry => 'Réessayer';

  @override
  String get somethingWentWrong => 'Une erreur est survenue';

  @override
  String get date => 'Date';

  @override
  String get hours => 'heures';

  @override
  String get minutes => 'minutes';

  @override
  String get validate => 'Valider';

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
  String get homeWeeklyPlaytime => 'Temps cette semaine';

  @override
  String get homeTotalGames => 'Jeux en cours';

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
  String get librarySearchHintText => 'Rechercher un jeu';

  @override
  String get librarySearchResultsTitle => 'Dans votre bibliothèque';

  @override
  String get librarySearchNoResultsTitle => 'Aucun jeu trouvé';

  @override
  String get librarySearchNoResultsDescription =>
      'Aucun jeu ne correspond à votre recherche dans votre bibliothèque ou sur IGDB.\n\nEssayez un autre nom ou vérifiez l\'orthographe.';

  @override
  String get igdbSearchResultsTitle => 'Résultats IGDB';

  @override
  String get igdbSearchCardErrorTitle =>
      'Impossible de récupérer les résultats externes pour le moment.';

  @override
  String get igdbSearchCardErrorDescription =>
      'Vérifiez votre connexion ou réessayez plus tard.';

  @override
  String get addGameSheetSelectStatus => 'Ajouter comme';

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

  @override
  String get gameDetailsPlaySessionsTitle => 'Sessions';

  @override
  String get gameDetailsPlaySessionsAddButton => 'Ajouter une session';

  @override
  String get gameDetailsPlaySessionsAddTitle => 'Ajouter une session';

  @override
  String get gameDetailsPlaySessionsEditTitle => 'Modifier la session';

  @override
  String get gameDetailsPlaySessionsDurationLabel => 'Durée de la session';

  @override
  String get gameDetailsPlaySessionsNoteLabel => 'Note (facultatif)';

  @override
  String get gameDetailsPlaySessionsHintText =>
      'Que s\'est-il passé pendant cette session ?';

  @override
  String get gameDetailsPlaySessionsAddSaveButton => 'Ajouter la session';

  @override
  String get gameDetailsPlaySessionsEditSaveButton => 'Enregistrer la session';

  @override
  String get gameDetailsPlaySessionsDeleteTitle => 'Supprimer cette session';

  @override
  String get gameDetailsPlaySessionsDeleteDescription =>
      'Voulez-vous vraiment supprimer cette session ?\n\nLa session et sa note seront retirées de cet appareil. Cette action est irréversible.';

  @override
  String get gameDetailsPlaySessionsDeleteButton => 'Supprimer la session';

  @override
  String get invalidPlaySessionException => 'Session de jeu invalide.';

  @override
  String get playSessionNotFoundException => 'Session de jeu introuvable.';
}
