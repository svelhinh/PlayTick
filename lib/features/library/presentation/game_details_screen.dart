import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playtick/features/library/presentation/providers/library_games_provider.dart';

class GameDetailsScreen extends ConsumerWidget {
  const GameDetailsScreen({required this.gameId, super.key});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(libraryGamesProvider);

    final game = games.asData?.value
        .where(
          (game) => game.gameId == int.tryParse(gameId),
        )
        .firstOrNull;

    if (game == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Game Details'),
        ),
        body: const Center(
          child: Text('Game not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Details'),
      ),
      body: const Center(
        child: Text('Game Details'),
      ),
    );
  }
}
