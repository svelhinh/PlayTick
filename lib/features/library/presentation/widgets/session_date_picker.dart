import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playtick/l10n/app_localizations.dart';

Future<DateTime?> showSessionDatePicker({
  required BuildContext context,
  required DateTime selectedDate,
}) {
  final now = DateTime.now();
  final firstDate = DateTime(1970);
  var initialDate = selectedDate;
  if (initialDate.isAfter(now)) {
    initialDate = now;
  }
  if (initialDate.isBefore(firstDate)) {
    initialDate = firstDate;
  }

  if (Theme.of(context).platform == TargetPlatform.iOS) {
    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (context) => _CupertinoDatePopup(
        initialDateTime: initialDate,
        minimumDate: firstDate,
        maximumDate: now,
      ),
    );
  }

  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: now,
  );
}

class _CupertinoDatePopup extends StatefulWidget {
  const _CupertinoDatePopup({
    required this.initialDateTime,
    required this.minimumDate,
    required this.maximumDate,
  });

  final DateTime initialDateTime;
  final DateTime minimumDate;
  final DateTime maximumDate;

  @override
  State<_CupertinoDatePopup> createState() => _CupertinoDatePopupState();
}

class _CupertinoDatePopupState extends State<_CupertinoDatePopup> {
  late DateTime _selected = widget.initialDateTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(appLoc.cancel),
                ),
                CupertinoButton(
                  onPressed: () => Navigator.pop(context, _selected),
                  child: Text(appLoc.validate),
                ),
              ],
            ),
            SizedBox(
              height: 216,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: widget.initialDateTime,
                minimumDate: widget.minimumDate,
                maximumDate: widget.maximumDate,
                onDateTimeChanged: (value) => _selected = value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
