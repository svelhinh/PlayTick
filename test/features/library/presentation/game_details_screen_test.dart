import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app.dart';
import 'package:playtick/app/router/app_router.dart';
import 'package:playtick/core/database/app_database.dart';
import 'package:playtick/core/database/database_provider.dart';
import 'package:playtick/features/library/domain/estimated_playtimes.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/presentation/game_details_screen.dart';
import 'package:playtick/features/library/presentation/library_screen.dart';
import 'package:playtick/features/library/presentation/providers/library_repository_provider.dart';
import 'package:playtick/features/library/presentation/widgets/library_game_card.dart';

void main() {
  late AppDatabase database;
  late ProviderContainer container;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWith((_) => database),
      ],
    );
  });

  tearDown(() {
    container.dispose();
    unawaited(database.close());
  });

  Future<void> seedLibrary() async {
    final libraryRepository = container.read(libraryRepositoryProvider);

    await libraryRepository.addGame(
      Game(
        id: 200,
        name: 'Hollow Knight',
        summary: 'A challenging platformer with a unique art style.',
        releaseDate: DateTime.utc(2017, 2, 24),
        genres: ['Platformer', 'Action-Adventure'],
        developer: 'Team Cherry',
        publisher: 'Team Cherry',
        platforms: ['PC', 'Nintendo Switch'],
        estimatedPlaytimes: const EstimatedPlaytimes(
          story: Duration(hours: 10),
          main: Duration(hours: 15),
          completion: Duration(hours: 20),
        ),
      ),
    );
    await libraryRepository.addGame(
      Game(
        id: 201,
        name: 'Cocoon',
        developer: 'Geometric Interactive',
        releaseDate: DateTime.utc(2023, 9, 29),
      ),
      status: GameStatus.playing,
    );
  }

  Future<void> pumpApp(WidgetTester tester) async {
    tester.binding.platformDispatcher.localesTestValue = const [Locale('en')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const PlayTick(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openLibrary(WidgetTester tester) async {
    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();
  }

  Finder seeDetailsOnCard(String gameName) {
    return find.descendant(
      of: find.ancestor(
        of: find.text(gameName),
        matching: find.byType(LibraryGameCard),
      ),
      matching: find.text('See'),
    );
  }

  testWidgets(
    'opens game details, updates status and deletes the game',
    (tester) async {
      await seedLibrary();
      await pumpApp(tester);
      await openLibrary(tester);

      await tester.tap(seeDetailsOnCard('Hollow Knight'));
      await tester.pumpAndSettle();

      expect(find.byType(GameDetailsScreen), findsOneWidget);
      expect(find.text('Hollow Knight'), findsWidgets);
      expect(
        find.text('A challenging platformer with a unique art style.'),
        findsOneWidget,
      );
      expect(find.text('Team Cherry • 2017'), findsOneWidget);
      expect(find.text('About the game'), findsOneWidget);
      expect(find.text('Platformer, Action-Adventure'), findsOneWidget);
      expect(find.text('PC, Nintendo Switch'), findsOneWidget);
      expect(
        find.text('Story: 10 h 00\nMain: 15 h 00\nCompletion: 20 h 00'),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(GameDetailsScreen),
          matching: find.text('Want to play'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byType(PopupMenuButton<GameStatus>));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(PopupMenuItem<GameStatus>),
          matching: find.text('Completed'),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(GameDetailsScreen),
          matching: find.text('Completed'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.text('Delete this game'), findsOneWidget);
      expect(
        find.textContaining('Hollow Knight'),
        findsWidgets,
      );

      await tester.ensureVisible(find.text('Delete game'));
      await tester.tap(find.text('Delete game'));
      await tester.pumpAndSettle();

      expect(find.byType(LibraryScreen), findsOneWidget);
      expect(find.byType(GameDetailsScreen), findsNothing);
      expect(find.text('Hollow Knight'), findsNothing);
      expect(find.text('Cocoon'), findsOneWidget);
      expect(find.text('1 game'), findsOneWidget);
    },
  );

  testWidgets('canceling delete keeps the game on the details screen', (
    tester,
  ) async {
    await seedLibrary();
    await pumpApp(tester);
    await openLibrary(tester);

    await tester.tap(seeDetailsOnCard('Hollow Knight'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Cancel'));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(GameDetailsScreen), findsOneWidget);
    expect(find.text('Delete this game'), findsNothing);
    expect(find.text('Hollow Knight'), findsWidgets);
  });

  testWidgets('shows an error when the game id is not a number', (
    tester,
  ) async {
    await pumpApp(tester);

    container.read(appRouterProvider).go('/library/not-a-number');
    await tester.pumpAndSettle();

    expect(find.byType(GameDetailsScreen), findsOneWidget);
    expect(find.text('Something went wrong'), findsOneWidget);
  });

  testWidgets('shows an error when the game is not in the library', (
    tester,
  ) async {
    await seedLibrary();
    await pumpApp(tester);

    container.read(appRouterProvider).go('/library/999');
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.delete), findsNothing);
    expect(find.byType(GameDetailsScreen), findsOneWidget);
    expect(find.text('Something went wrong'), findsOneWidget);
  });
}
