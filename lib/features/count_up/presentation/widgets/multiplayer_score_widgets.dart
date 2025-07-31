import 'package:flutter/material.dart';

import '../../domain/multiplayer_count_up_game.dart';

class CurrentPlayerWidget extends StatelessWidget {
  final PlayerGameData playerData;

  const CurrentPlayerWidget({super.key, required this.playerData});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              playerData.player.name,
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '${playerData.game.currentRound}/8',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${playerData.game.currentThrow}/3',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${playerData.game.totalScore}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MultiplayerScoreWidget extends StatelessWidget {
  final MultiplayerCountUpGame game;

  const MultiplayerScoreWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: game.players.length,
                itemBuilder: (context, index) {
                  final playerData = game.players[index];
                  final isActive = playerData.isActive;

                  return Card(
                    color: isActive
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                child: Text('${index + 1}'),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  playerData.player.name,
                                  style: TextStyle(
                                    fontWeight: isActive
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              Text(
                                '${playerData.game.totalScore}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiplayerResultWidget extends StatelessWidget {
  final MultiplayerCountUpGame game;
  final VoidCallback onNewGame;

  const MultiplayerResultWidget({
    super.key,
    required this.game,
    required this.onNewGame,
  });

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = game.sortedByScore;

    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.emoji_events,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              sortedPlayers.first.player.name,
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${sortedPlayers.first.game.totalScore}',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onNewGame, child: const Text('NEW')),
          ],
        ),
      ),
    );
  }
}

class MultiplayerStatisticsWidget extends StatelessWidget {
  final MultiplayerCountUpGame game;

  const MultiplayerStatisticsWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final player = game.currentPlayer;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scores', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...?player?.game.rounds.map((round) {
              final roundScore = round.fold<int>(
                0,
                (sum, dart) => sum + dart.score,
              );
              final isBeforeCurrentRound =
                  player.game.rounds.indexOf(round) + 1 <
                  player.game.currentRound;

              return _StatRow(
                label: 'R${player.game.rounds.indexOf(round) + 1}',
                value: isBeforeCurrentRound ? '$roundScore' : '-',
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
