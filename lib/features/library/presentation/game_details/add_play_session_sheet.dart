import 'package:flutter/material.dart';
import 'package:playtick/app/app_theme.dart';
import 'package:playtick/features/library/presentation/extensions/library_exception_extension.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
import 'package:playtick/features/library/presentation/game_details/duration_picker_dialog.dart';
import 'package:playtick/features/library/presentation/game_details/hold_step_button.dart';
import 'package:playtick/l10n/app_localizations.dart';

final class AddPlaySessionSheet extends StatefulWidget {
  const AddPlaySessionSheet({
    required this.onSave,
    super.key,
  });

  final Future<void> Function(DateTime date, Duration duration, String? note)
  onSave;

  @override
  State<AddPlaySessionSheet> createState() => _AddPlaySessionSheetState();
}

class _AddPlaySessionSheetState extends State<AddPlaySessionSheet> {
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
