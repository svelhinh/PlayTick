import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/features/library/presentation/library_screen.dart';

void main() {
  testWidgets('Home screen Empty Card button navigates to the library screen', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: PlayTick()));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(EmptyStateCard),
        matching: find.byType(FilledButton),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LibraryScreen), findsOneWidget);
  });
}
