import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/app.dart';

void main() {
  testWidgets('renders the PlayTick application', (tester) async {
    await tester.pumpWidget(const PlayTick());

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'Play Tick');
    expect(app.debugShowCheckedModeBanner, isFalse);
  });
}
