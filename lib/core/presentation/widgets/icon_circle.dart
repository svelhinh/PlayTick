import 'package:flutter/material.dart';

final class IconCircle extends StatelessWidget {
  const IconCircle({
    required this.icon,
    required this.backgroundColor,
    this.iconColor,
    this.radius,
    this.iconSize,
    super.key,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color? iconColor;
  final double? radius;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
    );
  }
}
