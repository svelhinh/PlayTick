import 'package:http/http.dart' as http;
import 'package:playtick/features/library/data/igdb/igdb_client.dart';
import 'package:playtick/features/library/data/igdb/igdb_credentials.dart';
import 'package:playtick/features/library/domain/library_search_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_search_repository_provider.g.dart';

@Riverpod(keepAlive: true)
LibrarySearchRepository librarySearchRepository(Ref ref) {
  final client = http.Client();
  ref.onDispose(client.close);

  return IgdbClient(
    client: client,
    credentials: IgdbCredentials.fromEnvironment(),
    tokenUrl: 'https://id.twitch.tv',
    searchUrl: 'https://api.igdb.com/v4',
  );
}
