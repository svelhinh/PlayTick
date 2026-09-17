import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:playtick/app/app_theme.dart';
import 'package:playtick/features/library/presentation/providers/library_search_notifier_provider.dart';
import 'package:playtick/l10n/app_localizations.dart';

final libraryNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'libraryBranch',
);

bool popGameDetailsInstantly = false;

void popGameDetailsToLibrary(BuildContext context) {
  popGameDetailsInstantly = true;
  try {
    GoRouter.of(context).pop();
  } finally {
    popGameDetailsInstantly = false;
  }
}

void _leaveLibrary(
  BuildContext context,
  StatefulNavigationShell navigationShell,
  int index,
) {
  final libraryCanPop = libraryNavigatorKey.currentState?.canPop() ?? false;
  if (navigationShell.currentIndex == 1 && libraryCanPop) {
    popGameDetailsToLibrary(context);
  }

  navigationShell.goBranch(index);
}

class AppShell extends ConsumerWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLoc = AppLocalizations.of(context)!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemOverlayStyle,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            if (index != 1) {
              _leaveLibrary(context, navigationShell, index);
              ref.read(librarySearchProvider.notifier).search('');
              return;
            }

            navigationShell.goBranch(1, initialLocation: true);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: appLoc.navigationLabelHome,
            ),
            NavigationDestination(
              icon: const Icon(Icons.library_books_outlined),
              selectedIcon: const Icon(Icons.library_books),
              label: appLoc.navigationLabelLibrary,
            ),
          ],
        ),
        body: navigationShell,
      ),
    );
  }
}
