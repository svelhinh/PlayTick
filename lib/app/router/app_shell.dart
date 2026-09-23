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

  void _selectIndex(
    BuildContext context,
    WidgetRef ref,
    StatefulNavigationShell navigationShell,
    int index,
  ) {
    if (index != 1) {
      FocusManager.instance.primaryFocus?.unfocus();
      _leaveLibrary(context, navigationShell, index);
      ref.read(librarySearchProvider.notifier).search('');
      return;
    }

    navigationShell.goBranch(1, initialLocation: true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLoc = AppLocalizations.of(context)!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemOverlayStyle,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        extendBody: Theme.of(context).platform == TargetPlatform.iOS,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (Theme.of(context).platform == TargetPlatform.iOS)
              SizedBox(
                height: 84,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 236,
                    height: 84,
                    child: UiKitView(
                      viewType: 'playtick-liquid-glass',
                      creationParams: {
                        'home-label': appLoc.navigationLabelHome,
                        'library-label': appLoc.navigationLabelLibrary,
                      },
                      creationParamsCodec: const StandardMessageCodec(),
                      onPlatformViewCreated: (id) {
                        MethodChannel(
                          'playtick-liquid-glass/$id',
                        ).setMethodCallHandler(
                          (call) async {
                            if (call.method != 'selectIndex') {
                              return;
                            }

                            _selectIndex(
                              context,
                              ref,
                              navigationShell,
                              call.arguments as int,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              )
            else
              NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: (index) =>
                    _selectIndex(context, ref, navigationShell, index),
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
          ],
        ),
        body: navigationShell,
      ),
    );
  }
}
