import 'package:flutter/material.dart';

import '../../domain/count_up_game.dart';

class ScoreDisplayWidget extends StatelessWidget {
  final CountUpGame game;

  const ScoreDisplayWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Text(
            '${game.currentRound}/8',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        // ラウンドの投射を下に表示
        if (game.isGameActive) ...[
          const SizedBox(height: 12),
          Row(
            children: List.generate(3, (index) {
              final throwNumber = index + 1;
              final hasThrow = game.currentRoundThrows.length > index;
              final isCurrentThrow = throwNumber == game.currentThrow;

              return Container(
                margin: const EdgeInsets.only(right: 10),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: hasThrow
                      ? colorScheme.primaryContainer
                      : isCurrentThrow
                      ? colorScheme.surfaceContainerHigh
                      : colorScheme.surfaceContainer,
                  border: Border.all(
                    color: hasThrow
                        ? colorScheme.primary
                        : isCurrentThrow
                        ? colorScheme.primary
                        : colorScheme.outline,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: hasThrow
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: hasThrow
                      ? Text(
                          '${game.currentRoundThrows[index].score}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        )
                      : Text(
                          '$throwNumber',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: isCurrentThrow
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              );
            }),
          ),
        ],

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          width: 300,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colorScheme.primary, width: 2),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              game.totalScore.toString(),
              style: TextStyle(
                fontSize: 96,
                fontWeight: FontWeight.w900,
                color: colorScheme.onPrimaryContainer,
                letterSpacing: -2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RoundScoresWidget extends StatelessWidget {
  final CountUpGame game;

  const RoundScoresWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: CountUpGameX.maxRounds,
        itemBuilder: (context, index) {
          final roundNumber = index + 1;
          final roundScore = game.roundScores.length > index
              ? game.roundScores[index]
              : 0;
          final isCurrentRound =
              roundNumber == game.currentRound && game.isGameActive;
          final isCompleted =
              game.rounds.length > index && game.rounds[index].isNotEmpty;

          return Container(
            decoration: BoxDecoration(
              color: isCurrentRound
                  ? colorScheme.primaryContainer
                  : isCompleted
                  ? colorScheme.secondaryContainer
                  : colorScheme.surfaceContainerLow,
              border: Border.all(
                color: isCurrentRound
                    ? colorScheme.primary
                    : isCompleted
                    ? colorScheme.secondary
                    : colorScheme.outlineVariant,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isCurrentRound
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isCompleted ? '$roundScore' : '-',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: isCurrentRound
                        ? colorScheme.onPrimaryContainer
                        : isCompleted
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
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
    // if (!game.isGameFinished) {
    //   return const SizedBox.shrink();
    // }

    final colorScheme = Theme.of(context).colorScheme;
    final duration = game.gameDuration;
    final roundScores = game.roundScores;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: colorScheme.primary, width: 2),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.tertiary,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.tertiary.withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.emoji_events,
              size: 48,
              color: colorScheme.onTertiary,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorScheme.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              '${game.totalScore}',
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w900,
                color: colorScheme.onPrimaryContainer,
                letterSpacing: -2,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildResultStat('AVG', game.averageScore.toStringAsFixed(1)),
              _buildResultStat(
                'MAX',
                '${roundScores.isNotEmpty ? roundScores.reduce((a, b) => a > b ? a : b) : 0}',
              ),
              if (duration != null)
                _buildResultStat(
                  'TIME',
                  '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                ),
            ],
          ),
          const SizedBox(height: 32),
          if (game.isGameFinished || game.state == GameState.waiting)
            FilledButton(
              onPressed: onNewGame,
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'NEW GAME',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultStat(String label, String value) {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
