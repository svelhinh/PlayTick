import 'package:flutter/material.dart';

bool usesNativeIosViews(TargetPlatform platform, {bool isWeb = false}) {
  return !isWeb && platform == TargetPlatform.iOS;
}
