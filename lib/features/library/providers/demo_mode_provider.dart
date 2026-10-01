import 'package:playtick/features/library/data/igdb/igdb_credentials.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'demo_mode_provider.g.dart';

bool demoModeFor(IgdbCredentials credentials) => !credentials.isConfigured;

@Riverpod(keepAlive: true)
bool demoMode(Ref ref) => demoModeFor(IgdbCredentials.fromEnvironment());
