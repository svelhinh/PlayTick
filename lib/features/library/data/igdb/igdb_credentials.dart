final class IgdbCredentials {
  const IgdbCredentials({
    required this.clientId,
    required this.clientSecret,
  });

  factory IgdbCredentials.fromEnvironment() {
    return const IgdbCredentials(
      clientId: String.fromEnvironment('IGDB_CLIENT_ID'),
      clientSecret: String.fromEnvironment('IGDB_CLIENT_SECRET'),
    );
  }

  final String clientId;
  final String clientSecret;

  bool get isConfigured => clientId.isNotEmpty && clientSecret.isNotEmpty;
}
