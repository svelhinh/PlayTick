import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/features/home/presentation/providers/weekly_playtime_provider.dart';
import 'package:playtick/features/library/presentation/library_screen.dart';
import 'package:playtick/features/library/presentation/providers/library_games_provider.dart';

void main() {
  testWidgets('Home screen Empty Card button navigates to the library screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weeklyPlaytimeProvider.overrideWith(
            (ref) => Stream.value(Duration.zero),
          ),
          libraryGamesProvider.overrideWith(
            (_) => Stream.value(const []),
          ),
        ],
        child: const PlayTick(),
      ),
    );
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

  testWidgets('Home shows zero weekly playtime when there are no sessions', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weeklyPlaytimeProvider.overrideWith(
            (ref) => Stream.value(Duration.zero),
          ),
        ],
        child: const PlayTick(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('0 h 00'), findsOneWidget);
  });

  testWidgets('Home shows this week playtime from recorded sessions', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weeklyPlaytimeProvider.overrideWith(
            (ref) => Stream.value(const Duration(hours: 12, minutes: 45)),
          ),
        ],
        child: const PlayTick(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('12 h 45'), findsOneWidget);
  });
}
