import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:playtick/features/library/data/igdb/igdb_credentials.dart';
import 'package:playtick/features/library/data/igdb/igdb_game_dto.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/library_exception.dart';

final class IgdbClient {
  IgdbClient({
    required this.client,
    required this.credentials,
    required this.tokenUrl,
    required this.searchUrl,
  });

  final http.Client client;
  final IgdbCredentials credentials;
  final String tokenUrl;
  final String searchUrl;

  Future<String> fetchToken() async {
    if (!credentials.isConfigured) {
      throw const IgdbCredentialsNotConfiguredException();
    }

    final response = await client.post(
      Uri.parse('$tokenUrl/oauth2/token'),
      body: {
        'client_id': credentials.clientId,
        'client_secret': credentials.clientSecret,
        'grant_type': 'client_credentials',
      },
    );

    if (response.statusCode != 200) {
      throw const IgdbTokenFetchException();
    }

    late final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw const IgdbTokenFetchException();
    }

    if (decoded is! Map<String, dynamic>) {
      throw const IgdbTokenFetchException();
    }

    final accessToken = decoded['access_token'];
    if (accessToken is! String || accessToken.isEmpty) {
      throw const IgdbTokenFetchException();
    }

    return accessToken;
  }

  Future<List<Game>> searchGames(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    final accessToken = await fetchToken();

    final response = await client.post(
      Uri.parse('$searchUrl/games'),
      body:
          'search "$query"; fields id, name, summary, cover.url, '
          'genres.name, platforms.name, involved_companies.company.name, '
          'involved_companies.developer, involved_companies.publisher, '
          'first_release_date; limit 20;',
      headers: {
        'Client-ID': credentials.clientId,
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode != 200) {
      throw const IgdbSearchException();
    }

    late final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw const IgdbSearchException();
    }

    if (decoded is! List<dynamic>) {
      throw const IgdbSearchException();
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(IgdbGameDto.fromJson)
        .whereType<IgdbGameDto>()
        .map((dto) => dto.toGame())
        .toList();
  }
}
