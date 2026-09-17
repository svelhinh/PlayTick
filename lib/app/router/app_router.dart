import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playtick/app/router/app_shell.dart';
import 'package:playtick/features/home/presentation/home_screen.dart';
import 'package:playtick/features/library/presentation/game_details/game_details_screen.dart';
import 'package:playtick/features/library/presentation/library_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

class AppRoutes {
  static const home = '/';
  static const library = '/library';

  static String gameDetailsPath(String gameId) => '$library/$gameId';
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final router = GoRouter(
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: libraryNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.library,
                builder: (context, state) => const LibraryScreen(),
                routes: [
                  GoRoute(
                    path: ':gameId',
                    pageBuilder: (context, state) => GameDetailsPage(
                      key: state.pageKey,
                      gameId: state.pathParameters['gameId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);

  return router;
}

class GameDetailsPage extends Page<void> {
  const GameDetailsPage({
    required this.gameId,
    super.key,
  });

  final String gameId;

  @override
  Route<void> createRoute(BuildContext context) {
    return _GameDetailsPageRoute(this);
  }
}

class _GameDetailsPageRoute extends PageRoute<void>
    with MaterialRouteTransitionMixin<void> {
  _GameDetailsPageRoute(GameDetailsPage page) : super(settings: page) {
    assert(opaque, 'Game details is an opaque page route.');
  }

  GameDetailsPage get _page => settings as GameDetailsPage;

  @override
  Widget buildContent(BuildContext context) {
    return GameDetailsScreen(gameId: _page.gameId);
  }

  @override
  bool get maintainState => true;

  @override
  bool get fullscreenDialog => false;

  @override
  Duration get reverseTransitionDuration {
    if (popGameDetailsInstantly) {
      return Duration.zero;
    }
    return super.reverseTransitionDuration;
  }
}
