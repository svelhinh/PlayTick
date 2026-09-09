import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:playtick/app/router/app_router.dart';
import 'package:playtick/core/presentation/widgets/empty_state_card.dart';
import 'package:playtick/core/presentation/widgets/icon_circle.dart';
import 'package:playtick/features/home/presentation/providers/weekly_playtime_provider.dart';
import 'package:playtick/features/library/presentation/extensions/playtime_localization.dart';
import 'package:playtick/l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLoc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final playtime = ref.watch(weeklyPlaytimeProvider);

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
                    Row(
                      children: [
                        Expanded(
                          child: _TopCard(
                            title: appLoc.homeWeeklyPlaytime,
                            info: (playtime.value ?? Duration.zero).localize(
                              appLoc,
                              withMinutes: false,
                            ),
                            icon: Icons.access_time_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _TopCard(
                            title: appLoc.homeTotalGames,
                            info: '0',
                            icon: Icons.sports_esports_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
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

final class _TopCard extends StatelessWidget {
  const _TopCard({
    required this.title,
    required this.info,
    required this.icon,
  });

  final String title;
  final String info;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  info,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                IconCircle(
                  icon: icon,
                  backgroundColor: theme.colorScheme.secondary.withValues(
                    alpha: 0.1,
                  ),
                  iconSize: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
