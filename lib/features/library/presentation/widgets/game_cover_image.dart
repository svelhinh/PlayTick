import 'package:flutter/material.dart';

class GameCoverImage extends StatelessWidget {
  const GameCoverImage({
    required this.coverUrl,
    this.width = 72,
    this.height = 72,
    super.key,
  });

  final String? coverUrl;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: coverUrl != null
            ? Image.network(
                coverUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.gamepad),
              )
            : const Icon(Icons.gamepad),
      ),
    );
  }
}
