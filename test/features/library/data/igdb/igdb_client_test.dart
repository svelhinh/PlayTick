import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:playtick/features/library/data/igdb/igdb_client.dart';
import 'package:playtick/features/library/data/igdb/igdb_credentials.dart';
import 'package:playtick/features/library/domain/library_exception.dart';

void main() {
  const tokenUrl = 'https://id.twitch.tv';
  const searchUrl = 'https://api.igdb.com/v4';
  const credentials = IgdbCredentials(
    clientId: 'test',
    clientSecret: 'test',
  );

  IgdbClient createClient(
    MockClient httpClient, {
    IgdbCredentials igdbCredentials = credentials,
    String? preferredRegionIdentifier,
  }) {
    return IgdbClient(
      client: httpClient,
      credentials: igdbCredentials,
      tokenUrl: tokenUrl,
      searchUrl: searchUrl,
      preferredRegionIdentifier: preferredRegionIdentifier,
    );
  }

  test('fetchToken returns the access token', () async {
    final httpClient = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.toString(), '$tokenUrl/oauth2/token');
      return Response('{"access_token": "abc", "expires_in": 1}', 200);
    });
    addTearDown(httpClient.close);

    final token = await createClient(httpClient).fetchToken();

    expect(token, 'abc');
  });

  test(
    'fetchToken throws when credentials are missing without calling HTTP',
    () async {
      var requestCount = 0;
      final httpClient = MockClient((request) async {
        requestCount++;
        return Response('{"access_token": "abc"}', 200);
      });
      addTearDown(httpClient.close);

      final igdbClient = createClient(
        httpClient,
        igdbCredentials: const IgdbCredentials(
          clientId: '',
          clientSecret: '',
        ),
      );

      await expectLater(
        igdbClient.fetchToken(),
        throwsA(isA<IgdbCredentialsNotConfiguredException>()),
      );
      expect(requestCount, 0);
    },
  );

  test('fetchToken throws when the token endpoint fails', () async {
    final httpClient = MockClient(
      (request) async => Response('unauthorized', 401),
    );
    addTearDown(httpClient.close);

    await expectLater(
      createClient(httpClient).fetchToken(),
      throwsA(isA<IgdbTokenFetchException>()),
    );
  });

  test('fetchToken throws when the access token is missing', () async {
    final httpClient = MockClient((request) async => Response('{}', 200));
    addTearDown(httpClient.close);

    await expectLater(
      createClient(httpClient).fetchToken(),
      throwsA(isA<IgdbTokenFetchException>()),
    );
  });

  test('fetchToken throws when the body is not valid JSON', () async {
    final httpClient = MockClient((request) async => Response('not json', 200));
    addTearDown(httpClient.close);

    await expectLater(
      createClient(httpClient).fetchToken(),
      throwsA(isA<IgdbTokenFetchException>()),
    );
  });

  test('searchGames returns the games', () async {
    final httpClient = MockClient(
      (request) async {
        if (request.url.toString() == '$tokenUrl/oauth2/token') {
          return Response('{"access_token": "abc"}', 200);
        } else if (request.url.toString() == '$searchUrl/games') {
          return Response(
            '[{"id": 1, "name": "Game 1"}, '
            '{"id": 2, "name": "Game 2"}]',
            200,
          );
        }

        return Response('not found', 404);
      },
    );
    addTearDown(httpClient.close);

    final games = await createClient(httpClient).searchGames('Game');
    expect(games.length, 2);
    expect(games[0].id, 1);
    expect(games[0].name, 'Game 1');
    expect(games[1].id, 2);
    expect(games[1].name, 'Game 2');
  });

  test(
    'searchGames applies localization fallbacks without changing metadata',
    () async {
      final httpClient = MockClient((request) async {
        if (request.url.toString() == '$tokenUrl/oauth2/token') {
          return Response('{"access_token": "abc"}', 200);
        }

        if (request.url.toString() == '$searchUrl/games') {
          expect(
            request.body,
            contains('game_localizations.region.identifier'),
          );
          expect(request.body, contains('game_localizations.name'));
          expect(request.body, contains('game_localizations.cover.url'));

          return Response(
            jsonEncode([
              {
                'id': 1,
                'name': 'Default one',
                'summary': 'English summary one.',
                'cover': {
                  'url': '//images.igdb.com/igdb/image/upload/t_thumb/default1.jpg',
                },
                'platforms': [
                  {'name': 'PlayStation 5'},
                ],
                'involved_companies': [
                  {
                    'developer': true,
                    'publisher': false,
                    'company': {'name': 'Original Developer'},
                  },
                  {
                    'developer': false,
                    'publisher': true,
                    'company': {'name': 'Original Publisher'},
                  },
                ],
                'game_localizations': [
                  {
                    'name': 'European one',
                    'region': {'identifier': 'EU'},
                    'cover': {
                      'url':
                          '//images.igdb.com/igdb/image/upload/t_thumb/eu1.jpg',
                    },
                  },
                ],
              },
              {
                'id': 2,
                'name': 'Default two',
                'summary': 'English summary two.',
                'cover': {
                  'url': '//images.igdb.com/igdb/image/upload/t_thumb/default2.jpg',
                },
                'game_localizations': [
                  {
                    'name': 'Japanese two',
                    'region': {'identifier': 'ja-JP'},
                  },
                ],
              },
              {
                'id': 3,
                'name': 'Default three',
                'cover': {
                  'url': '//images.igdb.com/igdb/image/upload/t_thumb/default3.jpg',
                },
                'game_localizations': [
                  {
                    'name': 'European three',
                    'region': {'identifier': 'EU'},
                  },
                ],
              },
              {
                'id': 4,
                'name': 'Default four',
                'cover': {
                  'url': '//images.igdb.com/igdb/image/upload/t_thumb/default4.jpg',
                },
                'game_localizations': [
                  {
                    'region': {'identifier': 'EU'},
                    'cover': {
                      'url':
                          '//images.igdb.com/igdb/image/upload/t_thumb/eu4.jpg',
                    },
                  },
                ],
              },
            ]),
            200,
          );
        }

        return Response('not found', 404);
      });
      addTearDown(httpClient.close);

      final games = await createClient(
        httpClient,
        preferredRegionIdentifier: 'EU',
      ).searchGames('Game');

      expect(games, hasLength(4));

      expect(games[0].name, 'European one');
      expect(
        games[0].coverUrl,
        'https://images.igdb.com/igdb/image/upload/t_cover_big/eu1.jpg',
      );
      expect(games[0].summary, 'English summary one.');
      expect(games[0].developer, 'Original Developer');
      expect(games[0].publisher, 'Original Publisher');
      expect(games[0].platforms, ['PlayStation 5']);

      expect(games[1].name, 'Default two');
      expect(
        games[1].coverUrl,
        'https://images.igdb.com/igdb/image/upload/t_cover_big/default2.jpg',
      );
      expect(games[1].summary, 'English summary two.');

      expect(games[2].name, 'European three');
      expect(
        games[2].coverUrl,
        'https://images.igdb.com/igdb/image/upload/t_cover_big/default3.jpg',
      );

      expect(games[3].name, 'Default four');
      expect(
        games[3].coverUrl,
        'https://images.igdb.com/igdb/image/upload/t_cover_big/eu4.jpg',
      );
    },
  );

  test(
    'searchGames returns nothing without HTTP when the query is empty',
    () async {
      var requestCount = 0;
      final httpClient = MockClient((request) async {
        requestCount++;
        return Response('[{"id": 1, "name": "Game 1"}]', 200);
      });
      addTearDown(httpClient.close);

      final games = await createClient(httpClient).searchGames('');

      expect(games, isEmpty);
      expect(requestCount, 0);
    },
  );

  test('searchGames throws when the games endpoint fails', () async {
    final httpClient = MockClient((request) async {
      if (request.url.toString() == '$tokenUrl/oauth2/token') {
        return Response('{"access_token": "abc"}', 200);
      }

      return Response('unavailable', 500);
    });
    addTearDown(httpClient.close);

    await expectLater(
      createClient(httpClient).searchGames('Game'),
      throwsA(isA<IgdbSearchException>()),
    );
  });

  test('searchGames skips games without an id or name', () async {
    final httpClient = MockClient((request) async {
      if (request.url.toString() == '$tokenUrl/oauth2/token') {
        return Response('{"access_token": "abc"}', 200);
      }

      if (request.url.toString() == '$searchUrl/games') {
        return Response(
          jsonEncode([
            {'id': 1, 'name': 'Game 1'},
            {'name': 'Missing id'},
            {'id': 2},
          ]),
          200,
        );
      }

      return Response('not found', 404);
    });
    addTearDown(httpClient.close);

    final games = await createClient(httpClient).searchGames('Game');

    expect(games, hasLength(1));
    expect(games.single.id, 1);
    expect(games.single.name, 'Game 1');
  });

  test(
    'searchGames attaches estimated playtimes to the matching game',
    () async {
      final httpClient = MockClient((request) async {
        if (request.url.toString() == '$tokenUrl/oauth2/token') {
          return Response('{"access_token": "abc"}', 200);
        }

        if (request.url.toString() == '$searchUrl/games') {
          return Response(
            jsonEncode([
              {'id': 1, 'name': 'Game 1'},
              {'id': 2, 'name': 'Game 2'},
            ]),
            200,
          );
        }

        if (request.url.toString() == '$searchUrl/game_time_to_beats') {
          return Response(
            jsonEncode([
              {
                'game_id': 2,
                'hastily': 3600,
                'normally': 7200,
                'completely': 10800,
              },
            ]),
            200,
          );
        }

        return Response('not found', 404);
      });
      addTearDown(httpClient.close);

      final games = await createClient(httpClient).searchGames('Game');

      expect(games, hasLength(2));
      expect(games[0].estimatedPlaytimes, isNull);
      expect(games[1].estimatedPlaytimes?.story, const Duration(hours: 1));
      expect(games[1].estimatedPlaytimes?.main, const Duration(hours: 2));
      expect(games[1].estimatedPlaytimes?.completion, const Duration(hours: 3));
    },
  );

  test('searchGames still returns games when time-to-beat fails', () async {
    final httpClient = MockClient((request) async {
      if (request.url.toString() == '$tokenUrl/oauth2/token') {
        return Response('{"access_token": "abc"}', 200);
      }

      if (request.url.toString() == '$searchUrl/games') {
        return Response(
          jsonEncode([
            {'id': 1, 'name': 'Game 1'},
          ]),
          200,
        );
      }

      return Response('unavailable', 500);
    });
    addTearDown(httpClient.close);

    final games = await createClient(httpClient).searchGames('Game');

    expect(games, hasLength(1));
    expect(games.single.name, 'Game 1');
    expect(games.single.estimatedPlaytimes, isNull);
  });
}
