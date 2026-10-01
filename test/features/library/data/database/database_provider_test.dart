import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/data/database/database_provider.dart';
import 'package:playtick/features/library/data/igdb/igdb_credentials.dart';

void main() {
  test('uses the demo database when IGDB credentials are absent', () {
    expect(
      databaseNameFor(const IgdbCredentials(clientId: '', clientSecret: '')),
      'playtick_demo',
    );
  });

  test('uses the normal database when IGDB credentials are configured', () {
    expect(
      databaseNameFor(
        const IgdbCredentials(clientId: 'client', clientSecret: 'secret'),
      ),
      'playtick',
    );
  });
}
