import 'package:flutter/material.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/l10n/app_localizations.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

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
            Text(appLoc.libraryTitle, style: theme.textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text(appLoc.librarySubtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    EmptyStateCard(
                      icon: Icons.library_books_outlined,
                      title: appLoc.libraryEmptyStateTitle,
                      description: appLoc.libraryEmptyStateDescription,
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
