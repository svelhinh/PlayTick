import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/features/home/presentation/providers/active_play_session_provider.dart';
import 'package:playtick/features/home/presentation/providers/timer_now_provider.dart';
import 'package:playtick/features/home/presentation/providers/weekly_playtime_provider.dart';
import 'package:playtick/features/home/presentation/widgets/finish_active_play_session_sheet.dart';
import 'package:playtick/features/library/data/database/app_database.dart';
import 'package:playtick/features/library/data/drift_library_repository.dart';
import 'package:playtick/features/library/domain/active_play_session.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/library_game.dart';
import 'package:playtick/features/library/presentation/library_screen.dart';
import 'package:playtick/features/library/presentation/providers/library_games_provider.dart';
import 'package:playtick/features/library/providers/library_repository_provider.dart';

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
          activePlaySessionProvider.overrideWith(
            (_) => Stream.value(null),
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
          libraryGamesProvider.overrideWith(
            (_) => Stream.value(const []),
          ),
          activePlaySessionProvider.overrideWith(
            (_) => Stream.value(null),
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
          libraryGamesProvider.overrideWith(
            (_) => Stream.value(const []),
          ),
          activePlaySessionProvider.overrideWith(
            (_) => Stream.value(null),
          ),
        ],
        child: const PlayTick(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('12 h 45'), findsOneWidget);
  });

  testWidgets('Home excludes non-playing games from its summary', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weeklyPlaytimeProvider.overrideWith(
            (_) => Stream.value(Duration.zero),
          ),
          libraryGamesProvider.overrideWith(
            (_) => Stream.value(const [
              LibraryGame(
                gameId: 1,
                name: 'Celeste',
                status: GameStatus.completed,
              ),
            ]),
          ),
          activePlaySessionProvider.overrideWith(
            (_) => Stream.value(null),
          ),
        ],
        child: const PlayTick(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget);
    expect(find.byType(EmptyStateCard), findsOneWidget);
  });

  testWidgets('Home lists every playing game and excludes other statuses', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weeklyPlaytimeProvider.overrideWith(
            (_) => Stream.value(Duration.zero),
          ),
          libraryGamesProvider.overrideWith(
            (_) => Stream.value(const [
              LibraryGame(
                gameId: 1,
                name: 'Hollow Knight',
                status: GameStatus.playing,
              ),
              LibraryGame(
                gameId: 2,
                name: 'Outer Wilds',
                status: GameStatus.playing,
              ),
              LibraryGame(
                gameId: 3,
                name: 'Celeste',
                status: GameStatus.completed,
              ),
            ]),
          ),
          activePlaySessionProvider.overrideWith(
            (_) => Stream.value(null),
          ),
        ],
        child: const PlayTick(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Continue'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Launch'), findsNWidgets(2));
    expect(find.text('Hollow Knight'), findsOneWidget);
    expect(find.text('Outer Wilds'), findsOneWidget);
    expect(find.text('Celeste'), findsNothing);
    expect(find.byType(EmptyStateCard), findsNothing);
  });

  testWidgets('Home starts a session for the selected game', (tester) async {
    final now = DateTime(2026, 9, 11, 17);
    final database = AppDatabase(NativeDatabase.memory());
    final repository = DriftLibraryRepository(database, now: () => now);
    final container = ProviderContainer(
      overrides: [
        libraryRepositoryProvider.overrideWith((_) => repository),
        timerNowProvider.overrideWith((_) => Stream.value(now)),
      ],
    );
    addTearDown(() {
      container.dispose();
      unawaited(database.close());
    });

    await repository.addGame(
      Game(id: 42, name: 'Outer Wilds'),
      status: GameStatus.playing,
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const PlayTick(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.widgetWithText(OutlinedButton, 'Launch'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final activeSessions = await database
        .select(database.activePlaySessions)
        .get();
    expect(activeSessions, hasLength(1));
    expect(activeSessions.single.gameId, 42);
    expect(find.text('Active session'), findsOneWidget);
    expect(find.text('Continue'), findsNothing);
  });

  testWidgets(
    'Home shows the active game and elapsed time from the timer',
    (tester) async {
      final startedAt = DateTime(2026, 9, 10, 14);
      final now = DateTime(2026, 9, 10, 15, 2, 3);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            weeklyPlaytimeProvider.overrideWith(
              (_) => Stream.value(Duration.zero),
            ),
            activePlaySessionProvider.overrideWith(
              (_) => Stream.value(
                ActivePlaySession(
                  gameId: 2,
                  startedAt: startedAt,
                ),
              ),
            ),
            libraryGamesProvider.overrideWith(
              (_) => Stream.value(const [
                LibraryGame(
                  gameId: 1,
                  name: 'Hollow Knight',
                  status: GameStatus.playing,
                ),
                LibraryGame(
                  gameId: 2,
                  name: 'Celeste',
                  status: GameStatus.playing,
                ),
              ]),
            ),
            timerNowProvider.overrideWith(
              (_) => Stream.value(now),
            ),
          ],
          child: const PlayTick(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Active session'), findsOneWidget);
      expect(find.text('Celeste'), findsOneWidget);
      expect(find.text('Hollow Knight'), findsNothing);
      expect(find.text('01:02:03'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.byType(EmptyStateCard), findsNothing);
    },
  );

  testWidgets('saving the finished session records it and removes its card', (
    tester,
  ) async {
    final startedAt = DateTime(2026, 9, 10, 14);
    final database = AppDatabase(NativeDatabase.memory());
    final repository = DriftLibraryRepository(
      database,
      now: () => startedAt,
    );
    final container = ProviderContainer(
      overrides: [
        libraryRepositoryProvider.overrideWith((_) => repository),
        timerNowProvider.overrideWith(
          (_) => Stream.value(startedAt.add(const Duration(minutes: 5))),
        ),
      ],
    );
    addTearDown(() {
      container.dispose();
      unawaited(database.close());
    });

    await repository.addGame(
      Game(id: 1, name: 'Celeste'),
      status: GameStatus.playing,
    );
    await repository.startActivePlaySession(1);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const PlayTick(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Active session'), findsOneWidget);
    expect(find.text('00:05:00'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Stop'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Finished session'), findsOneWidget);
    expect(find.text('00:05:00'), findsOneWidget);
    expect(
      await database.select(database.activePlaySessions).get(),
      hasLength(1),
    );

    await tester.enterText(find.byType(TextFormField), '  Boss defeated  ');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Active session'), findsNothing);
    expect(
      await database.select(database.activePlaySessions).get(),
      isEmpty,
    );

    final sessions = await database.select(database.playSessions).get();
    expect(sessions, hasLength(1));
    expect(sessions.single.duration, const Duration(minutes: 5).inSeconds);
    expect(sessions.single.note, 'Boss defeated');
  });

  testWidgets('dismissing the finish sheet resumes the active timer', (
    tester,
  ) async {
    final startedAt = DateTime(2026, 9, 10, 14);
    var now = startedAt.add(const Duration(minutes: 5));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weeklyPlaytimeProvider.overrideWith(
            (_) => Stream.value(Duration.zero),
          ),
          activePlaySessionProvider.overrideWith(
            (_) => Stream.value(
              ActivePlaySession(gameId: 1, startedAt: startedAt),
            ),
          ),
          libraryGamesProvider.overrideWith(
            (_) => Stream.value(const [
              LibraryGame(
                gameId: 1,
                name: 'Celeste',
                status: GameStatus.playing,
              ),
            ]),
          ),
          timerNowProvider.overrideWith((_) async* {
            yield now;
          }),
        ],
        child: const PlayTick(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('00:05:00'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Stop'));
    await tester.pumpAndSettle();

    now = startedAt.add(const Duration(minutes: 10));
    Navigator.of(
      tester.element(find.byType(FinishActivePlaySessionSheet)),
    ).pop();
    await tester.pumpAndSettle();

    expect(find.byType(FinishActivePlaySessionSheet), findsNothing);
    expect(find.text('Active session'), findsOneWidget);
    expect(find.text('00:10:00'), findsOneWidget);
  });

  testWidgets('confirming cancellation discards the active session', (
    tester,
  ) async {
    final startedAt = DateTime(2026, 9, 10, 14);
    final database = AppDatabase(NativeDatabase.memory());
    final repository = DriftLibraryRepository(
      database,
      now: () => startedAt,
    );
    final container = ProviderContainer(
      overrides: [
        libraryRepositoryProvider.overrideWith((_) => repository),
        timerNowProvider.overrideWith(
          (_) => Stream.value(startedAt.add(const Duration(minutes: 5))),
        ),
      ],
    );
    addTearDown(() {
      container.dispose();
      unawaited(database.close());
    });

    await repository.addGame(
      Game(id: 1, name: 'Celeste'),
      status: GameStatus.playing,
    );
    await repository.startActivePlaySession(1);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const PlayTick(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.widgetWithText(FilledButton, 'Stop'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete session'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(FinishActivePlaySessionSheet), findsNothing);
    expect(find.text('Active session'), findsNothing);
    expect(
      await database.select(database.activePlaySessions).get(),
      isEmpty,
    );
    expect(
      await database.select(database.playSessions).get(),
      isEmpty,
    );
  });
}
