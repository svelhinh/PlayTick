import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/data/igdb/igdb_game_dto.dart';

void main() {
  const completeJson = {
    'id': 1942,
    'name': 'The Witcher 3',
    'summary': 'A story-driven open world RPG.',
    'first_release_date': 1431993600,
    'cover': {
      'url': '//images.igdb.com/igdb/image/upload/t_thumb/co1wyy.jpg',
    },
    'genres': [
      {'name': 'RPG'},
      {'name': 'Adventure'},
    ],
    'platforms': [
      {'name': 'PC'},
      {'name': 'PlayStation 4'},
    ],
    'involved_companies': [
      {
        'developer': true,
        'publisher': false,
        'company': {'name': 'CD Projekt Red'},
      },
      {
        'developer': false,
        'publisher': true,
        'company': {'name': 'CD Projekt'},
      },
    ],
  };

  test('fromJson maps a complete IGDB game', () {
    final game = IgdbGameDto.fromJson(completeJson)?.toGame();

    expect(game, isNotNull);
    expect(game!.id, 1942);
    expect(game.name, 'The Witcher 3');
    expect(game.summary, 'A story-driven open world RPG.');
    expect(game.releaseDate, DateTime.utc(2015, 5, 19));
    expect(
      game.coverUrl,
      'https://images.igdb.com/igdb/image/upload/t_cover_big/co1wyy.jpg',
    );
    expect(game.genres, ['RPG', 'Adventure']);
    expect(game.platforms, ['PC', 'PlayStation 4']);
    expect(game.developer, 'CD Projekt Red');
    expect(game.publisher, 'CD Projekt');
  });

  test('fromJson keeps optional fields empty when IGDB omits them', () {
    final game = IgdbGameDto.fromJson({
      'id': 1,
      'name': 'Game 1',
    })?.toGame();

    expect(game, isNotNull);
    expect(game!.id, 1);
    expect(game.name, 'Game 1');
    expect(game.summary, isNull);
    expect(game.coverUrl, isNull);
    expect(game.releaseDate, isNull);
    expect(game.developer, isNull);
    expect(game.publisher, isNull);
    expect(game.genres, isEmpty);
    expect(game.platforms, isEmpty);
  });

  test('fromJson returns null without a valid id and name', () {
    expect(IgdbGameDto.fromJson({'name': 'No id'}), isNull);
    expect(IgdbGameDto.fromJson({'id': 1}), isNull);
  });
}
