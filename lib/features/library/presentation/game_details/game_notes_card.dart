import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playtick/core/presentation/widgets/playtick_sheet.dart';
import 'package:playtick/features/library/domain/game_note.dart';
import 'package:playtick/features/library/presentation/game_details/game_note_sheet.dart';
import 'package:playtick/features/library/providers/library_repository_provider.dart';
import 'package:playtick/l10n/app_localizations.dart';

final class GameNotesCard extends ConsumerWidget {
  const GameNotesCard({
    required this.notes,
    required this.gameId,
    super.key,
  });

  final List<GameNote> notes;
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
                appLoc.gameDetailsNotesTitle,
                style: theme.textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () async {
                  await showPlaytickSheet<GameNoteSheet>(
                    context: context,
                    backgroundColor: theme.colorScheme.surface,
                    builder: (context) => GameNoteSheet(
                      onSave: (content) async {
                        await ref
                            .read(libraryRepositoryProvider)
                            .addGameNote(gameId, content);
                      },
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      appLoc.gameDetailsNotesAddButton,
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
          if (notes.isNotEmpty)
            for (final note in notes) _GameNoteItem(note: note),
        ],
      ),
    );
  }
}

final class _GameNoteItem extends ConsumerWidget {
  const _GameNoteItem({
    required this.note,
  });

  final GameNote note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withAlpha(10),
          border: Border.all(
            color: theme.colorScheme.outline,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    note.content,
                    style: theme.textTheme.labelMedium,
                  ),
                ),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    onPressed: () async {
                      await showPlaytickSheet<GameNoteSheet>(
                        context: context,
                        backgroundColor: theme.colorScheme.surface,
                        builder: (context) => GameNoteSheet(
                          note: note,
                          onDelete: () async {
                            await ref
                                .read(libraryRepositoryProvider)
                                .removeGameNote(note.id);
                          },
                          onSave: (content) async {
                            await ref
                                .read(libraryRepositoryProvider)
                                .updateGameNote(
                                  note.id,
                                  content,
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
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              MaterialLocalizations.of(context).formatShortDate(note.createdAt),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
