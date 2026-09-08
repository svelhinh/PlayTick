import 'package:flutter/material.dart';
import 'package:playtick/app/app_theme.dart';
import 'package:playtick/l10n/app_localizations.dart';

final class DeletePlaySessionDialog extends StatelessWidget {
  const DeletePlaySessionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        appLoc.gameDetailsPlaySessionsDeleteTitle,
        style: theme.textTheme.titleLarge,
      ),
      titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      backgroundColor: theme.colorScheme.surface,
      content: Text(
        appLoc.gameDetailsPlaySessionsDeleteDescription,
        style: theme.textTheme.bodySmall,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(appLoc.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            appLoc.gameDetailsPlaySessionsDeleteButton,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.danger,
            ),
          ),
        ),
      ],
    );
  }
}
