import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/data/database/database_provider.dart';
import 'package:playtick/features/library/domain/estimated_playtimes.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_exception.dart';
import 'package:playtick/features/library/domain/library_repository.dart';
import 'package:playtick/features/library/domain/library_search_repository.dart';
import 'package:playtick/features/library/presentation/library_screen.dart';
import 'package:playtick/features/library/presentation/providers/library_games_provider.dart';
import 'package:playtick/features/library/presentation/widgets/igdb_game_card.dart';
import 'package:playtick/features/library/presentation/widgets/library_game_card.dart';
import 'package:playtick/features/library/providers/library_repository_provider.dart';
import 'package:playtick/features/library/providers/library_search_repository_provider.dart';

class _FakeSearchRepository implements LibrarySearchRepository {
  List<Game> games = [];
  Exception? errorToThrow;
  int failuresBeforeSuccess = 0;

  @override
  Future<List<Game>> searchGames(String query) async {
    if (failuresBeforeSuccess > 0) {
      failuresBeforeSuccess--;
      throw const IgdbSearchException();
    }

    final error = errorToThrow;
    if (error != null) {
      throw error;
    }
    return games;
  }
}

void main() {
  late AppDatabase database;
  late ProviderContainer container;
  late _FakeSearchRepository searchRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    searchRepository = _FakeSearchRepository();
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWith((_) => database),
        librarySearchRepositoryProvider.overrideWith((_) => searchRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
    unawaited(database.close());
  });

  Future<void> addGamesToLibrary(LibraryRepository libraryRepository) async {
    await libraryRepository.addGame(
      Game(
        id: 200,
        name: 'Hollow Knight',
        coverUrl:
            'https://images.igdb.com/igdb/image/upload/t_cover_big/co1r79.png',
        summary:
            'A platformer game about a knight who fights enemies '
            'and collects items.',
        releaseDate: DateTime(2017, 2, 24),
        genres: ['Action', 'Adventure', 'Platformer'],
        developer: 'Team Cherry',
        publisher: 'Team Cherry',
        platforms: ['PC', 'Switch'],
        estimatedPlaytimes: const EstimatedPlaytimes(
          main: Duration(hours: 20, minutes: 12),
          story: Duration(hours: 10, minutes: 30),
          completion: Duration(hours: 30, minutes: 45),
        ),
      ),
    );
    await libraryRepository.addGame(
      Game(
        id: 201,
        name: 'Cocoon',
        summary:
            'A puzzle game about a cocoon that helps a young girl '
            'find her way home.',
        releaseDate: DateTime(2023, 9, 29),
        genres: ['Adventure', 'Puzzle'],
        developer: 'Geometric Interactive',
        publisher: 'Annapurna Interactive',
        platforms: ['PC', 'Switch'],
        estimatedPlaytimes: const EstimatedPlaytimes(
          main: Duration(hours: 10, minutes: 30),
          story: Duration(hours: 5, minutes: 15),
          completion: Duration(hours: 15, minutes: 45),
        ),
      ),
      status: GameStatus.playing,
    );
    await libraryRepository.addGame(
      Game(
        id: 202,
        name: 'SOMA',
        summary:
            'A horror game about a man who wakes up in a hospital '
            'and has to escape.',
        releaseDate: DateTime(2015, 9, 22),
        genres: ['Adventure', 'Horror'],
        developer: 'Frictional Games',
        publisher: 'Frictional Games',
        platforms: ['PC', 'PlayStation'],
        estimatedPlaytimes: const EstimatedPlaytimes(
          main: Duration(hours: 20, minutes: 12),
          story: Duration(hours: 10, minutes: 30),
          completion: Duration(hours: 30, minutes: 45),
        ),
      ),
      status: GameStatus.completed,
    );
    await libraryRepository.addGame(
      Game(
        id: 203,
        name: 'NieR: Automata',
        summary:
            'A role-playing game about a robot who fights enemies '
            'and collects items.',
        releaseDate: DateTime(2017, 2, 23),
        genres: ['Action', 'RPG'],
        developer: 'PlatinumGames',
        publisher: 'Square Enix',
        platforms: ['PC', 'PlayStation', 'Switch'],
        estimatedPlaytimes: const EstimatedPlaytimes(
          main: Duration(hours: 40, minutes: 24),
          story: Duration(hours: 20, minutes: 48),
          completion: Duration(hours: 60, minutes: 96),
        ),
      ),
      status: GameStatus.dropped,
    );
  }

  testWidgets('Library screen shows empty state card', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          libraryGamesProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: const PlayTick(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();

    expect(find.byType(LibraryScreen), findsOneWidget);
    expect(find.byType(EmptyStateCard), findsOneWidget);
  });

  testWidgets(
    'Library screen shows a localized error when loading games fails',
    (tester) async {
      tester.binding.platformDispatcher.localesTestValue = const [Locale('en')];
      addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            libraryGamesProvider.overrideWith(
              (ref) => Stream.error(Exception('drift connection failed')),
            ),
          ],
          child: const PlayTick(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(NavigationDestination).at(1));
      await tester.pumpAndSettle();

      expect(find.byType(LibraryScreen), findsOneWidget);
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.textContaining('drift connection failed'), findsNothing);
    },
  );

  testWidgets('Library screen shows library games', (tester) async {
    tester.binding.platformDispatcher.localesTestValue = const [Locale('en')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    final libraryRepository = container.read(libraryRepositoryProvider);

    await addGamesToLibrary(libraryRepository);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
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
    expect(
      find.descendant(
        of: find.byType(LibraryGameCard),
        matching: find.text('Want to play'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(LibraryGameCard),
        matching: find.text('Playing'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(LibraryGameCard),
        matching: find.text('Completed'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(LibraryGameCard),
        matching: find.text('Dropped'),
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.schedule_outlined), findsNothing);

    await libraryRepository.removeGame(200);
    await tester.pumpAndSettle();

    expect(find.text('3 games'), findsOneWidget);
    expect(find.text('Hollow Knight'), findsNothing);
    expect(find.text('Cocoon'), findsOneWidget);
    expect(find.text('SOMA'), findsOneWidget);
    expect(find.text('NieR: Automata'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(LibraryGameCard),
        matching: find.text('Want to play'),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byType(LibraryGameCard),
        matching: find.text('Playing'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(LibraryGameCard),
        matching: find.text('Completed'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(LibraryGameCard),
        matching: find.text('Dropped'),
      ),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.schedule_outlined), findsNothing);

    await libraryRepository.removeGame(201);
    await tester.pumpAndSettle();
    await libraryRepository.removeGame(202);
    await tester.pumpAndSettle();
    await libraryRepository.removeGame(203);
    await tester.pumpAndSettle();

    expect(find.byType(EmptyStateCard), findsOneWidget);
    expect(find.text('3 games'), findsNothing);
  });

  testWidgets('Library screen filters games by status', (tester) async {
    tester.binding.platformDispatcher.localesTestValue = const [Locale('en')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    final libraryRepository = container.read(libraryRepositoryProvider);

    await addGamesToLibrary(libraryRepository);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const PlayTick(),
      ),
    );

    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();

    expect(find.byType(LibraryScreen), findsOneWidget);

    expect(find.text('4 games'), findsOneWidget);
    expect(find.text('Hollow Knight'), findsOneWidget);
    expect(find.text('Cocoon'), findsOneWidget);
    expect(find.text('SOMA'), findsOneWidget);
    expect(find.text('NieR: Automata'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(ChoiceChip),
        matching: find.text('Want to play'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 game'), findsOneWidget);
    expect(find.text('Hollow Knight'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(ChoiceChip),
        matching: find.text('Playing'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 game'), findsOneWidget);
    expect(find.text('Cocoon'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byType(ChoiceChip),
        matching: find.text('Dropped'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 game'), findsOneWidget);
    expect(find.text('NieR: Automata'), findsOneWidget);

    await libraryRepository.updateGameStatus(201, GameStatus.wantToPlay);
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(ChoiceChip),
        matching: find.text('Playing'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EmptyStateCard), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(FilledButton),
        matching: find.text('See all games'),
      ),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(
        of: find.byType(FilledButton),
        matching: find.text('See all games'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('4 games'), findsOneWidget);
    expect(find.text('Hollow Knight'), findsOneWidget);
    expect(find.text('Cocoon'), findsOneWidget);
    expect(find.text('SOMA'), findsOneWidget);
    expect(find.text('NieR: Automata'), findsOneWidget);
  });

  Future<void> openLibrary(WidgetTester tester) async {
    tester.binding.platformDispatcher.localesTestValue = const [Locale('en')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const PlayTick(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();
  }

  Future<void> searchFor(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextField), query);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();
  }

  testWidgets(
    'Library search shows local matches and IGDB hits without duplicates',
    (tester) async {
      final libraryRepository = container.read(libraryRepositoryProvider);
      await addGamesToLibrary(libraryRepository);

      searchRepository.games = [
        Game(id: 200, name: 'Hollow Knight'),
        Game(id: 300, name: 'Celeste'),
      ];

      await openLibrary(tester);
      await searchFor(tester, 'hollow');

      expect(find.text('In your library'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(LibraryGameCard),
          matching: find.text('Hollow Knight'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(LibraryGameCard),
          matching: find.text('See'),
        ),
        findsOneWidget,
      );

      expect(find.text('IGDB results'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(IgdbGameCard),
          matching: find.text('Celeste'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(IgdbGameCard),
          matching: find.text('Hollow Knight'),
        ),
        findsNothing,
      );
      expect(find.text('Cocoon'), findsNothing);
    },
  );

  testWidgets(
    'Library search clear button restores the library list',
    (tester) async {
      final libraryRepository = container.read(libraryRepositoryProvider);
      await addGamesToLibrary(libraryRepository);
      searchRepository.games = [Game(id: 300, name: 'Celeste')];

      await openLibrary(tester);
      await searchFor(tester, 'hollow');

      expect(find.byType(IgdbGameCard), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextField, 'hollow'), findsNothing);
      expect(find.byType(IgdbGameCard), findsNothing);
      expect(find.text('4 games'), findsOneWidget);
      expect(find.byType(ChoiceChip), findsWidgets);
    },
  );

  testWidgets(
    'Library search keeps local results when IGDB fails',
    (tester) async {
      final libraryRepository = container.read(libraryRepositoryProvider);
      await addGamesToLibrary(libraryRepository);
      searchRepository.errorToThrow = const IgdbSearchException();

      await openLibrary(tester);
      await searchFor(tester, 'hollow');

      expect(
        find.descendant(
          of: find.byType(LibraryGameCard),
          matching: find.text('Hollow Knight'),
        ),
        findsOneWidget,
      );
      expect(find.byType(IgdbGameCard), findsNothing);
      expect(
        find.text('Unable to retrieve external results at the moment.'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Library search shows an empty IGDB state without hiding local matches',
    (tester) async {
      final libraryRepository = container.read(libraryRepositoryProvider);
      await addGamesToLibrary(libraryRepository);
      searchRepository.games = [];

      await openLibrary(tester);
      await searchFor(tester, 'hollow');

      expect(
        find.descendant(
          of: find.byType(LibraryGameCard),
          matching: find.text('Hollow Knight'),
        ),
        findsOneWidget,
      );
      expect(find.byType(IgdbGameCard), findsNothing);
      expect(find.text('No games found'), findsOneWidget);
      expect(
        find.text('Unable to retrieve external results at the moment.'),
        findsNothing,
      );
    },
  );

  testWidgets(
    'Library search retry loads IGDB results after an error',
    (tester) async {
      searchRepository.failuresBeforeSuccess = 1;
      searchRepository.games = [Game(id: 300, name: 'Celeste')];

      await openLibrary(tester);
      await searchFor(tester, 'celeste');

      expect(
        find.text('Unable to retrieve external results at the moment.'),
        findsOneWidget,
      );
      expect(find.byType(IgdbGameCard), findsNothing);

      await tester.tap(find.text('Retry'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();

      expect(
        find.text('Unable to retrieve external results at the moment.'),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byType(IgdbGameCard),
          matching: find.text('Celeste'),
        ),
        findsOneWidget,
      );
    },
  );

  Game celesteGame() => Game(id: 300, name: 'Celeste');

  Future<void> openAddSheetForCeleste(WidgetTester tester) async {
    searchRepository.games = [celesteGame()];
    await openLibrary(tester);
    await searchFor(tester, 'celeste');

    await tester.tap(
      find.descendant(
        of: find.byType(IgdbGameCard),
        matching: find.text('Add'),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Library search adds an IGDB game with want to play by default',
    (tester) async {
      await openAddSheetForCeleste(tester);

      await tester.tap(find.widgetWithText(FilledButton, 'Add').last);
      await tester.pumpAndSettle();

      expect(find.byType(IgdbGameCard), findsNothing);
      expect(
        find.descendant(
          of: find.byType(LibraryGameCard),
          matching: find.text('Celeste'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(LibraryGameCard),
          matching: find.text('Want to play'),
        ),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextField, 'celeste'), findsOneWidget);
    },
  );

  testWidgets(
    'Library search adds an IGDB game with the selected status',
    (tester) async {
      await openAddSheetForCeleste(tester);

      await tester.tap(find.text('Playing'));
      await tester.pump();
      await tester.tap(find.widgetWithText(FilledButton, 'Add').last);
      await tester.pumpAndSettle();

      expect(find.byType(IgdbGameCard), findsNothing);
      expect(
        find.descendant(
          of: find.byType(LibraryGameCard),
          matching: find.text('Celeste'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(LibraryGameCard),
          matching: find.text('Playing'),
        ),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextField, 'celeste'), findsOneWidget);
    },
  );
}
