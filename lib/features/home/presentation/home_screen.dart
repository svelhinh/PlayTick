import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:playtick/app/router/app_router.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/core/presentation/widgets/icon_circle.dart';
import 'package:playtick/features/home/presentation/providers/active_play_session_provider.dart';
import 'package:playtick/features/home/presentation/providers/timer_now_provider.dart';
import 'package:playtick/features/home/presentation/providers/weekly_playtime_provider.dart';
import 'package:playtick/features/home/presentation/widgets/finish_active_play_session_sheet.dart';
import 'package:playtick/features/home/presentation/widgets/home_games_list.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/presentation/extensions/library_exception_extension.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
import 'package:playtick/features/library/presentation/providers/library_games_provider.dart';
import 'package:playtick/features/library/presentation/widgets/game_cover_image.dart';
import 'package:playtick/features/library/providers/library_repository_provider.dart';
import 'package:playtick/l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Duration? _pendingFinishDuration;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final playtime = ref.watch(weeklyPlaytimeProvider);
    final activeSession = ref.watch(activePlaySessionProvider).value;

    final gamesAsync = ref.watch(libraryGamesProvider);

    var now = DateTime.now();

    if (activeSession != null && _pendingFinishDuration == null) {
      now = ref.watch(timerNowProvider).value ?? now;
    }

    final loadedGames = gamesAsync.value ?? [];
    final playingGames = loadedGames
        .where((game) => game.status == GameStatus.playing)
        .toList();

    final activeGame = loadedGames
        .where((game) => game.gameId == activeSession?.gameId)
        .firstOrNull;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(appLoc.appName, style: theme.textTheme.headlineLarge),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (activeSession != null && activeGame != null) ...[
                      _ActivePlaySessionCard(
                        coverUrl: activeGame.coverUrl,
                        gameTitle: activeGame.name,
                        playtime:
                            _pendingFinishDuration ??
                            now.difference(activeSession.startedAt),
                        onStop: () async {
                          final pendingDuration = now.difference(
                            activeSession.startedAt,
                          );

                          setState(() {
                            _pendingFinishDuration = pendingDuration;
                          });

                          try {
                            await showModalBottomSheet<void>(
                              context: context,
                              isScrollControlled: true,
                              showDragHandle: true,
                              useSafeArea: true,
                              backgroundColor: theme.colorScheme.surface,
                              builder: (context) =>
                                  FinishActivePlaySessionSheet(
                                    onSave: (duration, note) => ref
                                        .read(libraryRepositoryProvider)
                                        .finishActivePlaySession(
                                          duration,
                                          note: note,
                                        ),
                                    onDelete: () => ref
                                        .read(libraryRepositoryProvider)
                                        .clearActivePlaySession(),
                                    coverUrl: activeGame.coverUrl,
                                    gameTitle: activeGame.name,
                                    startedAt: activeSession.startedAt,
                                    initialDuration: pendingDuration,
                                  ),
                            );
                          } finally {
                            if (mounted) {
                              setState(() {
                                _pendingFinishDuration = null;
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            title: appLoc.homeWeeklyPlaytime,
                            info: (playtime.value ?? Duration.zero).localize(
                              appLoc,
                              withMinutes: false,
                            ),
                            icon: Icons.access_time_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _InfoCard(
                            title: appLoc.homeTotalGames,
                            info: playingGames.length.toString(),
                            icon: Icons.sports_esports_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    gamesAsync.when(
                      data: (games) {
                        if (playingGames.isEmpty) {
                          return EmptyStateCard(
                            icon: Icons.sports_esports_outlined,
                            title: appLoc.homeEmptyCardTitle,
                            description: appLoc.homeEmptyCardDescription,
                            action: FilledButton(
                              onPressed: () => context.go(AppRoutes.library),
                              child: Text(appLoc.homeEmptyCardButtonText),
                            ),
                          );
                        }

                        if (activeSession != null) {
                          return const SizedBox.shrink();
                        }

                        return GamesList(
                          games: playingGames,
                          onGamePressed: (game) async {
                            try {
                              await ref
                                  .read(libraryRepositoryProvider)
                                  .startActivePlaySession(game.gameId);
                            } on Exception catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e.localizeLibraryError(appLoc),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        );
                      },
                      error: (error, stackTrace) => EmptyStateCard(
                        icon: Icons.sports_esports_outlined,
                        title: appLoc.homeEmptyCardTitle,
                        description: appLoc.homeEmptyCardDescription,
                        action: FilledButton(
                          onPressed: () => context.go(AppRoutes.library),
                          child: Text(appLoc.homeEmptyCardButtonText),
                        ),
                      ),
                      loading: () => const Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.info,
    required this.icon,
  });

  final String title;
  final String info;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  info,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                IconCircle(
                  icon: icon,
                  backgroundColor: theme.colorScheme.secondary.withValues(
                    alpha: 0.1,
                  ),
                  iconSize: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final class _ActivePlaySessionCard extends StatelessWidget {
  const _ActivePlaySessionCard({
    required this.coverUrl,
    required this.gameTitle,
    required this.playtime,
    required this.onStop,
  });

  final String? coverUrl;
  final String gameTitle;
  final Duration playtime;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLoc.homeActivePlaySession,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            IntrinsicHeight(
              child: Row(
                children: [
                  GameCoverImage(coverUrl: coverUrl),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(gameTitle, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          IconCircle(
                            icon: Icons.access_time_outlined,
                            iconSize: 16,
                            radius: 14,
                            backgroundColor: theme.colorScheme.secondary
                                .withValues(alpha: 0.1),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            playtime.formatTimer(),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 40,
                        child: FilledButton(
                          onPressed: onStop,
                          child: Text(appLoc.homeActivePlaySessionStopButton),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
