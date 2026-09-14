import 'package:playtick/l10n/app_localizations.dart';

extension IgdbGenreLocalization on AppLocalizations {
  String localizeIgdbGenre(String genre) => switch (genre) {
    'Pinball' => igdbGenrePinball,
    'Adventure' => igdbGenreAdventure,
    'Indie' => igdbGenreIndie,
    'Arcade' => igdbGenreArcade,
    'Visual Novel' => igdbGenreVisualNovel,
    'Card & Board Game' => igdbGenreCardAndBoardGame,
    'MOBA' => igdbGenreMoba,
    'Point-and-click' => igdbGenrePointAndClick,
    'Fighting' => igdbGenreFighting,
    'Shooter' => igdbGenreShooter,
    'Music' => igdbGenreMusic,
    'Platform' => igdbGenrePlatform,
    'Puzzle' => igdbGenrePuzzle,
    'Racing' => igdbGenreRacing,
    'Real Time Strategy (RTS)' => igdbGenreRealTimeStrategy,
    'Role-playing (RPG)' => igdbGenreRolePlaying,
    'Simulator' => igdbGenreSimulator,
    'Sport' => igdbGenreSport,
    'Strategy' => igdbGenreStrategy,
    'Turn-based strategy (TBS)' => igdbGenreTurnBasedStrategy,
    'Tactical' => igdbGenreTactical,
    "Hack and slash/Beat 'em up" => igdbGenreHackAndSlash,
    'Quiz/Trivia' => igdbGenreQuizTrivia,
    _ => genre,
  };
}
