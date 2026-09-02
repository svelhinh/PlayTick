import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:playtick/features/library/data/igdb/igdb_client.dart';
import 'package:playtick/features/library/data/igdb/igdb_credentials.dart';
import 'package:playtick/features/library/domain/library_exception.dart';

void main() {
  const baseUrl = 'https://id.twitch.tv';
  const credentials = IgdbCredentials(
    clientId: 'test',
    clientSecret: 'test',
  );

  IgdbClient createClient(
    MockClient httpClient, {
    IgdbCredentials igdbCredentials = credentials,
  }) {
    return IgdbClient(
      client: httpClient,
      credentials: igdbCredentials,
      baseUrl: baseUrl,
    );
  }

  test('fetchToken returns the access token', () async {
    final httpClient = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.toString(), '$baseUrl/oauth2/token');
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
}
