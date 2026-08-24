import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app.dart';
import 'package:playtick/features/home/presentation/home_screen.dart';
import 'package:playtick/features/library/presentation/library_screen.dart';

void main() {
  testWidgets('initial launch renders the home screen', (tester) async {
    await tester.pumpWidget(ProviderScope(child: const PlayTick()));

    await tester.pumpAndSettle();

    final homeScreen = tester.widget<HomeScreen>(find.byType(HomeScreen));
    expect(homeScreen, isNotNull);
  });

  testWidgets('tapping the library tab navigates to the library screen', (
    tester,
  ) async {
    await tester.pumpWidget(ProviderScope(child: const PlayTick()));

    await tester.pumpAndSettle();

    await tester.tap(find.text("Library"));
    await tester.pumpAndSettle();

    final libraryScreen = tester.widget<LibraryScreen>(
      find.byType(LibraryScreen),
    );
    expect(libraryScreen, isNotNull);
  });

  testWidgets("French locale shows French labels", (tester) async {
    tester.binding.platformDispatcher.localesTestValue = const [Locale('fr')];
    addTearDown(tester.binding.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(const ProviderScope(child: PlayTick()));
    await tester.pumpAndSettle();

    expect(find.text('Accueil'), findsWidgets);
    expect(find.text('Bibliothèque'), findsWidgets);
  });
}
