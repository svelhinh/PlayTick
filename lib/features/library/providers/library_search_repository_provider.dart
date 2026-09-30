import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:playtick/features/library/data/demo/demo_client.dart';
import 'package:playtick/features/library/data/igdb/igdb_client.dart';
import 'package:playtick/features/library/data/igdb/igdb_credentials.dart';
import 'package:playtick/features/library/domain/library_search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_search_repository_provider.g.dart';

LibrarySearchRepository librarySearchRepositoryFor({
  required IgdbCredentials credentials,
  http.Client? httpClient,
  String? preferredRegionIdentifier,
}) {
  if (!credentials.isConfigured) {
    return DemoClient();
  }

  final client = httpClient;
  if (client == null) {
    throw ArgumentError.notNull('httpClient');
  }

  return IgdbClient(
    client: client,
    credentials: credentials,
    tokenUrl: 'https://id.twitch.tv',
    searchUrl: 'https://api.igdb.com/v4',
    preferredRegionIdentifier: preferredRegionIdentifier,
  );
}

@Riverpod(keepAlive: true)
LibrarySearchRepository librarySearchRepository(Ref ref) {
  final credentials = IgdbCredentials.fromEnvironment();
  if (!credentials.isConfigured) {
    return librarySearchRepositoryFor(credentials: credentials);
  }

  final client = http.Client();
  ref.onDispose(client.close);

  return librarySearchRepositoryFor(
    credentials: credentials,
    httpClient: client,
    preferredRegionIdentifier:
        PlatformDispatcher.instance.locale.languageCode == 'fr' ? 'EU' : null,
  );
}
