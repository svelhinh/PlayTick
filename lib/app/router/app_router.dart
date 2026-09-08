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
            routes: [
              GoRoute(
                path: AppRoutes.library,
                builder: (context, state) => const LibraryScreen(),
                routes: [
                  GoRoute(
                    path: ':gameId',
                    builder: (context, state) => GameDetailsScreen(
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
