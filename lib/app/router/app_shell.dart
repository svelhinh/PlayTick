import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playtick/l10n/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home),
            label: appLoc.navigationLabelHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.library_books),
            label: appLoc.navigationLabelLibrary,
          ),
        ],
      ),
      body: navigationShell,
    );
  }
}
