import 'dart:async';

import 'package:flutter/material.dart';

final class HoldStepButton extends StatefulWidget {
  const HoldStepButton({
    required this.icon,
    required this.onStep,
    super.key,
  });

  final IconData icon;
  final VoidCallback onStep;

  @override
  State<HoldStepButton> createState() => _HoldStepButtonState();
}

class _HoldStepButtonState extends State<HoldStepButton> {
  static const _holdDelay = Duration(milliseconds: 400);
  static const _repeatInterval = Duration(milliseconds: 80);

  Timer? _delay;
  Timer? _repeat;

  void _startHold() {
    widget.onStep();
    _delay = Timer(_holdDelay, () {
      _repeat = Timer.periodic(_repeatInterval, (_) {
        if (!mounted) {
          return;
        }
        widget.onStep();
      });
    });
  }

  void _stopHold() {
    _delay?.cancel();
    _repeat?.cancel();
    _delay = null;
    _repeat = null;
  }

  @override
  void dispose() {
    _stopHold();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => _startHold(),
      onPointerUp: (_) => _stopHold(),
      onPointerCancel: (_) => _stopHold(),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(
          widget.icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
