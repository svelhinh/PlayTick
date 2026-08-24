import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playtick/l10n/app_localizations.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(index),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: appLoc.homeTitle,
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books),
            label: appLoc.libraryTitle,
          ),
        ],
      ),
      body: navigationShell,
    );
  }
}
