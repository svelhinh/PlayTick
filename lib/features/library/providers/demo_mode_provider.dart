import 'package:flutter/foundation.dart';
import 'package:playtick/features/library/data/igdb/igdb_credentials.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'demo_mode_provider.g.dart';

bool demoModeFor(IgdbCredentials credentials, {bool isWeb = false}) =>
    !credentials.isConfigured || isWeb;

@Riverpod(keepAlive: true)
bool demoMode(Ref ref) => demoModeFor(
  IgdbCredentials.fromEnvironment(),
  isWeb: kIsWeb,
);
