import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app.dart';
import 'package:playtick/app/app_theme.dart';

void main() {
  testWidgets('renders the PlayTick application', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PlayTick()));

    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, equals('PlayTick'));
    expect(app.debugShowCheckedModeBanner, isFalse);
  });

  testWidgets('renders the PlayTick application with the correct title', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appTitleProvider.overrideWith((ref) => 'Test Title')],
        child: const PlayTick(),
      ),
    );

    await tester.pumpAndSettle();

    final title = tester.widget<MaterialApp>(find.byType(MaterialApp)).title;
    expect(title, equals('Test Title'));
  });

  testWidgets(
    'renders the PlayTick application with the correct theme',
    (tester) async {
      await tester.pumpWidget(const ProviderScope(child: PlayTick()));

      await tester.pumpAndSettle();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

      expect(app.themeMode, ThemeMode.light);
      expect(app.theme?.brightness, Brightness.light);
      expect(app.theme?.useMaterial3, isTrue);
      expect(app.theme?.colorScheme.primary, AppTheme.primary);
    },
  );
}
