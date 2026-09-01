import 'dart:math';

import 'package:playtick/features/library/domain/estimated_playtimes.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';

final _random = Random();
int _nextTemporaryGameId = DateTime.now().microsecondsSinceEpoch;

const _namePrefixes = [
  'Ancient',
  'Crimson',
  'Hidden',
  'Lost',
  'Neon',
  'Silent',
  'Solar',
  'Wild',
];

const _nameSuffixes = [
  'Chronicles',
  'Echoes',
  'Frontier',
  'Kingdom',
  'Odyssey',
  'Protocol',
  'Quest',
  'Voyage',
];

const _genres = [
  'Action',
  'Adventure',
  'Horror',
  'Platformer',
  'Puzzle',
  'Racing',
  'RPG',
  'Strategy',
];

const _platforms = [
  'PC',
  'PlayStation',
  'Switch',
  'Xbox',
];

const _studios = [
  'Blue Lantern Studio',
  'Iron Fox Games',
  'Moonlit Works',
  'Northwind Interactive',
  'Pixel Forge',
  'Sunset Assembly',
];

Game createTemporaryGame() {
  final storyHours = _between(4, 20);
  final mainHours = storyHours + _between(4, 24);
  final completionHours = mainHours + _between(8, 40);
  final selectedGenres = _pickMany(_genres, maximum: 3);

  return Game(
    id: _nextTemporaryGameId++,
    name:
        '${_pick(_namePrefixes)} ${_pick(_nameSuffixes)} '
        '${_between(100, 999)}',
    summary:
        'A ${selectedGenres.first.toLowerCase()} game about exploring '
        'a changing world and uncovering its secrets.',
    releaseDate: DateTime(
      _between(1995, 2025),
      _between(1, 12),
      _between(1, 28),
    ),
    genres: selectedGenres,
    developer: _pick(_studios),
    publisher: _pick(_studios),
    platforms: _pickMany(_platforms, maximum: 3),
    estimatedPlaytimes: EstimatedPlaytimes(
      story: Duration(hours: storyHours),
      main: Duration(hours: mainHours),
      completion: Duration(hours: completionHours),
    ),
    coverUrl:
        'https://sm.ign.com/t/ign_fr/news/h/hollow-kni/hollow-knights'
        '-next-expansion-changing-name-to-avoid-potenti_pkfm.1200.jpg',
  );
}

GameStatus randomTemporaryGameStatus() => _pick(GameStatus.values);

T _pick<T>(List<T> values) => values[_random.nextInt(values.length)];

List<T> _pickMany<T>(List<T> values, {required int maximum}) {
  final shuffledValues = [...values]..shuffle(_random);
  final count = _between(1, min(maximum, values.length));

  return shuffledValues.take(count).toList(growable: false);
}

int _between(int minimum, int maximum) {
  return minimum + _random.nextInt(maximum - minimum + 1);
}
