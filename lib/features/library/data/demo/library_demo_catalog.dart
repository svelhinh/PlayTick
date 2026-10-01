import 'package:playtick/features/library/domain/estimated_playtimes.dart';
import 'package:playtick/features/library/domain/game.dart';

final class LibraryDemoCatalog {
  LibraryDemoCatalog();

  static final List<Game> games = [
    Game(
      id: -1,
      name: 'The Witcher 3: Wild Hunt',
      summary: 'The Witcher 3: Wild Hunt is a game about a witcher who is trying to find his daughter.',
      releaseDate: DateTime(2015, 5, 19),
      platforms: ['windows', 'linux', 'macos'],
      genres: ['Role-playing (RPG)', 'Adventure'],
      developer: 'CD Projekt Red',
      publisher: 'CD Projekt Red',
      estimatedPlaytimes: const EstimatedPlaytimes(
        story: Duration(hours: 50),
        main: Duration(hours: 70),
        completion: Duration(hours: 100),
      ),
    ),
    Game(
      id: -2,
      name: 'Super Mario Odyssey',
      summary: 'Mario embarks on a new journey through mysterious worlds.',
      releaseDate: DateTime(2017, 10, 27),
      platforms: ['nintendo switch'],
      genres: ['Platform', 'Adventure'],
      developer: 'Nintendo',
      publisher: 'Nintendo',
      estimatedPlaytimes: const EstimatedPlaytimes(
        story: Duration(hours: 12),
        main: Duration(hours: 18),
        completion: Duration(hours: 60),
      ),
    ),
    Game(
      id: -3,
      name: 'League of Legends',
      summary: 'A fast-paced competitive MOBA with unique champions.',
      releaseDate: DateTime(2009, 10, 27),
      platforms: ['windows', 'macos'],
      genres: ['MOBA', 'Strategy'],
      developer: 'Riot Games',
      publisher: 'Riot Games',
      estimatedPlaytimes: const EstimatedPlaytimes(
        story: Duration.zero,
        main: Duration(hours: 50),
        completion: Duration(hours: 200),
      ),
    ),
    Game(
      id: -4,
      name: 'Portal 2',
      summary: 'A first-person puzzle game with innovative portal mechanics.',
      releaseDate: DateTime(2011, 4, 19),
      platforms: ['windows', 'macos', 'linux'],
      genres: ['Puzzle', 'Platform'],
      developer: 'Valve',
      publisher: 'Valve',
      estimatedPlaytimes: const EstimatedPlaytimes(
        story: Duration(hours: 8),
        main: Duration(hours: 12),
        completion: Duration(hours: 20),
      ),
    ),
    Game(
      id: -5,
      name: 'Dark Souls',
      summary: 'A challenging action RPG set in a dark fantasy world.',
      releaseDate: DateTime(2011, 9, 22),
      platforms: ['windows', 'ps3', 'xbox 360'],
      genres: ['Action', 'Role-playing (RPG)'],
      developer: 'FromSoftware',
      publisher: 'Bandai Namco',
      estimatedPlaytimes: const EstimatedPlaytimes(
        story: Duration(hours: 40),
        main: Duration(hours: 60),
        completion: Duration(hours: 100),
      ),
    ),
    Game(
      id: -6,
      name: "Sid Meier's Civilization VI",
      summary:
          'Strategy game where you build an empire to stand the test of time.',
      releaseDate: DateTime(2016, 10, 21),
      platforms: ['windows', 'macos', 'linux', 'nintendo switch'],
      genres: ['Strategy', 'Turn-based strategy (TBS)'],
      developer: 'Firaxis Games',
      publisher: '2K Games',
      estimatedPlaytimes: const EstimatedPlaytimes(
        story: Duration(hours: 15),
        main: Duration(hours: 30),
        completion: Duration(hours: 100),
      ),
    ),
    Game(
      id: -7,
      name: 'Tetris Effect',
      summary: 'A reinvention of the classic puzzle game, now with music and beautiful visuals.',
      releaseDate: DateTime(2018, 11, 9),
      platforms: ['windows', 'ps4', 'ps5', 'xbox one'],
      genres: ['Puzzle', 'Music'],
      developer: 'Monstars Inc., Resonair',
      publisher: 'Enhance Games',
      estimatedPlaytimes: const EstimatedPlaytimes(
        story: Duration(hours: 5),
        main: Duration(hours: 10),
        completion: Duration(hours: 20),
      ),
    ),
    Game(
      id: -8,
      name: 'Street Fighter V',
      summary: 'A competitive fighting game with global tournaments.',
      releaseDate: DateTime(2016, 2, 16),
      platforms: ['windows', 'ps4', 'ps5'],
      genres: ['Fighting', 'Arcade'],
      developer: 'Capcom',
      publisher: 'Capcom',
      estimatedPlaytimes: const EstimatedPlaytimes(
        story: Duration(hours: 3),
        main: Duration(hours: 15),
        completion: Duration(hours: 40),
      ),
    ),
  ];
}
