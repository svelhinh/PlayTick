import 'package:flutter/material.dart';
import 'package:playtick/app/app_theme.dart';
import 'package:playtick/core/presentation/widgets/icon_circle.dart';
import 'package:playtick/features/library/presentation/extensions/library_exception_extension.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
import 'package:playtick/features/library/presentation/widgets/duration_picker_dialog.dart';
import 'package:playtick/features/library/presentation/widgets/game_cover_image.dart';
import 'package:playtick/features/library/presentation/widgets/session_note_text_field.dart';
import 'package:playtick/l10n/app_localizations.dart';

final class FinishActivePlaySessionSheet extends StatefulWidget {
  const FinishActivePlaySessionSheet({
    required this.onSave,
    required this.coverUrl,
    required this.gameTitle,
    required this.startedAt,
    required this.initialDuration,
    super.key,
  });

  final Future<void> Function(Duration duration, String? note) onSave;

  final String? coverUrl;
  final String gameTitle;
  final DateTime startedAt;
  final Duration initialDuration;

  @override
  State<FinishActivePlaySessionSheet> createState() =>
      _FinishActivePlaySessionSheetState();
}

class _FinishActivePlaySessionSheetState
    extends State<FinishActivePlaySessionSheet> {
  late Duration _duration;

  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _duration = widget.initialDuration < const Duration(minutes: 1)
        ? const Duration(minutes: 1)
        : widget.initialDuration;
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
              appLoc.homeFinishActivePlaySession,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                GameCoverImage(coverUrl: widget.coverUrl),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.gameTitle, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      MaterialLocalizations.of(context)
                          .formatShortDate(widget.startedAt),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline,
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  IconCircle(
                    icon: Icons.access_time_outlined,
                    backgroundColor: theme.colorScheme.surfaceContainerHigh,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLoc.homeFinishActivePlaySessionDurationLabel,
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        _duration.localize(appLoc),
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDialog<Duration>(
                        context: context,
                        builder: (context) =>
                            DurationPickerDialog(duration: _duration),
                      );

                      if (picked != null && mounted) {
                        setState(() => _duration = picked);
                      }
                    },
                    child: Text(
                      appLoc.homeFinishActivePlaySessionEditDurationButton,
                      style: theme.textTheme.titleSmall!.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SessionNoteTextField(controller: _noteController),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  try {
                    await widget.onSave(
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
                child: Text(appLoc.save),
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
