import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app.dart';
import 'package:playtick/features/home/presentation/home_screen.dart';
import 'package:playtick/features/library/presentation/library_screen.dart';

void main() {
  testWidgets('initial launch renders the home screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PlayTick()));

    await tester.pumpAndSettle();

    final homeScreen = tester.widget<HomeScreen>(find.byType(HomeScreen));
    expect(homeScreen, isNotNull);
  });

  testWidgets('French locale shows French labels', (tester) async {
    tester.binding.platformDispatcher.localesTestValue = const [Locale('fr')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(const ProviderScope(child: PlayTick()));
    await tester.pumpAndSettle();

    expect(find.text('Accueil'), findsWidgets);
    expect(find.text('Bibliothèque'), findsWidgets);
  });

  testWidgets(
    'Back and forth navigation between home and library screens',
    (tester) async {
      NavigationBar navigationBar() {
        return tester.widget<NavigationBar>(
          find.byType(NavigationBar),
        );
      }

      await tester.pumpWidget(const ProviderScope(child: PlayTick()));
      await tester.pumpAndSettle();

      expect(navigationBar().selectedIndex, 0);

      await tester.tap(
        find.byType(NavigationDestination).at(1),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LibraryScreen), findsOneWidget);
      expect(navigationBar().selectedIndex, 1);

      await tester.tap(find.byType(NavigationDestination).at(0));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(navigationBar().selectedIndex, 0);
    },
  );
}
