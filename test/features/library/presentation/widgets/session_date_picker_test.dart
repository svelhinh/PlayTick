import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/library/presentation/widgets/session_date_picker.dart';
import 'package:playtick/l10n/app_localizations.dart';

void main() {
  Future<void> pumpPickerButton(
    WidgetTester tester, {
    required TargetPlatform platform,
    required void Function(DateTime? picked) onPicked,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: platform),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                final picked = await showSessionDatePicker(
                  context: context,
                  selectedDate: DateTime(2024, 6, 15),
                );
                onPicked(picked);
              },
              child: const Text('pick'),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('shows a Cupertino date wheel on iOS and returns the date', (
    tester,
  ) async {
    DateTime? picked;

    await pumpPickerButton(
      tester,
      platform: TargetPlatform.iOS,
      onPicked: (value) => picked = value,
    );

    await tester.tap(find.text('pick'));
    await tester.pumpAndSettle();

    expect(find.byType(CupertinoDatePicker), findsOneWidget);

    await tester.tap(find.text('Validate'));
    await tester.pumpAndSettle();

    expect(picked, DateTime(2024, 6, 15));
    expect(find.byType(CupertinoDatePicker), findsNothing);
  });

  testWidgets('shows the Material calendar on Android', (tester) async {
    await pumpPickerButton(
      tester,
      platform: TargetPlatform.android,
      onPicked: (_) {},
    );

    await tester.tap(find.text('pick'));
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsOneWidget);
    expect(find.byType(CupertinoDatePicker), findsNothing);
  });
}
