import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:playtick/core/network/http_status_exception.dart';
import 'package:playtick/core/network/json_placeholder_client.dart';

void main() {
  test('fetchPost should return a post', () async {
    final client = MockClient((request) async {
      expect(request.url, Uri.parse('https://example.test/posts/7'));

      return Response(jsonEncode({'id': 7, 'title': 'Example'}), 200);
    });

    final api = JsonPlaceholderClient(
      client,
      Uri.parse('https://example.test'),
    );

    addTearDown(client.close);

    final post = await api.fetchPost(7);

    expect(post.id, 7);
    expect(post.title, 'Example');
  });

  test(
    'fetchPost should throw an exception if the status code is not 200',
    () async {
      final client = MockClient((request) async {
        return Response('Service Unavailable', 503);
      });

      final api = JsonPlaceholderClient(
        client,
        Uri.parse('https://example.test'),
      );

      addTearDown(client.close);

      await expectLater(
        api.fetchPost(7),
        throwsA(
          isA<HttpStatusException>().having(
            (e) => e.statusCode,
            'statusCode',
            503,
          ),
        ),
      );
    },
  );

  test(
    'fetchPost throws FormatException for an invalid payload',
    () async {
      final client = MockClient((request) async {
        return Response(jsonEncode({'id': 'seven', 'title': 'Example'}), 200);
      });

      final api = JsonPlaceholderClient(
        client,
        Uri.parse('https://example.test'),
      );

      addTearDown(client.close);

      await expectLater(
        api.fetchPost(7),
        throwsA(isA<FormatException>()),
      );
    },
  );
}
