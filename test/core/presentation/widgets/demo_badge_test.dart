import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app_theme.dart';
import 'package:playtick/core/presentation/widgets/demo_badge.dart';
import 'package:playtick/features/home/presentation/home_screen.dart';
import 'package:playtick/features/home/presentation/providers/active_play_session_provider.dart';
import 'package:playtick/features/home/presentation/providers/weekly_playtime_provider.dart';
import 'package:playtick/features/library/presentation/game_details/game_details_screen.dart';
import 'package:playtick/features/library/presentation/library_screen.dart';
import 'package:playtick/features/library/presentation/providers/game_notes_provider.dart';
import 'package:playtick/features/library/presentation/providers/library_game_provider.dart';
import 'package:playtick/features/library/presentation/providers/library_games_provider.dart';
import 'package:playtick/features/library/providers/demo_mode_provider.dart';
import 'package:playtick/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'demo badge uses a light primary pill on iOS and an outline on Android',
    (
      tester,
    ) async {
      await _pumpBadge(tester);

      final android = _decoration(tester);
      expect(android.color, AppTheme.primary.withValues(alpha: 0.12));
      expect(android.borderRadius, BorderRadius.circular(8));
      expect(android.border, isNotNull);
      expect(find.text('Demo'), findsOneWidget);
      expect(
        tester.widget<Text>(find.text('Demo')).style?.color,
        AppTheme.primary,
      );

      await _pumpBadge(tester, platform: TargetPlatform.iOS);
      await tester.pumpAndSettle();
      final ios = _decoration(tester);
      expect(ios.borderRadius, BorderRadius.circular(999));
      expect(ios.border, isNull);
    },
  );

  testWidgets('demo badge uses the French label', (tester) async {
    await _pumpBadge(tester, locale: const Locale('fr'));

    expect(find.text('Démo'), findsOneWidget);
  });

  testWidgets(
    'home and library show the demo badge only while demo mode is on',
    (
      tester,
    ) async {
      await _pumpScreen(tester, const HomeScreen(), demo: true);
      expect(find.byType(DemoBadge), findsOneWidget);

      await _pumpScreen(tester, const LibraryScreen(), demo: true);
      expect(find.byType(DemoBadge), findsOneWidget);

      await _pumpScreen(tester, const HomeScreen(), demo: false);
      expect(find.byType(DemoBadge), findsNothing);

      await _pumpScreen(tester, const LibraryScreen(), demo: false);
      expect(find.byType(DemoBadge), findsNothing);
    },
  );

  testWidgets('game details does not show the demo badge', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          demoModeProvider.overrideWithValue(true),
          libraryGameProvider(1).overrideWith((ref) => Stream.value(null)),
          gameNotesProvider(1).overrideWith(
            (ref) => Stream.value(const []),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light,
          home: const GameDetailsScreen(gameId: '1'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DemoBadge), findsNothing);
  });
}

Future<void> _pumpBadge(
  WidgetTester tester, {
  TargetPlatform platform = TargetPlatform.android,
  Locale? locale,
}) {
  return tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light.copyWith(platform: platform),
      home: const Scaffold(body: Center(child: DemoBadge())),
    ),
  );
}

BoxDecoration _decoration(WidgetTester tester) {
  return tester
          .widget<Container>(
            find.descendant(
              of: find.byType(DemoBadge),
              matching: find.byType(Container),
            ),
          )
          .decoration!
      as BoxDecoration;
}

Future<void> _pumpScreen(
  WidgetTester tester,
  Widget screen, {
  required bool demo,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        demoModeProvider.overrideWithValue(demo),
        weeklyPlaytimeProvider.overrideWith(
          (ref) => Stream.value(Duration.zero),
        ),
        libraryGamesProvider.overrideWith((ref) => Stream.value(const [])),
        activePlaySessionProvider.overrideWith((ref) => Stream.value(null)),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        home: Scaffold(body: screen),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
