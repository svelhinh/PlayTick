import 'package:flutter/material.dart';
import 'package:playtick/features/library/domain/game.dart';

class AddGameSheet extends StatelessWidget {
  const AddGameSheet({required this.game, required this.onAdd, super.key});

  final Game game;
  final void Function(Game) onAdd;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(game.name),
          FilledButton.icon(
            onPressed: () => onAdd(game),
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
