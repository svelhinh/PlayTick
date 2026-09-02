import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:playtick/features/library/data/igdb/igdb_credentials.dart';
import 'package:playtick/features/library/domain/library_exception.dart';

final class IgdbClient {
  IgdbClient({
    required this.client,
    required this.credentials,
    required this.baseUrl,
  });

  final http.Client client;
  final IgdbCredentials credentials;
  final String baseUrl;

  Future<String> fetchToken() async {
    if (!credentials.isConfigured) {
      throw const IgdbCredentialsNotConfiguredException();
    }

    final response = await client.post(
      Uri.parse('$baseUrl/oauth2/token'),
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
}
