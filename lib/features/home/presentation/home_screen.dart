import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playtick/app/router/app_router.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Text(appLoc.appName, style: theme.textTheme.headlineLarge),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    EmptyStateCard(
                      icon: Icons.sports_esports_outlined,
                      title: appLoc.homeEmptyCardTitle,
                      description: appLoc.homeEmptyCardDescription,
                      action: FilledButton(
                        onPressed: () => context.go(AppRoutes.library),
                        child: Text(appLoc.homeEmptyCardButtonText),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
