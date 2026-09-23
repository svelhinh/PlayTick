import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/presentation/widgets/duration_picker_dialog.dart';
import 'package:playtick/l10n/app_localizations.dart';

void main() {
  Future<void> pumpDialog(
    WidgetTester tester, {
    required Duration duration,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: DurationPickerDialog(duration: duration),
        ),
      ),
    );
  }

  testWidgets('clamps an initial duration below one minute to one minute', (
    tester,
  ) async {
    await pumpDialog(tester, duration: const Duration(seconds: 30));

    expect(find.text('0'), findsOneWidget);
    expect(find.text('01'), findsOneWidget);
  });

  testWidgets('does not decrease the duration below one minute', (
    tester,
  ) async {
    await pumpDialog(tester, duration: const Duration(minutes: 1));

    await tester.tap(find.byIcon(Icons.remove).last);
    await tester.pump();

    expect(find.text('0'), findsOneWidget);
    expect(find.text('01'), findsOneWidget);
  });

  testWidgets('decreasing minutes at one hour wraps to 0h59', (tester) async {
    await pumpDialog(tester, duration: const Duration(hours: 1));

    await tester.tap(find.byIcon(Icons.remove).last);
    await tester.pump();

    expect(find.text('0'), findsOneWidget);
    expect(find.text('59'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
