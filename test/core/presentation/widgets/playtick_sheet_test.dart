import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app/app_theme.dart';
import 'package:playtick/core/presentation/widgets/playtick_sheet.dart';

void main() {
  testWidgets('sheet content stays above the bottom safe area', (tester) async {
    const bottom = 34.0;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    tester.view.padding = const FakeViewPadding(bottom: bottom);
    tester.view.viewPadding = const FakeViewPadding(bottom: bottom);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light.copyWith(platform: TargetPlatform.iOS),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => showPlaytickSheet<void>(
                  context: context,
                  builder: (context) => const Text('Sheet body'),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final body = tester.getRect(find.text('Sheet body'));
    const screenHeight = 800.0;
    expect(body.bottom, lessThanOrEqualTo(screenHeight - bottom));
  });
}
