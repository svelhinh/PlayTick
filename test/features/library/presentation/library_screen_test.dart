import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app.dart';
import 'package:playtick/core/database/app_database.dart';
import 'package:playtick/core/database/database_provider.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/features/library/domain/estimated_playtimes.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/presentation/library_screen.dart';
import 'package:playtick/features/library/presentation/providers/library_games_provider.dart';
import 'package:playtick/features/library/presentation/providers/library_repository_provider.dart';

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
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('Library screen shows library games', (tester) async {
    tester.binding.platformDispatcher.localesTestValue = const [Locale('en')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    final libraryRepository = container.read(libraryRepositoryProvider);

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
    expect(find.text('Want to play'), findsOneWidget);
    expect(find.text('Playing'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Dropped'), findsOneWidget);
    expect(find.byIcon(Icons.schedule_outlined), findsNothing);

    await libraryRepository.removeGame(200);
    await tester.pumpAndSettle();

    expect(find.text('3 games'), findsOneWidget);
    expect(find.text('Hollow Knight'), findsNothing);
    expect(find.text('Cocoon'), findsOneWidget);
    expect(find.text('SOMA'), findsOneWidget);
    expect(find.text('NieR: Automata'), findsOneWidget);
    expect(find.text('Want to play'), findsNothing);
    expect(find.text('Playing'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text('Dropped'), findsOneWidget);
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
}
