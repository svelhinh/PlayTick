import 'package:flutter/material.dart';
import 'package:playtick/core/presentation/widgets/icon_circle.dart';
import 'package:playtick/l10n/app_localizations.dart';

class ErrorStateCard extends StatelessWidget {
  const ErrorStateCard({
    required this.title,
    required this.description,
    super.key,
    this.onRetry,
    this.compact = false,
  });

  final String title;
  final String description;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: compact
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: compact
            ? Row(
                children: [
                  IconCircle(
                    icon: Icons.info_outline,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    iconColor: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (onRetry != null) ...[
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 40,
                      child: FilledButton(
                        onPressed: onRetry,
                        child: Text(appLoc.retry),
                      ),
                    ),
                  ],
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 104,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  if (onRetry != null) ...[
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: onRetry,
                      child: Text(appLoc.retry),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
