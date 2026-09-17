import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app.dart';
import 'package:playtick/app/router/app_router.dart';
import 'package:playtick/core/presentation/widgets/delete_dialog.dart';
import 'package:playtick/core/presentation/widgets/error_state_card.dart';
import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/data/database/database_provider.dart';
import 'package:playtick/features/library/domain/estimated_playtimes.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_note.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/presentation/game_details/game_details_screen.dart';
import 'package:playtick/features/library/presentation/game_details/game_notes_card.dart';
import 'package:playtick/features/library/presentation/game_details/play_session_sheet.dart';
import 'package:playtick/features/library/presentation/library_screen.dart';
import 'package:playtick/features/library/presentation/providers/game_notes_provider.dart';
import 'package:playtick/features/library/presentation/providers/library_game_provider.dart';
import 'package:playtick/features/library/presentation/widgets/library_game_card.dart';
import 'package:playtick/features/library/providers/library_repository_provider.dart';

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

  Future<void> pumpApp(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
  }) async {
    tester.binding.platformDispatcher.localesTestValue = [locale];
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
    'leaving details via Home twice does not crash and shows the library list',
    (tester) async {
      await seedLibrary();
      await pumpApp(tester);
      await openLibrary(tester);

      await tester.tap(seeDetailsOnCard('Hollow Knight'));
      await tester.pumpAndSettle();
      expect(find.byType(GameDetailsScreen), findsOneWidget);

      await tester.tap(find.byType(NavigationDestination).at(0));
      await tester.pumpAndSettle();
      expect(find.byType(GameDetailsScreen), findsNothing);

      await tester.tap(find.byType(NavigationDestination).at(1));
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);
      expect(find.byType(GameDetailsScreen), findsNothing);

      await tester.tap(seeDetailsOnCard('Hollow Knight'));
      await tester.pumpAndSettle();
      expect(find.byType(GameDetailsScreen), findsOneWidget);

      await tester.tap(find.byType(NavigationDestination).at(0));
      await tester.pumpAndSettle();
      expect(find.byType(GameDetailsScreen), findsNothing);

      await tester.tap(find.byType(NavigationDestination).at(1));
      await tester.pumpAndSettle();

      expect(find.byType(LibraryScreen), findsOneWidget);
      expect(find.byType(GameDetailsScreen), findsNothing);
    },
  );

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
        find.text(
          'Story: 10 h 00 min\nMain: 15 h 00 min\nCompletion: 20 h 00 min',
        ),
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
      await tester.pump();

      expect(find.text('Game not found'), findsNothing);

      await tester.pumpAndSettle();

      expect(find.byType(LibraryScreen), findsOneWidget);
      expect(find.byType(GameDetailsScreen), findsNothing);
      expect(find.text('Hollow Knight'), findsNothing);
      expect(find.text('Cocoon'), findsOneWidget);
      expect(find.text('1 game'), findsOneWidget);
    },
  );

  testWidgets(
    'localizes PlayTick labels and genres without translating IGDB metadata',
    (tester) async {
      final repository = container.read(libraryRepositoryProvider);
      await repository.addGame(
        Game(
          id: 202,
          name: 'External Game Name',
          summary: 'An English summary supplied by IGDB.',
          genres: ['Adventure', 'Future IGDB genre'],
          developer: 'English Developer',
          publisher: 'English Publisher',
          platforms: ['PC', 'Xbox Series X|S'],
        ),
      );

      await pumpApp(tester, locale: const Locale('fr'));
      await openLibrary(tester);

      await tester.tap(
        find.descendant(
          of: find.byType(LibraryGameCard),
          matching: find.text('Voir'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GameDetailsScreen), findsOneWidget);
      expect(find.text('À propos du jeu'), findsOneWidget);
      expect(find.text('Genres'), findsOneWidget);
      expect(find.text('Développeur'), findsOneWidget);
      expect(find.text('Éditeur'), findsOneWidget);
      expect(find.text('Plateformes'), findsOneWidget);
      expect(find.text('À jouer'), findsOneWidget);

      expect(find.text('External Game Name'), findsWidgets);
      expect(
        find.text('An English summary supplied by IGDB.'),
        findsOneWidget,
      );
      expect(find.text('Aventure, Future IGDB genre'), findsOneWidget);
      expect(find.text('English Developer'), findsWidgets);
      expect(find.text('English Publisher'), findsOneWidget);
      expect(find.text('PC, Xbox Series X|S'), findsOneWidget);

      expect(find.text('About the game'), findsNothing);
      expect(find.text('Developer'), findsNothing);
      expect(find.text('Publisher'), findsNothing);
      expect(find.text('Platforms'), findsNothing);
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
    expect(find.byType(ErrorStateCard), findsOneWidget);
    expect(find.text('Game not found'), findsOneWidget);
    expect(
      find.text('The game you are looking for is not in your library.'),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsNothing);
    expect(find.byIcon(Icons.delete), findsNothing);
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
    expect(find.byType(ErrorStateCard), findsOneWidget);
    expect(find.text('Game not found'), findsOneWidget);
    expect(
      find.text('The game you are looking for is not in your library.'),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsNothing);
  });

  testWidgets('retries loading game details after a failure', (tester) async {
    await seedLibrary();

    var loadCount = 0;
    container.dispose();
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        databaseProvider.overrideWith((_) => database),
        libraryGameProvider(200).overrideWith((ref) {
          loadCount++;
          return loadCount == 1
              ? Stream.error(Exception('drift connection failed'))
              : ref.read(libraryRepositoryProvider).watchGame(200);
        }),
      ],
    );
    await pumpApp(tester);
    await openLibrary(tester);
    await tester.tap(seeDetailsOnCard('Hollow Knight'));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorStateCard), findsOneWidget);
    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Please try again later.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.textContaining('drift connection failed'), findsNothing);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(loadCount, 2);
    expect(find.text('Hollow Knight'), findsWidgets);
    expect(find.byType(ErrorStateCard), findsNothing);
  });

  testWidgets('retries loading notes after a failure', (tester) async {
    await seedLibrary();

    var loadCount = 0;
    container.dispose();
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        databaseProvider.overrideWith((_) => database),
        gameNotesProvider(200).overrideWith((ref) {
          loadCount++;
          return loadCount == 1
              ? Stream.error(Exception('notes failed'))
              : Stream.value([
                  GameNote(
                    id: 1,
                    gameId: 200,
                    content: 'Recovered note',
                    createdAt: DateTime.utc(2024),
                  ),
                ]);
        }),
      ],
    );
    await pumpApp(tester);
    await openLibrary(tester);
    await tester.tap(seeDetailsOnCard('Hollow Knight'));
    await tester.pumpAndSettle();

    expect(find.text('Hollow Knight'), findsWidgets);
    expect(find.byType(GameNotesCard), findsNothing);
    expect(find.byType(ErrorStateCard), findsOneWidget);
    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.ensureVisible(find.text('Retry'));
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(loadCount, 2);
    expect(find.byType(ErrorStateCard), findsNothing);
    expect(find.byType(GameNotesCard), findsOneWidget);
    expect(find.text('Recovered note'), findsOneWidget);
  });

  testWidgets('adds a general note from game details', (tester) async {
    await seedLibrary();
    await pumpApp(tester);
    await openLibrary(tester);
    await tester.tap(seeDetailsOnCard('Hollow Knight'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Add a note'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add a note'));
    await tester.pumpAndSettle();

    var saveButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Add note'),
    );
    expect(saveButton.onPressed, isNull);

    await tester.enterText(
      find.byType(TextFormField),
      '  Upgrade the Nail before the boss  ',
    );
    await tester.pump();

    saveButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Add note'),
    );
    expect(saveButton.onPressed, isNotNull);

    final addNoteButton = find.widgetWithText(FilledButton, 'Add note');
    await tester.ensureVisible(addNoteButton);
    await tester.pump();
    await tester.tap(addNoteButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Upgrade the Nail before the boss'), findsOneWidget);
    final notes = await database.select(database.gameNotes).get();
    expect(notes, hasLength(1));
    expect(notes.single.content, 'Upgrade the Nail before the boss');
  });

  testWidgets('edits and deletes a general note from game details', (
    tester,
  ) async {
    await seedLibrary();
    final repository = container.read(libraryRepositoryProvider);
    await repository.addGameNote(200, 'Initial note');
    await pumpApp(tester);
    await openLibrary(tester);
    await tester.tap(seeDetailsOnCard('Hollow Knight'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Updated note');
    final saveNoteButton = find.widgetWithText(FilledButton, 'Save note');
    await tester.ensureVisible(saveNoteButton);
    await tester.pump();
    await tester.tap(saveNoteButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Updated note'), findsOneWidget);
    expect(
      (await database.select(database.gameNotes).get()).single.content,
      'Updated note',
    );

    await tester.ensureVisible(find.byIcon(Icons.edit));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete note'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete note'));
    await tester.pumpAndSettle();

    expect(find.text('Updated note'), findsNothing);
    expect(await database.select(database.gameNotes).get(), isEmpty);
  });

  testWidgets(
    'adds a manual play session from game details',
    (tester) async {
      await seedLibrary();
      await pumpApp(tester);
      await openLibrary(tester);

      await tester.tap(seeDetailsOnCard('Cocoon'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Add a session'));
      await tester.tap(find.text('Add a session'));
      await tester.pumpAndSettle();

      expect(find.text('Add session'), findsOneWidget);

      await tester.enterText(
        find.byType(TextFormField),
        'Boss beaten',
      );
      await tester.ensureVisible(find.text('Add session'));
      await tester.tap(find.text('Add session'));
      await tester.pumpAndSettle();

      expect(find.text('Add session'), findsNothing);
      expect(find.text('Boss beaten'), findsOneWidget);
      expect(find.text('15 min'), findsWidgets);

      final dateLabel = MaterialLocalizations.of(
        tester.element(find.byType(GameDetailsScreen)),
      ).formatShortDate(DateTime.now());

      expect(find.text(dateLabel), findsOneWidget);
    },
  );

  testWidgets(
    'edits a play session from game details',
    (tester) async {
      await seedLibrary();
      await container
          .read(libraryRepositoryProvider)
          .addPlaySession(
            201,
            DateTime.now(),
            const Duration(minutes: 15),
            note: 'Boss beaten',
          );
      await pumpApp(tester);
      await openLibrary(tester);

      await tester.tap(seeDetailsOnCard('Cocoon'));
      await tester.pumpAndSettle();

      expect(find.text('Boss beaten'), findsOneWidget);
      expect(find.text('15 min'), findsWidgets);

      await tester.ensureVisible(find.byIcon(Icons.edit));
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      expect(find.text('Edit a session'), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(PlaySessionSheet),
          matching: find.byIcon(Icons.add),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'Chapter 2');
      await tester.ensureVisible(find.text('Save session'));
      await tester.tap(find.text('Save session'));
      await tester.pumpAndSettle();

      expect(find.text('Edit a session'), findsNothing);
      expect(find.text('Boss beaten'), findsNothing);
      expect(find.text('Chapter 2'), findsOneWidget);
      expect(find.text('30 min'), findsWidgets);
      expect(find.text('15 min'), findsNothing);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.ancestor(
            of: find.text('Cocoon'),
            matching: find.byType(LibraryGameCard),
          ),
          matching: find.text('30 min'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'deletes a play session from game details',
    (tester) async {
      await seedLibrary();
      await container
          .read(libraryRepositoryProvider)
          .addPlaySession(
            201,
            DateTime.now(),
            const Duration(minutes: 15),
            note: 'Boss beaten',
          );
      await pumpApp(tester);
      await openLibrary(tester);

      await tester.tap(seeDetailsOnCard('Cocoon'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byIcon(Icons.edit));
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(PlaySessionSheet),
          matching: find.byIcon(Icons.delete),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DeleteConfirmationDialog), findsOneWidget);
      expect(find.text('Delete this session'), findsOneWidget);

      await tester.tap(find.text('Delete session'));
      await tester.pumpAndSettle();

      expect(find.byType(PlaySessionSheet), findsNothing);
      expect(find.text('Boss beaten'), findsNothing);
      expect(find.text('15 min'), findsNothing);
      expect(find.byType(GameDetailsScreen), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.ancestor(
            of: find.text('Cocoon'),
            matching: find.byType(LibraryGameCard),
          ),
          matching: find.text('15 min'),
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'canceling play session delete keeps the session',
    (tester) async {
      await seedLibrary();
      await container
          .read(libraryRepositoryProvider)
          .addPlaySession(
            201,
            DateTime.now(),
            const Duration(minutes: 15),
            note: 'Boss beaten',
          );
      await pumpApp(tester);
      await openLibrary(tester);

      await tester.tap(seeDetailsOnCard('Cocoon'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byIcon(Icons.edit));
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(PlaySessionSheet),
          matching: find.byIcon(Icons.delete),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.descendant(
          of: find.byType(DeleteConfirmationDialog),
          matching: find.text('Cancel'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DeleteConfirmationDialog), findsNothing);
      expect(find.text('Edit a session'), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byType(PlaySessionSheet),
          matching: find.text('Cancel'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(PlaySessionSheet), findsNothing);
      expect(find.text('Boss beaten'), findsOneWidget);
      expect(find.text('15 min'), findsWidgets);
    },
  );
}
