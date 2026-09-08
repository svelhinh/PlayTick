import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:playtick/app/app_theme.dart';
import 'package:playtick/app/router/app_router.dart';
import 'package:playtick/features/library/domain/estimated_playtimes.dart';
import 'package:playtick/features/library/domain/game.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/domain/play_session.dart';
import 'package:playtick/features/library/presentation/extensions/game_subtitle_extension.dart';
import 'package:playtick/features/library/presentation/extensions/library_exception_extension.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
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
                  await showModalBottomSheet<_DeleteGameSheet>(
                    context: context,
                    showDragHandle: true,
                    useSafeArea: true,
                    isScrollControlled: true,
                    backgroundColor: theme.colorScheme.surface,
                    builder: (context) => _DeleteGameSheet(
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
                  _PlaySessionsCard(
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
              Text(values.join(separator), style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

final class _PlaySessionsCard extends ConsumerWidget {
  const _PlaySessionsCard({
    required this.playSessions,
    required this.gameId,
  });

  final List<PlaySession> playSessions;
  final int gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline, width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appLoc.gameDetailsPlaySessionsTitle,
                style: theme.textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () async {
                  await showModalBottomSheet<_AddPlaySessionSheet>(
                    context: context,
                    showDragHandle: true,
                    useSafeArea: true,
                    isScrollControlled: true,
                    backgroundColor: theme.colorScheme.surface,
                    builder: (context) => _AddPlaySessionSheet(
                      onSave: (date, duration, note) async {
                        await ref
                            .read(libraryRepositoryProvider)
                            .addPlaySession(
                              gameId,
                              date,
                              duration,
                              note: note ?? '',
                            );
                      },
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      appLoc.gameDetailsPlaySessionsAddButton,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.add,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (playSessions.isNotEmpty) ...[
            const SizedBox(height: 16),
            for (final session in playSessions)
              _PlaySessionItem(session: session),
          ],
        ],
      ),
    );
  }
}

final class _PlaySessionItem extends StatelessWidget {
  const _PlaySessionItem({
    required this.session,
  });

  final PlaySession session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border.all(
            color: theme.colorScheme.outline,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: theme.colorScheme.onSurface,
                ),
                const SizedBox(width: 16),
                Text(
                  MaterialLocalizations.of(context)
                      .formatShortDate(session.date),
                  style: theme.textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  session.duration.localize(appLoc),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.edit,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
            if (session.note != null && session.note!.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Text(
                  session.note!,
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final class _AddPlaySessionSheet extends StatefulWidget {
  const _AddPlaySessionSheet({
    required this.onSave,
  });

  final Future<void> Function(DateTime date, Duration duration, String? note)
  onSave;

  @override
  State<_AddPlaySessionSheet> createState() => _AddPlaySessionSheetState();
}

class _AddPlaySessionSheetState extends State<_AddPlaySessionSheet> {
  DateTime _date = DateTime.now();
  Duration _duration = const Duration(minutes: 15);
  final TextEditingController _noteController = TextEditingController();

  void _decreaseDuration() {
    setState(() {
      final next = _duration - const Duration(minutes: 15);
      _duration = next < const Duration(minutes: 15)
          ? const Duration(minutes: 15)
          : next;
    });
  }

  void _increaseDuration() {
    setState(() => _duration += const Duration(minutes: 15));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLoc.gameDetailsPlaySessionsAddTitle,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(1970),
                  lastDate: DateTime.now(),
                );

                if (pickedDate != null && mounted) {
                  setState(() => _date = pickedDate);
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: appLoc.date,
                  fillColor: theme.colorScheme.surface,
                  contentPadding: const EdgeInsets.all(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: theme.colorScheme.onSurface,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      MaterialLocalizations.of(context).formatShortDate(_date),
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            InputDecorator(
              decoration: InputDecoration(
                labelText: appLoc.gameDetailsPlaySessionsAddDurationLabel,
                fillColor: theme.colorScheme.surface,
                contentPadding: const EdgeInsets.all(8),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDialog<Duration>(
                        context: context,
                        builder: (context) =>
                            DurationPickerDialog(duration: _duration),
                      );

                      if (picked != null && mounted) {
                        setState(() => _duration = picked);
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          size: 20,
                          color: theme.colorScheme.onSurface,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          _duration.localize(appLoc),
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 40,
                    child: Row(
                      children: [
                        _HoldStepButton(
                          icon: Icons.remove,
                          onStep: _decreaseDuration,
                        ),
                        _HoldStepButton(
                          icon: Icons.add,
                          onStep: _increaseDuration,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                labelText: appLoc.gameDetailsPlaySessionsAddNotesLabel,
                fillColor: theme.colorScheme.surface,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: const EdgeInsets.all(8),
                hintText: appLoc.gameDetailsPlaySessionsAddHintText,
                hintStyle: theme.textTheme.bodyMedium!.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              minLines: 4,
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  try {
                    await widget.onSave(
                      _date,
                      _duration,
                      _noteController.text.trim(),
                    );

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } on Exception catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.localizeLibraryError(appLoc)),
                          backgroundColor: AppTheme.danger,
                        ),
                      );
                    }
                  }
                },
                child: Text(appLoc.gameDetailsPlaySessionsAddSaveButton),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(appLoc.cancel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}

final class _HoldStepButton extends StatefulWidget {
  const _HoldStepButton({
    required this.icon,
    required this.onStep,
  });

  final IconData icon;
  final VoidCallback onStep;

  @override
  State<_HoldStepButton> createState() => _HoldStepButtonState();
}

class _HoldStepButtonState extends State<_HoldStepButton> {
  static const _holdDelay = Duration(milliseconds: 400);
  static const _repeatInterval = Duration(milliseconds: 80);

  Timer? _delay;
  Timer? _repeat;

  void _startHold() {
    widget.onStep();
    _delay = Timer(_holdDelay, () {
      _repeat = Timer.periodic(_repeatInterval, (_) {
        if (!mounted) {
          return;
        }
        widget.onStep();
      });
    });
  }

  void _stopHold() {
    _delay?.cancel();
    _repeat?.cancel();
    _delay = null;
    _repeat = null;
  }

  @override
  void dispose() {
    _stopHold();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => _startHold(),
      onPointerUp: (_) => _stopHold(),
      onPointerCancel: (_) => _stopHold(),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(
          widget.icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class DurationPickerDialog extends StatefulWidget {
  const DurationPickerDialog({required this.duration, super.key});

  final Duration duration;

  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  int _hours = 0;
  int _minutes = 0;

  void _decreaseHours() {
    setState(() {
      final next = _hours - 1;
      _hours = next < 0 ? 0 : next;
    });
  }

  void _increaseHours() {
    setState(() => _hours = _hours + 1);
  }

  void _decreaseMinutes() {
    setState(() {
      final next = _minutes - 1;
      _minutes = next < 0 ? 59 : next;
    });
  }

  void _increaseMinutes() {
    setState(() {
      final next = _minutes + 1;
      if (next > 59) {
        _increaseHours();
        _minutes = 0;
      } else {
        _minutes = next;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _hours = widget.duration.inHours;
    _minutes = widget.duration.inMinutes.remainder(60);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        appLoc.gameDetailsPlaySessionsAddDurationLabel,
        style: theme.textTheme.titleLarge,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, widget.duration),
          child: Text(appLoc.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            Duration(hours: _hours, minutes: _minutes),
          ),
          child: Text(appLoc.validate),
        ),
      ],
      titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      backgroundColor: theme.colorScheme.surface,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surfaceContainerHigh,
                  border: Border.all(
                    color: theme.colorScheme.outline,
                  ),
                ),
                child: Column(
                  children: [
                    _HoldStepButton(
                      icon: Icons.add,
                      onStep: _increaseHours,
                    ),
                    Container(
                      width: double.infinity,
                      color: theme.colorScheme.surface,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        _hours.toString(),
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    _HoldStepButton(
                      icon: Icons.remove,
                      onStep: _decreaseHours,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                appLoc.hours,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(width: 40),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surfaceContainerHigh,
                  border: Border.all(
                    color: theme.colorScheme.outline,
                  ),
                ),
                child: Column(
                  children: [
                    _HoldStepButton(
                      icon: Icons.add,
                      onStep: _increaseMinutes,
                    ),
                    Container(
                      width: double.infinity,
                      color: theme.colorScheme.surface,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        _minutes.toString(),
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _HoldStepButton(
                      icon: Icons.remove,
                      onStep: _decreaseMinutes,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                appLoc.minutes,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
