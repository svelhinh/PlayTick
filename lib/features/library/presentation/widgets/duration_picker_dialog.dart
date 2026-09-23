import 'package:flutter/material.dart';
import 'package:playtick/features/library/presentation/widgets/hold_step_button.dart';
import 'package:playtick/l10n/app_localizations.dart';

final class DurationPickerDialog extends StatefulWidget {
  const DurationPickerDialog({required this.duration, super.key});

  final Duration duration;

  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  int _hours = 0;
  int _minutes = 0;

  void _decreaseHours() {
    setState(() {
      if (_hours == 1 && _minutes == 0) {
        return;
      }

      final next = _hours - 1;
      _hours = next < 0 ? 0 : next;
    });
  }

  void _increaseHours() {
    setState(() => _hours = _hours + 1);
  }

  void _decreaseMinutes() {
    setState(() {
      final next = _minutes - 1;

      if (next < 0) {
        if (_hours == 0) {
          return;
        }

        _hours -= 1;
        _minutes = 59;
        return;
      }

      if (_hours == 0 && next == 0) {
        return;
      }

      _minutes = next;
    });
  }

  void _increaseMinutes() {
    setState(() {
      final next = _minutes + 1;
      if (next > 59) {
        _increaseHours();
        _minutes = 0;
      } else {
        _minutes = next;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final initialDuration = widget.duration < const Duration(minutes: 1)
        ? const Duration(minutes: 1)
        : widget.duration;
    _hours = initialDuration.inHours;
    _minutes = initialDuration.inMinutes.remainder(60);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLoc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        appLoc.gameDetailsPlaySessionsDurationLabel,
        style: theme.textTheme.titleLarge,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, widget.duration),
          child: Text(appLoc.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            Duration(hours: _hours, minutes: _minutes),
          ),
          child: Text(appLoc.validate),
        ),
      ],
      titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      backgroundColor: theme.colorScheme.surface,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surfaceContainerHigh,
                  border: Border.all(
                    color: theme.colorScheme.outline,
                  ),
                ),
                child: Column(
                  children: [
                    HoldStepButton(
                      icon: Icons.add,
                      onStep: _increaseHours,
                    ),
                    Container(
                      width: double.infinity,
                      color: theme.colorScheme.surface,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        _hours.toString(),
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    HoldStepButton(
                      icon: Icons.remove,
                      onStep: _decreaseHours,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                appLoc.hours,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(width: 40),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: theme.colorScheme.surfaceContainerHigh,
                  border: Border.all(
                    color: theme.colorScheme.outline,
                  ),
                ),
                child: Column(
                  children: [
                    HoldStepButton(
                      icon: Icons.add,
                      onStep: _increaseMinutes,
                    ),
                    Container(
                      width: double.infinity,
                      color: theme.colorScheme.surface,
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        _minutes.toString().padLeft(2, '0'),
                        style: theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    HoldStepButton(
                      icon: Icons.remove,
                      onStep: _decreaseMinutes,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                appLoc.minutes,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
