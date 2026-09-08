import 'package:flutter/material.dart';
import 'package:playtick/app/app_theme.dart';
import 'package:playtick/l10n/app_localizations.dart';

final class DeleteGameSheet extends StatelessWidget {
  const DeleteGameSheet({
    required this.name,
    required this.onDelete,
    super.key,
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
