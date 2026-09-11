import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/features/home/presentation/finish_active_play_session_sheet.dart';
import 'package:playtick/l10n/app_localizations.dart';

void main() {
  testWidgets('clamps, edits, and submits the duration and note', (
    tester,
  ) async {
    Duration? savedDuration;
    String? savedNote;
    var deleteCalls = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (context) => FinishActivePlaySessionSheet(
                  onSave: (duration, note) async {
                    savedDuration = duration;
                    savedNote = note;
                  },
                  onDelete: () async {
                    deleteCalls++;
                  },
                  coverUrl: null,
                  gameTitle: 'Celeste',
                  startedAt: DateTime(2026, 9, 10, 14),
                  initialDuration: const Duration(seconds: 30),
                ),
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('1 min'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(deleteCalls, 0);
    expect(find.byType(FinishActivePlaySessionSheet), findsOneWidget);

    await tester.tap(find.text('Edit duration'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add).last);
    await tester.pump();
    await tester.tap(find.text('Validate'));
    await tester.pumpAndSettle();

    expect(find.text('2 min'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '  Boss defeated  ');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(savedDuration, const Duration(minutes: 2));
    expect(savedNote, 'Boss defeated');
    expect(find.byType(FinishActivePlaySessionSheet), findsNothing);
  });
}
