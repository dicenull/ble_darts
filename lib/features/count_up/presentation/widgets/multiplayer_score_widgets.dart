import 'package:flutter/material.dart';

import '../../domain/count_up_game.dart';
import '../../domain/multiplayer_count_up_game.dart';

class CurrentPlayerWidget extends StatelessWidget {
  final PlayerGameData playerData;

  const CurrentPlayerWidget({
    super.key,
    required this.playerData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '現在のプレイヤー',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: 4),
            Text(
              playerData.player.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'ラウンド',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      '${playerData.game.currentRound}/8',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '投射',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      '${playerData.game.currentThrow}/3',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'スコア',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      '${playerData.game.totalScore}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

  const MultiplayerScoreWidget({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'スコアボード',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
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
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'R${playerData.game.currentRound}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Avg: ${(playerData.game.totalScore / (playerData.game.currentRound > 1 ? playerData.game.currentRound - 1 : 1)).toStringAsFixed(1)}',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const Spacer(),
                              if (playerData.game.isGameFinished)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '完了',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).colorScheme.onSecondary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
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
              'ゲーム終了！',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '勝者: ${sortedPlayers.first.player.name}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'スコア: ${sortedPlayers.first.game.totalScore}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onNewGame,
              child: const Text('新しいゲーム'),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiplayerStatisticsWidget extends StatelessWidget {
  final MultiplayerCountUpGame game;

  const MultiplayerStatisticsWidget({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = game.sortedByScore;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '統計',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            if (game.gameDuration != null) ...[
              _StatRow(
                label: 'ゲーム時間',
                value: _formatDuration(game.gameDuration!),
              ),
              const SizedBox(height: 8),
            ],
            
            if (sortedPlayers.isNotEmpty) ...[
              _StatRow(
                label: '最高スコア',
                value: '${sortedPlayers.first.game.totalScore}',
              ),
              const SizedBox(height: 8),
              _StatRow(
                label: '平均スコア',
                value: _calculateAverageScore(sortedPlayers).toStringAsFixed(1),
              ),
              const SizedBox(height: 16),
            ],
            
            Text(
              'ランキング',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            
            Expanded(
              child: ListView.builder(
                itemCount: sortedPlayers.length,
                itemBuilder: (context, index) {
                  final playerData = sortedPlayers[index];
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 12,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(playerData.player.name),
                    trailing: Text('${playerData.game.totalScore}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  double _calculateAverageScore(List<PlayerGameData> players) {
    if (players.isEmpty) return 0.0;
    final totalScore = players.fold(0, (sum, player) => sum + player.game.totalScore);
    return totalScore / players.length;
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}