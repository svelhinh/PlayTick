import 'package:flutter/material.dart';
import 'package:playtick/features/library/domain/game_status.dart';
import 'package:playtick/features/library/presentation/extensions/game_status_extension.dart';

class GameStatusRow extends StatelessWidget {
  const GameStatusRow({required this.status, super.key});

  final GameStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: status.statusColor(context),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          status.localize(context),
          style: theme.textTheme.bodyMedium!.copyWith(
            color: status.statusColor(
              context,
            ),
          ),
        ),
      ],
    );
  }
}
