import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playtick/core/presentation/native_ios_chrome.dart';

void main() {
  test('uses native iOS views only in the iOS app', () {
    expect(usesNativeIosViews(TargetPlatform.iOS), isTrue);
    expect(usesNativeIosViews(TargetPlatform.iOS, isWeb: true), isFalse);
    expect(usesNativeIosViews(TargetPlatform.android), isFalse);
    expect(usesNativeIosViews(TargetPlatform.android, isWeb: true), isFalse);
  });
}
