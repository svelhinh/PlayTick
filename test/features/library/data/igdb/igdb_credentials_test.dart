import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/data/igdb/igdb_credentials.dart';

void main() {
  test(
    'should be configured when IGDB_CLIENT_ID and IGDB_CLIENT_SECRET are set',
    () {
      const credentials = IgdbCredentials(clientId: '', clientSecret: '');
      expect(credentials.isConfigured, isFalse);

      const validCredentials = IgdbCredentials(
        clientId: '1234567890',
        clientSecret: '1234567890',
      );
      expect(validCredentials.isConfigured, isTrue);
    },
  );
}
