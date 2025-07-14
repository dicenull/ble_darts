import 'package:flutter/material.dart';
import '../models/count_up_game.dart';

class ScoreDisplayWidget extends StatelessWidget {
  final CountUpGame game;

  const ScoreDisplayWidget({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '合計スコア',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  game.totalScore.toString(),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem('ラウンド', '${game.currentRound}/8'),
                _buildStatItem('投射', '${game.currentThrow}/3'),
                _buildStatItem('平均', '${game.averageScore.toStringAsFixed(1)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class RoundScoresWidget extends StatelessWidget {
  final CountUpGame game;

  const RoundScoresWidget({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ラウンド別スコア',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: CountUpGame.maxRounds,
              itemBuilder: (context, index) {
                final roundNumber = index + 1;
                final roundScore = game.roundScores.length > index 
                    ? game.roundScores[index] 
                    : 0;
                final isCurrentRound = roundNumber == game.currentRound && game.isGameActive;
                final isCompleted = game.rounds[index].isNotEmpty;

                return Container(
                  decoration: BoxDecoration(
                    color: isCurrentRound 
                        ? Colors.blue[50] 
                        : isCompleted 
                            ? Colors.green[50] 
                            : Colors.grey[100],
                    border: Border.all(
                      color: isCurrentRound 
                          ? Colors.blue 
                          : isCompleted 
                              ? Colors.green 
                              : Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'R$roundNumber',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isCompleted ? '$roundScore' : '-',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isCurrentRound 
                              ? Colors.blue 
                              : isCompleted 
                                  ? Colors.green 
                                  : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CurrentRoundWidget extends StatelessWidget {
  final CountUpGame game;

  const CurrentRoundWidget({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    if (!game.isGameActive) {
      return const SizedBox.shrink();
    }

    final currentRoundThrows = game.currentRoundThrows;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '現在のラウンド (${game.currentRound}/8)',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(CountUpGame.throwsPerRound, (index) {
                final throwNumber = index + 1;
                final hasThrow = currentRoundThrows.length > index;
                final isCurrentThrow = throwNumber == game.currentThrow;

                return Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: hasThrow 
                        ? Colors.green[50] 
                        : isCurrentThrow 
                            ? Colors.blue[50] 
                            : Colors.grey[100],
                    border: Border.all(
                      color: hasThrow 
                          ? Colors.green 
                          : isCurrentThrow 
                              ? Colors.blue 
                              : Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '投射$throwNumber',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (hasThrow) ...[
                        Text(
                          currentRoundThrows[index].position,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${currentRoundThrows[index].score}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ] else ...[
                        Text(
                          isCurrentThrow ? '待機中' : '-',
                          style: TextStyle(
                            fontSize: 14,
                            color: isCurrentThrow ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class GameResultWidget extends StatelessWidget {
  final CountUpGame game;
  final VoidCallback onNewGame;

  const GameResultWidget({
    super.key,
    required this.game,
    required this.onNewGame,
  });

  @override
  Widget build(BuildContext context) {
    if (!game.isGameFinished) {
      return const SizedBox.shrink();
    }

    final duration = game.gameDuration;
    final roundScores = game.roundScores;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.emoji_events,
              size: 48,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              'ゲーム終了！',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '最終スコア: ${game.totalScore}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildResultStat('平均', '${game.averageScore.toStringAsFixed(1)}'),
                _buildResultStat('最高ラウンド', '${roundScores.isNotEmpty ? roundScores.reduce((a, b) => a > b ? a : b) : 0}'),
                if (duration != null)
                  _buildResultStat('時間', '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}'),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onNewGame,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('新しいゲーム'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}