import 'package:flutter/material.dart';
import 'package:playtick/core/presentation/widgets/delete_dialog.dart';
import 'package:playtick/core/presentation/widgets/playtick_sheet.dart';
import 'package:playtick/l10n/app_localizations.dart';

class DemoRestoreScope extends InheritedWidget {
  const DemoRestoreScope({
    required this.onRestore,
    required super.child,
    super.key,
  });

  final Future<void> Function() onRestore;

  static Future<void> Function()? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DemoRestoreScope>()
        ?.onRestore;
  }

  @override
  bool updateShouldNotify(DemoRestoreScope oldWidget) {
    return onRestore != oldWidget.onRestore;
  }
}

class DemoBadge extends StatelessWidget {
  const DemoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;
    final primary = theme.colorScheme.primary;
    final isIos = theme.platform == TargetPlatform.iOS;
    final restore = DemoRestoreScope.maybeOf(context);

    return GestureDetector(
      onTap: () => showPlaytickSheet<void>(
        context: context,
        backgroundColor: theme.colorScheme.surface,
        builder: (sheetContext) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(appLoc.demoSheetTitle, style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              Text(
                appLoc.demoSheetDescription,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: restore == null
                      ? null
                      : () async {
                          final confirmed = await showDialog<bool>(
                            context: sheetContext,
                            builder: (context) => DeleteConfirmationDialog(
                              title: appLoc.demoSheetTitle,
                              description: appLoc.demoSheetDescription,
                              deleteButtonText: appLoc.demoSheetButton,
                            ),
                          );

                          if (confirmed != true || !sheetContext.mounted) {
                            return;
                          }

                          await restore();

                          if (sheetContext.mounted) {
                            Navigator.pop(sheetContext);
                          }
                        },
                  child: Text(appLoc.demoSheetButton),
                ),
              ),
            ],
          ),
        ),
      ),
      child: Container(
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
      ),
    );
  }
}
