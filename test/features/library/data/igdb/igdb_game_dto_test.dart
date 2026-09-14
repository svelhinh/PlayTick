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
    expect(game.estimatedPlaytimes, isNull);
  });

  test('fromJson maps estimated playtimes from game_time_to_beat', () {
    final game = IgdbGameDto.fromJson({
      'id': 1942,
      'name': 'The Witcher 3',
      'game_time_to_beat': {
        'game_id': 1942,
        'hastily': 36000,
        'normally': 50000,
        'completely': 80000,
      },
    })?.toGame();

    expect(game!.estimatedPlaytimes?.story, const Duration(seconds: 36000));
    expect(game.estimatedPlaytimes?.main, const Duration(seconds: 50000));
    expect(
      game.estimatedPlaytimes?.completion,
      const Duration(seconds: 80000),
    );
  });

  test('fromJson keeps partial estimated playtimes', () {
    final game = IgdbGameDto.fromJson({
      'id': 1,
      'name': 'Game 1',
      'game_time_to_beat': {'normally': 12000},
    })?.toGame();

    expect(game!.estimatedPlaytimes?.story, isNull);
    expect(game.estimatedPlaytimes?.main, const Duration(seconds: 12000));
    expect(game.estimatedPlaytimes?.completion, isNull);
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
    expect(game.estimatedPlaytimes, isNull);
  });

  test('toGame uses the requested localized name and cover', () {
    final game = IgdbGameDto.fromJson({
      ...completeJson,
      'game_localizations': [
        {
          'name': 'The Witcher 3 : Wild Hunt',
          'region': {'identifier': 'EU'},
          'cover': {
            'url': '//images.igdb.com/igdb/image/upload/t_thumb/eu-cover.jpg',
          },
        },
      ],
    })?.toGame(preferredRegionIdentifier: 'EU');

    expect(game, isNotNull);
    expect(game!.name, 'The Witcher 3 : Wild Hunt');
    expect(
      game.coverUrl,
      'https://images.igdb.com/igdb/image/upload/t_cover_big/eu-cover.jpg',
    );
    expect(game.summary, 'A story-driven open world RPG.');
  });

  test('toGame applies localized name and cover fallbacks independently', () {
    final localizedCoverOnly = IgdbGameDto.fromJson({
      ...completeJson,
      'game_localizations': [
        {
          'region': {'identifier': 'EU'},
          'cover': {
            'url': '//images.igdb.com/igdb/image/upload/t_thumb/eu-cover.jpg',
          },
        },
      ],
    })?.toGame(preferredRegionIdentifier: 'EU');

    expect(localizedCoverOnly?.name, 'The Witcher 3');
    expect(
      localizedCoverOnly?.coverUrl,
      'https://images.igdb.com/igdb/image/upload/t_cover_big/eu-cover.jpg',
    );

    final localizedNameOnly = IgdbGameDto.fromJson({
      ...completeJson,
      'game_localizations': [
        {
          'name': 'The Witcher 3 : Wild Hunt',
          'region': {'identifier': 'EU'},
        },
      ],
    })?.toGame(preferredRegionIdentifier: 'EU');

    expect(localizedNameOnly?.name, 'The Witcher 3 : Wild Hunt');
    expect(
      localizedNameOnly?.coverUrl,
      'https://images.igdb.com/igdb/image/upload/t_cover_big/co1wyy.jpg',
    );
  });

  test('toGame ignores malformed and unmatched localizations', () {
    final dto = IgdbGameDto.fromJson({
      ...completeJson,
      'game_localizations': [
        42,
        {
          'name': 'Invalid',
          'region': {'identifier': '   '},
        },
        {
          'name': 'Japanese title',
          'region': {'identifier': 'ja-JP'},
        },
      ],
    });

    expect(dto?.localizations, hasLength(1));

    final game = dto?.toGame(preferredRegionIdentifier: 'EU');
    expect(game?.name, 'The Witcher 3');
    expect(
      game?.coverUrl,
      'https://images.igdb.com/igdb/image/upload/t_cover_big/co1wyy.jpg',
    );
  });

  test('fromJson returns null without a valid id and name', () {
    expect(IgdbGameDto.fromJson({'name': 'No id'}), isNull);
    expect(IgdbGameDto.fromJson({'id': 1}), isNull);
  });
}
