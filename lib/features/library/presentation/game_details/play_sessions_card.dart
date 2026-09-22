import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playtick/core/presentation/widgets/playtick_sheet.dart';
import 'package:playtick/features/library/domain/play_session.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
import 'package:playtick/features/library/presentation/game_details/play_session_sheet.dart';
import 'package:playtick/features/library/providers/library_repository_provider.dart';
import 'package:playtick/l10n/app_localizations.dart';

final class PlaySessionsCard extends ConsumerWidget {
  const PlaySessionsCard({
    required this.playSessions,
    required this.gameId,
    super.key,
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
                  await showPlaytickSheet<PlaySessionSheet>(
                    context: context,
                    backgroundColor: theme.colorScheme.surface,
                    builder: (context) => PlaySessionSheet(
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

final class _PlaySessionItem extends ConsumerWidget {
  const _PlaySessionItem({
    required this.session,
  });

  final PlaySession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                IconButton(
                  onPressed: () async {
                    await showPlaytickSheet<PlaySessionSheet>(
                      context: context,
                      backgroundColor: theme.colorScheme.surface,
                      builder: (context) => PlaySessionSheet(
                        session: session,
                        onDelete: () async {
                          await ref
                              .read(libraryRepositoryProvider)
                              .removePlaySession(session.id);
                        },
                        onSave: (date, duration, note) async {
                          await ref
                              .read(libraryRepositoryProvider)
                              .updatePlaySession(
                                session.id,
                                date,
                                duration,
                                note: note ?? '',
                              );
                        },
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            if (session.note != null && session.note!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
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
