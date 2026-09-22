import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/core/presentation/widgets/playtick_sheet.dart';
import 'package:playtick/features/home/presentation/widgets/finish_active_play_session_sheet.dart';
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
              onPressed: () => showPlaytickSheet<void>(
                context: context,
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

  testWidgets('ignores a second save tap while the first is in flight', (
    tester,
  ) async {
    final saveGate = Completer<void>();
    var saveCalls = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () => showPlaytickSheet<void>(
                context: context,
                builder: (context) => FinishActivePlaySessionSheet(
                  onSave: (duration, note) async {
                    saveCalls++;
                    await saveGate.future;
                  },
                  onDelete: () async {},
                  coverUrl: null,
                  gameTitle: 'Celeste',
                  startedAt: DateTime(2026, 9, 10, 14),
                  initialDuration: const Duration(minutes: 12),
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

    final saveButton = find.descendant(
      of: find.byType(FinishActivePlaySessionSheet),
      matching: find.byType(FilledButton),
    );

    await tester.tap(saveButton);
    await tester.pump();

    expect(saveCalls, 1);
    expect(tester.widget<FilledButton>(saveButton).onPressed, isNull);
    expect(
      find.descendant(
        of: saveButton,
        matching: find.byType(CircularProgressIndicator),
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.delete), findsNothing);

    await tester.tap(saveButton);
    await tester.pump();

    expect(saveCalls, 1);

    saveGate.complete();
    await tester.pumpAndSettle();

    expect(find.byType(FinishActivePlaySessionSheet), findsNothing);
  });
}
