import 'package:flutter/material.dart';
import 'package:playtick/core/presentation/widgets/delete_dialog.dart';
import 'package:playtick/features/library/domain/play_session.dart';
import 'package:playtick/features/library/presentation/extensions/library_exception_extension.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
import 'package:playtick/features/library/presentation/widgets/duration_picker_dialog.dart';
import 'package:playtick/features/library/presentation/widgets/hold_step_button.dart';
import 'package:playtick/features/library/presentation/widgets/session_duration_step.dart';
import 'package:playtick/features/library/presentation/widgets/session_note_text_field.dart';
import 'package:playtick/l10n/app_localizations.dart';

final class PlaySessionSheet extends StatefulWidget {
  const PlaySessionSheet({
    required this.onSave,
    this.onDelete,
    this.session,
    super.key,
  });

  final Future<void> Function(DateTime date, Duration duration, String? note)
  onSave;
  final Future<void> Function()? onDelete;

  final PlaySession? session;

  @override
  State<PlaySessionSheet> createState() => _PlaySessionSheetState();
}

class _PlaySessionSheetState extends State<PlaySessionSheet> {
  DateTime _date = DateTime.now();
  Duration _duration = const Duration(minutes: 15);
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.session != null) {
      _date = widget.session!.date;
      _duration = widget.session!.duration;
      _noteController.text = widget.session!.note ?? '';
    }
  }

  void _decreaseDuration() {
    setState(() => _duration = previousQuarterHour(_duration));
  }

  void _increaseDuration() {
    setState(() => _duration = nextQuarterHour(_duration));
  }

  Future<void> _onDeletePressed() async {
    final appLoc = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: appLoc.gameDetailsPlaySessionsDeleteTitle,
        description: appLoc.gameDetailsPlaySessionsDeleteDescription,
        deleteButtonText: appLoc.gameDetailsPlaySessionsDeleteButton,
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
        context.showLibraryErrorSnackBar(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    final isEditing = widget.session != null;

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
                Text(
                  isEditing
                      ? appLoc.gameDetailsPlaySessionsEditTitle
                      : appLoc.gameDetailsPlaySessionsAddTitle,
                  style: theme.textTheme.titleLarge,
                ),
                if (widget.onDelete != null)
                  IconButton(
                    onPressed: _onDeletePressed,
                    tooltip: appLoc.gameDetailsPlaySessionsDeleteButton,
                    icon: Icon(
                      Icons.delete,
                      color: theme.colorScheme.error,
                    ),
                  ),
              ],
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
                labelText: appLoc.gameDetailsPlaySessionsDurationLabel,
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
                        HoldStepButton(
                          icon: Icons.remove,
                          onStep: _decreaseDuration,
                        ),
                        HoldStepButton(
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
            NoteTextField(
              controller: _noteController,
              label: appLoc.gameDetailsPlaySessionsNoteLabel,
              hintText: appLoc.gameDetailsPlaySessionsHintText,
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
                      context.showLibraryErrorSnackBar(e);
                    }
                  }
                },
                child: Text(
                  isEditing
                      ? appLoc.gameDetailsPlaySessionsEditSaveButton
                      : appLoc.gameDetailsPlaySessionsAddSaveButton,
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
