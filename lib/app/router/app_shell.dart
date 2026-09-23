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

class AppShell extends ConsumerStatefulWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => AppShellState();
}

class AppShellState extends ConsumerState<AppShell> {
  MethodChannel? _tabChannel;

  @visibleForTesting
  int? platformViewId;

  void _selectIndex(int index) {
    final navigationShell = widget.navigationShell;

    if (index != 1) {
      FocusManager.instance.primaryFocus?.unfocus();
      _leaveLibrary(index);
      ref.read(librarySearchProvider.notifier).search('');
      return;
    }

    navigationShell.goBranch(1, initialLocation: true);
  }

  void _leaveLibrary(int index) {
    final navigationShell = widget.navigationShell;
    final libraryCanPop = libraryNavigatorKey.currentState?.canPop() ?? false;
    if (navigationShell.currentIndex == 1 && libraryCanPop) {
      popGameDetailsToLibrary(context);
    }

    navigationShell.goBranch(index);
  }

  void _bindTabChannel(int id) {
    _tabChannel?.setMethodCallHandler(null);
    platformViewId = id;
    _tabChannel = MethodChannel('playtick-liquid-glass/$id')
      ..setMethodCallHandler((call) async {
        if (call.method != 'selectIndex' || !mounted) {
          return;
        }

        _selectIndex(call.arguments as int);
      });
  }

  @override
  void dispose() {
    _tabChannel?.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      onPlatformViewCreated: _bindTabChannel,
                    ),
                  ),
                ),
              )
            else
              NavigationBar(
                selectedIndex: widget.navigationShell.currentIndex,
                onDestinationSelected: _selectIndex,
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
        body: widget.navigationShell,
      ),
    );
  }
}
