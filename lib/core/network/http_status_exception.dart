final class HttpStatusException implements Exception {
  const HttpStatusException({required this.statusCode, required this.uri});

  final int statusCode;
  final Uri uri;

  @override
  String toString() {
    return 'HTTP request to $uri failed with status $statusCode';
  }
}
