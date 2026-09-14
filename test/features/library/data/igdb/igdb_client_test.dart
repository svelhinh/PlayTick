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

  test('searchGames requests and uses the preferred localization', () async {
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
              'name': 'Default name',
              'cover': {
                'url':
                    '//images.igdb.com/igdb/image/upload/t_thumb/default.jpg',
              },
              'game_localizations': [
                {
                  'name': 'European name',
                  'region': {'identifier': 'EU'},
                  'cover': {
                    'url': '//images.igdb.com/igdb/image/upload/t_thumb/eu.jpg',
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

    expect(games, hasLength(1));
    expect(games.single.name, 'European name');
    expect(
      games.single.coverUrl,
      'https://images.igdb.com/igdb/image/upload/t_cover_big/eu.jpg',
    );
  });

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
