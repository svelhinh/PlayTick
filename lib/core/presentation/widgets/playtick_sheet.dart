import 'package:flutter/material.dart';

Future<T?> showPlaytickSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool showDragHandle = true,
  bool useSafeArea = true,
  bool isScrollControlled = true,
  Color? backgroundColor,
}) {
  final safeBottom = MediaQuery.paddingOf(context).bottom;
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: Theme.of(context).platform == TargetPlatform.iOS,
    isScrollControlled: isScrollControlled,
    showDragHandle: showDragHandle,
    useSafeArea: useSafeArea,
    backgroundColor: backgroundColor,
    builder: (sheetContext) {
      final keyboardInset = MediaQuery.viewInsetsOf(sheetContext).bottom;
      return Padding(
        padding: EdgeInsets.only(bottom: keyboardInset > 0 ? 0 : safeBottom),
        child: MediaQuery.removePadding(
          context: sheetContext,
          removeBottom: true,
          child: builder(sheetContext),
        ),
      );
    },
  );
}
