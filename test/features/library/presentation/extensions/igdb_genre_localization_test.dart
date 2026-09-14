import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/presentation/extensions/igdb_genre_localization.dart';
import 'package:playtick/l10n/app_localizations.dart';

void main() {
  const frenchGenres = {
    'Pinball': 'Flipper',
    'Adventure': 'Aventure',
    'Indie': 'Indépendant',
    'Arcade': 'Arcade',
    'Visual Novel': 'Roman visuel',
    'Card & Board Game': 'Jeu de cartes et de plateau',
    'MOBA': 'MOBA',
    'Point-and-click': 'Point-and-click',
    'Fighting': 'Combat',
    'Shooter': 'Tir',
    'Music': 'Musique',
    'Platform': 'Plateforme',
    'Puzzle': 'Réflexion',
    'Racing': 'Course',
    'Real Time Strategy (RTS)': 'Stratégie en temps réel (RTS)',
    'Role-playing (RPG)': 'Jeu de rôle (RPG)',
    'Simulator': 'Simulation',
    'Sport': 'Sport',
    'Strategy': 'Stratégie',
    'Turn-based strategy (TBS)': 'Stratégie au tour par tour (TBS)',
    'Tactical': 'Tactique',
    "Hack and slash/Beat 'em up": "Hack and slash/Beat 'em up",
    'Quiz/Trivia': 'Quiz / Questions-réponses',
  };

  test('localizes every supported IGDB genre in French', () async {
    final appLoc = await AppLocalizations.delegate.load(const Locale('fr'));

    for (final genre in frenchGenres.entries) {
      expect(
        appLoc.localizeIgdbGenre(genre.key),
        genre.value,
        reason: genre.key,
      );
    }
  });

  test('keeps English and unknown IGDB genres unchanged', () async {
    final appLoc = await AppLocalizations.delegate.load(const Locale('en'));

    for (final genre in frenchGenres.keys) {
      expect(appLoc.localizeIgdbGenre(genre), genre, reason: genre);
    }
    expect(appLoc.localizeIgdbGenre('Future IGDB genre'), 'Future IGDB genre');
  });
}
