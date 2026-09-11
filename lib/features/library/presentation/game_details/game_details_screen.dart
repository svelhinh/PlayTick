import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:playtick/app/router/app_router.dart';
import 'package:playtick/core/presentation/widgets/icon_circle.dart';
import 'package:playtick/features/library/domain/estimated_playtimes.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/presentation/extensions/game_subtitle_extension.dart';
import 'package:playtick/features/library/presentation/extensions/library_exception_extension.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
import 'package:playtick/features/library/presentation/game_details/delete_game_sheet.dart';
import 'package:playtick/features/library/presentation/game_details/play_sessions_card.dart';
import 'package:playtick/features/library/presentation/providers/library_game_provider.dart';
import 'package:playtick/features/library/presentation/widgets/game_cover_image.dart';
import 'package:playtick/features/library/presentation/widgets/game_status_row.dart';
import 'package:playtick/features/library/providers/library_repository_provider.dart';
import 'package:playtick/l10n/app_localizations.dart';

class GameDetailsScreen extends ConsumerWidget {
  const GameDetailsScreen({required this.gameId, super.key});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLoc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final gameIdInt = int.tryParse(gameId);

    if (gameIdInt == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const _GameDetailsError(),
      );
    }

    final gameAsync = ref.watch(libraryGameProvider(gameIdInt));

    return Scaffold(
      appBar: AppBar(
        actions: [
          gameAsync.when(
            data: (details) {
              if (details == null) {
                return const SizedBox.shrink();
              }

              return IconButton(
                onPressed: () async {
                  await showModalBottomSheet<DeleteGameSheet>(
                    context: context,
                    showDragHandle: true,
                    useSafeArea: true,
                    isScrollControlled: true,
                    backgroundColor: theme.colorScheme.surface,
                    builder: (context) => DeleteGameSheet(
                      name: details.game.name,
                      onDelete: () async {
                        try {
                          await ref
                              .read(libraryRepositoryProvider)
                              .removeGame(gameIdInt);

                          if (context.mounted) {
                            Navigator.pop(context);

                            context.go(AppRoutes.library);
                          }
                        } on Exception catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.localizeLibraryError(appLoc)),
                                backgroundColor: theme.colorScheme.error,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete,
                  color: theme.colorScheme.error,
                ),
              );
            },
            error: (error, stackTrace) => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: gameAsync.when(
        data: (details) {
          if (details == null) {
            return const _GameDetailsError();
          }

          final game = details.game;
          final status = details.status;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  _TopInfo(
                    game: game,
                    status: status,
                    totalPlaytime: details.totalPlaytime,
                    onStatusChanged: (status) async {
                      try {
                        await ref
                            .read(libraryRepositoryProvider)
                            .updateGameStatus(game.id, status);
                      } on Exception catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.localizeLibraryError(appLoc)),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _GameInfoCard(
                    summary: game.summary,
                    genres: game.genres,
                    developer: game.developer,
                    publisher: game.publisher,
                    platforms: game.platforms,
                    estimatedPlaytimes: game.estimatedPlaytimes,
                  ),
                  const SizedBox(height: 16),
                  PlaySessionsCard(
                    playSessions: details.playSessions,
                    gameId: game.id,
                  ),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => const _GameDetailsError(),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

final class _GameDetailsError extends StatelessWidget {
  const _GameDetailsError();

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    return Center(child: Text(appLoc.somethingWentWrong));
  }
}

final class _TopInfo extends StatelessWidget {
  const _TopInfo({
    required this.game,
    required this.status,
    required this.totalPlaytime,
    required this.onStatusChanged,
  });

  final Game game;
  final GameStatus status;
  final Duration totalPlaytime;
  final Future<void> Function(GameStatus) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return Row(
      children: [
        GameCoverImage(coverUrl: game.coverUrl, width: 100, height: 120),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                game.name,
                style: theme.textTheme.titleLarge,
              ),
              if (game.subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  game.subtitle!,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 8),
              PopupMenuButton<GameStatus>(
                initialValue: status,
                onSelected: onStatusChanged,
                itemBuilder: (context) => GameStatus.values
                    .map(
                      (status) => PopupMenuItem<GameStatus>(
                        value: status,
                        child: GameStatusRow(status: status),
                      ),
                    )
                    .toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GameStatusRow(status: status),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: theme.colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ),
              if (totalPlaytime.inSeconds > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule_outlined, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      totalPlaytime.localize(
                        appLoc,
                      ),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

final class _GameInfoCard extends StatelessWidget {
  const _GameInfoCard({
    required this.summary,
    required this.genres,
    required this.developer,
    required this.publisher,
    required this.platforms,
    required this.estimatedPlaytimes,
  });

  final String? summary;
  final List<String> genres;
  final String? developer;
  final String? publisher;
  final List<String> platforms;
  final EstimatedPlaytimes? estimatedPlaytimes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    final infoItems = <Widget>[
      if (genres.isNotEmpty)
        _InfoItem(
          icon: Icons.category,
          label: appLoc.gameDetailsGenresTitle,
          values: genres,
        ),
      if (developer != null && developer!.isNotEmpty)
        _InfoItem(
          icon: Icons.developer_board,
          label: appLoc.gameDetailsDeveloperTitle,
          values: [developer!],
        ),
      if (publisher != null && publisher!.isNotEmpty)
        _InfoItem(
          icon: Icons.business,
          label: appLoc.gameDetailsPublisherTitle,
          values: [publisher!],
        ),
      if (platforms.isNotEmpty)
        _InfoItem(
          icon: Icons.gamepad,
          label: appLoc.gameDetailsPlatformsTitle,
          values: platforms,
        ),
      if (estimatedPlaytimes != null && estimatedPlaytimes!.hasValues)
        _InfoItem(
          icon: Icons.schedule,
          label: appLoc.gameDetailsEstimatedPlaytimesTitle,
          separator: '\n',
          values: [
            if (estimatedPlaytimes!.story != null)
              appLoc.gameDetailsEstimatedPlaytimesStory(
                estimatedPlaytimes!.story!.localize(appLoc),
              ),
            if (estimatedPlaytimes!.main != null)
              appLoc.gameDetailsEstimatedPlaytimesMain(
                estimatedPlaytimes!.main!.localize(appLoc),
              ),
            if (estimatedPlaytimes!.completion != null)
              appLoc.gameDetailsEstimatedPlaytimesCompletion(
                estimatedPlaytimes!.completion!.localize(appLoc),
              ),
          ],
        ),
    ];

    if (infoItems.isEmpty && (summary == null || summary!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLoc.gameDetailsAboutGameTitle,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (summary != null && summary!.isNotEmpty) ...[
            Text(summary!, style: theme.textTheme.bodySmall),
          ],
          if (infoItems.isNotEmpty) ...[
            const SizedBox(height: 16),
            for (var i = 0; i < infoItems.length; i++) ...[
              if (i > 0)
                Divider(
                  color: theme.colorScheme.outline,
                  thickness: 0.5,
                  indent: 40,
                  height: 24,
                ),
              infoItems[i],
            ],
          ],
        ],
      ),
    );
  }
}

final class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.values,
    this.separator = ', ',
  });

  final IconData icon;
  final String label;
  final List<String> values;
  final String separator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconCircle(
          icon: icon,
          radius: 16,
          iconSize: 16,
          backgroundColor: theme.colorScheme.surfaceContainerLow,
          iconColor: theme.colorScheme.onSurface,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(values.join(separator), style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
