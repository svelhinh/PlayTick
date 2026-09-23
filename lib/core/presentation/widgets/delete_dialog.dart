import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playtick/l10n/app_localizations.dart';

final class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({
    required this.title,
    required this.description,
    required this.deleteButtonText,
    super.key,
  });

  final String title;
  final String description;
  final String deleteButtonText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    if (theme.platform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          CupertinoDialogAction(
            child: Text(appLoc.cancel),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(context, true),
            isDestructiveAction: true,
            child: Text(deleteButtonText),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(title, style: theme.textTheme.titleLarge),
      titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      backgroundColor: theme.colorScheme.surface,
      content: Text(description, style: theme.textTheme.bodySmall),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(appLoc.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            deleteButtonText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}
