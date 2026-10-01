import 'package:flutter/material.dart';
import 'package:playtick/l10n/app_localizations.dart';

class DemoBadge extends StatelessWidget {
  const DemoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;
    final primary = theme.colorScheme.primary;
    final isIos = theme.platform == TargetPlatform.iOS;

    return Container(
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(isIos ? 999 : 8),
        border: isIos
            ? null
            : Border.all(color: primary.withValues(alpha: 0.35)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        appLoc.demo,
        style: theme.textTheme.bodySmall?.copyWith(
          color: primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
