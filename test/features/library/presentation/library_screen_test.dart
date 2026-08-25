import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/features/library/presentation/library_screen.dart';

void main() {
  testWidgets('Library screen shows empty state card', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PlayTick()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();

    expect(find.byType(LibraryScreen), findsOneWidget);
    expect(find.byType(EmptyStateCard), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });
}
