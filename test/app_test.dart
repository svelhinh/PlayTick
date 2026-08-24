import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app.dart';

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
}
