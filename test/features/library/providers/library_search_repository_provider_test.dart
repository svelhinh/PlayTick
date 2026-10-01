import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:playtick/features/library/data/demo/demo_client.dart';
import 'package:playtick/features/library/data/igdb/igdb_client.dart';
import 'package:playtick/features/library/data/igdb/igdb_credentials.dart';
import 'package:playtick/features/library/providers/library_search_repository_provider.dart';

void main() {
  test('uses the demo catalog when IGDB credentials are absent', () async {
    final repository = librarySearchRepositoryFor(
      credentials: const IgdbCredentials(clientId: '', clientSecret: ''),
    );

    expect(repository, isA<DemoClient>());

    final lowerCase = await repository.searchGames('witcher');
    final upperCase = await repository.searchGames('  WITCHER  ');

    expect(lowerCase, hasLength(1));
    expect(lowerCase.single.id, -1);
    expect(upperCase.single.name, lowerCase.single.name);
    expect(await repository.searchGames('   '), isEmpty);
    expect(await repository.searchGames('zzz'), isEmpty);
  });

  test('uses IGDB when credentials are configured', () {
    final client = http.Client();
    addTearDown(client.close);

    final repository = librarySearchRepositoryFor(
      credentials: const IgdbCredentials(
        clientId: 'client',
        clientSecret: 'secret',
      ),
      httpClient: client,
      preferredRegionIdentifier: 'EU',
    );

    expect(repository, isA<IgdbClient>());
    expect((repository as IgdbClient).preferredRegionIdentifier, 'EU');
  });

  test(
    'the provider selects the demo catalog without compile-time credentials',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        container.read(librarySearchRepositoryProvider),
        isA<DemoClient>(),
      );
    },
  );
}
