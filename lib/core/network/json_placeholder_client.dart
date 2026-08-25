import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:playtick/core/network/http_status_exception.dart';

import 'package:playtick/core/network/json_placeholder_post_dto.dart';

class JsonPlaceholderClient {
  JsonPlaceholderClient(this._httpClient, this._baseUri);

  final http.Client _httpClient;
  final Uri _baseUri;

  Future<JsonPlaceholderPostDto> fetchPost(int id) async {
    final uri = _baseUri.resolve('/posts/$id');
    final response = await _httpClient.get(uri);

    if (response.statusCode != 200) {
      throw HttpStatusException(
        statusCode: response.statusCode,
        uri: uri,
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid post response');
    }

    return JsonPlaceholderPostDto.fromJson(decoded);
  }
}
