import 'package:flutter/material.dart';
import 'package:playtick/l10n/app_localizations.dart';

class SessionNoteTextField extends StatelessWidget {
  const SessionNoteTextField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return TextFormField(
      controller: controller,
      style: theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: appLoc.gameDetailsPlaySessionsNoteLabel,
        fillColor: theme.colorScheme.surface,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.all(8),
        hintText: appLoc.gameDetailsPlaySessionsHintText,
        hintStyle: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
      minLines: 4,
      maxLines: 4,
    );
  }
}
