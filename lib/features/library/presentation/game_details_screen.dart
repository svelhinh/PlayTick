import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:playtick/app/app_theme.dart';
import 'package:playtick/app/router/app_router.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
import 'package:playtick/features/library/presentation/providers/library_game_provider.dart';
import 'package:playtick/features/library/presentation/providers/library_repository_provider.dart';
import 'package:playtick/features/library/presentation/widgets/game_status_row.dart';
import 'package:playtick/l10n/app_localizations.dart';

class GameDetailsScreen extends ConsumerWidget {
  const GameDetailsScreen({required this.gameId, super.key});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              return IconButton(
                onPressed: () async {
                  await showModalBottomSheet<_DeleteGameSheet>(
                    context: context,
                    showDragHandle: true,
                    useSafeArea: true,
                    isScrollControlled: true,
                    builder: (context) => _DeleteGameSheet(
                      name: details?.game.name ?? '',
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
                                content: Text(e.toString()),
                                backgroundColor: AppTheme.danger,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.delete, color: AppTheme.danger),
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
                    name: game.name,
                    developer: game.developer ?? '',
                    releaseYear: game.releaseDate?.year,
                    coverUrl: game.coverUrl,
                    status: status,
                    totalPlaytime: details.totalPlaytime,
                    onStatusChanged: (status) => ref
                        .read(libraryRepositoryProvider)
                        .updateGameStatus(
                          game.id,
                          status,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _GameInfoCard(
                    summary: game.summary ?? '',
                    genres: game.genres,
                    developer: game.developer ?? '',
                    publisher: game.publisher ?? '',
                    platforms: game.platforms,
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

    return Center(child: Text(appLoc.gameDetailsSomethingWentWrong));
  }
}

final class _TopInfo extends StatelessWidget {
  const _TopInfo({
    required this.name,
    required this.developer,
    required this.releaseYear,
    required this.coverUrl,
    required this.status,
    required this.totalPlaytime,
    required this.onStatusChanged,
  });

  final String name;
  final String developer;
  final int? releaseYear;
  final String? coverUrl;
  final GameStatus status;
  final Duration totalPlaytime;
  final Future<void> Function(GameStatus) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return Row(
      children: [
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: coverUrl != null
                ? Image.network(
                    coverUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.gamepad),
                  )
                : const Icon(Icons.gamepad),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.titleLarge,
              ),
              if (releaseYear != null) ...[
                const SizedBox(height: 8),
                Text(
                  '$developer • $releaseYear',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
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
              if (status != GameStatus.wantToPlay &&
                  totalPlaytime.inSeconds > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.schedule_outlined, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      totalPlaytime.localizePlaytime(
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

final class _DeleteGameSheet extends StatelessWidget {
  const _DeleteGameSheet({
    required this.name,
    required this.onDelete,
  });

  final String name;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.danger.withValues(alpha: 0.1),
                    radius: 24,
                    child: const Icon(
                      Icons.delete_outline,
                      color: AppTheme.danger,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLoc.gameDetailsDeleteGameTitle,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          appLoc.gameDetailsDeleteGameDescription(name),
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.warning_outlined,
                              size: 16,
                              color: AppTheme.danger,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                appLoc.gameDetailsDeleteWarning,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.danger,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.danger,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: onDelete,
                  child: Text(appLoc.gameDetailsDeleteButton),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  appLoc.cancel,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: AppTheme.danger,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
  });

  final String summary;
  final List<String> genres;
  final String developer;
  final String publisher;
  final List<String> platforms;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
          Text(summary, style: theme.textTheme.bodySmall),
          const SizedBox(height: 16),
          _InfoItem(
            icon: Icons.category,
            label: appLoc.gameDetailsGenresTitle,
            values: genres,
          ),
          Divider(
            color: theme.colorScheme.outline,
            thickness: 0.5,
            indent: 40,
            height: 24,
          ),
          _InfoItem(
            icon: Icons.developer_board,
            label: appLoc.gameDetailsDeveloperTitle,
            values: [developer],
          ),
          Divider(
            color: theme.colorScheme.outline,
            thickness: 0.5,
            indent: 40,
            height: 24,
          ),
          _InfoItem(
            icon: Icons.business,
            label: appLoc.gameDetailsPublisherTitle,
            values: [publisher],
          ),
          Divider(
            color: theme.colorScheme.outline,
            thickness: 0.5,
            indent: 40,
            height: 24,
          ),
          _InfoItem(
            icon: Icons.gamepad,
            label: appLoc.gameDetailsPlatformsTitle,
            values: [...platforms],
          ),
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
  });

  final IconData icon;
  final String label;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: theme.colorScheme.surfaceContainerLow,
          child: Icon(icon, size: 16, color: theme.colorScheme.onSurface),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(values.join(', '), style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
