import 'package:flutter/material.dart';
import 'package:playtick/core/presentation/widgets/delete_dialog.dart';
import 'package:playtick/features/library/domain/game_note.dart';
import 'package:playtick/features/library/presentation/extensions/library_exception_extension.dart';
import 'package:playtick/features/library/presentation/widgets/session_note_text_field.dart';
import 'package:playtick/l10n/app_localizations.dart';

final class GameNoteSheet extends StatefulWidget {
  const GameNoteSheet({
    required this.onSave,
    this.onDelete,
    this.note,
    super.key,
  });

  final Future<void> Function(String content) onSave;
  final Future<void> Function()? onDelete;

  final GameNote? note;

  @override
  State<GameNoteSheet> createState() => _GameNoteSheetState();
}

class _GameNoteSheetState extends State<GameNoteSheet> {
  DateTime _date = DateTime.now();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _date = widget.note!.createdAt;
      _noteController.text = widget.note!.content;
    }
  }

  Future<void> _onDeletePressed() async {
    final appLoc = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: appLoc.gameDetailsNotesDeleteTitle,
        description: appLoc.gameDetailsNotesDeleteDescription,
        deleteButtonText: appLoc.gameDetailsNotesDeleteButton,
      ),
    );

    if (confirmed != true || !mounted) {
      return;
    }

    try {
      await widget.onDelete!();

      if (mounted) {
        Navigator.pop(context);
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.localizeLibraryError(appLoc)),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    final isEditing = widget.note != null;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isEditing
                          ? appLoc.gameDetailsNotesEditTitle
                          : appLoc.gameDetailsNotesAddTitle,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${MaterialLocalizations.of(context).formatShortDate(_date)})',
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
                if (widget.onDelete != null)
                  IconButton(
                    onPressed: _onDeletePressed,
                    tooltip: appLoc.gameDetailsNotesDeleteButton,
                    icon: Icon(
                      Icons.delete,
                      color: theme.colorScheme.error,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            NoteTextField(
              controller: _noteController,
              label: appLoc.gameDetailsNotesNoteLabel,
              hintText: appLoc.gameDetailsNotesNoteHintText,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _noteController,
                builder: (context, value, child) => FilledButton(
                  onPressed: value.text.trim().isEmpty
                      ? null
                      : () async {
                          try {
                            await widget.onSave(_noteController.text.trim());

                            if (context.mounted) {
                              Navigator.pop(context);
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
                  child: Text(
                    isEditing
                        ? appLoc.gameDetailsNotesEditSaveButton
                        : appLoc.gameDetailsNotesAddSaveButton,
                  ),
                ),
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
