import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app_theme.dart';
import 'package:playtick/core/presentation/widgets/error_state_card.dart';
import 'package:playtick/l10n/app_localizations.dart';

void main() {
  testWidgets(
    'compact error card wraps French copy without overflowing at 360 dp',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.light,
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Builder(
                builder: (context) {
                  final appLoc = AppLocalizations.of(context)!;
                  return ErrorStateCard(
                    title: appLoc.igdbSearchCardErrorTitle,
                    description: appLoc.igdbSearchCardErrorDescription,
                    compact: true,
                    onRetry: () {},
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Impossible de récupérer les résultats externes pour le moment.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Vérifiez votre connexion ou réessayez plus tard.'),
        findsOneWidget,
      );
      expect(find.text('Réessayer'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
