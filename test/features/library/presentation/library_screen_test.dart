import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/features/library/presentation/library_screen.dart';
import 'package:playtick/features/library/presentation/providers/temporary_library_games_provider.dart';

void main() {
  testWidgets('Library screen shows empty state card', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          temporaryLibraryGamesProvider.overrideWithValue(const []),
        ],
        child: const PlayTick(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();

    expect(find.byType(LibraryScreen), findsOneWidget);
    expect(find.byType(EmptyStateCard), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('Library screen shows library games', (tester) async {
    tester.binding.platformDispatcher.localesTestValue = const [Locale('en')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          temporaryLibraryGamesProvider.overrideWithValue(const [
            LibraryGame(
              gameId: 200,
              name: 'Hollow Knight',
              status: GameStatus.wantToPlay,
            ),
            LibraryGame(
              gameId: 201,
              name: 'Cocoon',
              status: GameStatus.playing,
              totalPlaytime: Duration(hours: 20),
            ),
            LibraryGame(
              gameId: 202,
              name: 'SOMA',
              status: GameStatus.completed,
              totalPlaytime: Duration(hours: 10, minutes: 30),
            ),
            LibraryGame(
              gameId: 203,
              name: 'NieR: Automata',
              status: GameStatus.dropped,
            ),
          ]),
        ],
        child: const PlayTick(),
      ),
    );

    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();

    expect(find.byType(LibraryScreen), findsOneWidget);
    expect(find.byType(EmptyStateCard), findsNothing);

    expect(find.text('4 games'), findsOneWidget);
    expect(find.text('Hollow Knight'), findsOneWidget);
    expect(find.text('Cocoon'), findsOneWidget);
    expect(find.text('SOMA'), findsOneWidget);
    expect(find.text('NieR: Automata'), findsOneWidget);
    expect(find.text('Want to play'), findsOneWidget);
    expect(find.text('Playing'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Dropped'), findsOneWidget);
    expect(find.text('20 h 00'), findsOneWidget);
    expect(find.text('10 h 30'), findsOneWidget);
    expect(find.byIcon(Icons.schedule_outlined), findsNWidgets(2));
  });
}
