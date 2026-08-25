import 'package:http/http.dart' as http;
import 'package:playtick/core/network/json_placeholder_client.dart';
import 'package:playtick/core/network/json_placeholder_post_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_providers.g.dart';

@Riverpod(keepAlive: true)
http.Client jsonPlaceholderHttpClient(Ref ref) {
  final httpClient = http.Client();

  ref.onDispose(httpClient.close);

  return httpClient;
}

@riverpod
JsonPlaceholderClient jsonPlaceholderClient(Ref ref) {
  final httpClient = ref.watch(jsonPlaceholderHttpClientProvider);

  final baseUri = Uri.parse('https://jsonplaceholder.typicode.com');

  return JsonPlaceholderClient(httpClient, baseUri);
}

@riverpod
Future<JsonPlaceholderPostDto> jsonPlaceholderPost(Ref ref, int id) {
  final client = ref.watch(jsonPlaceholderClientProvider);

  return client.fetchPost(id);
}
