import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bluetooth/data/bluetooth_provider.dart';
import '../../bluetooth/domain/bluetooth_device.dart';
import '../data/count_up_provider.dart';
import '../domain/count_up_game.dart';
import 'widgets/dart_board_widget.dart';
import 'widgets/score_widgets.dart';

class CountUpGameScreen extends ConsumerStatefulWidget {
  const CountUpGameScreen({super.key});

  @override
  ConsumerState<CountUpGameScreen> createState() => _CountUpGameScreenState();
}

class _CountUpGameScreenState extends ConsumerState<CountUpGameScreen> {
  String? _highlightedPosition;

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(countUpGameNotifierProvider);
    final gameNotifier = ref.read(countUpGameNotifierProvider.notifier);
    final bluetoothState = ref.watch(bluetoothNotifierProvider);

    ref.listen<CountUpGame>(countUpGameNotifierProvider, (previous, current) {
      if (previous != null &&
          current.currentRoundThrows.length >
              previous.currentRoundThrows.length) {
        final latestThrow = current.currentRoundThrows.last;
        setState(() {
          _highlightedPosition = latestThrow.position;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (game.isGameActive)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _showResetDialog(context, gameNotifier),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (bluetoothState.connectionState !=
                BluetoothConnectionState.connected)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bluetooth_disabled,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'BT未接続',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            ScoreDisplayWidget(game: game),

            if (game.isGameActive || game.isGameFinished)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.shadow.withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: DartBoardWidget(
                  highlightedPosition: _highlightedPosition,
                  onHighlightEnd: () {
                    setState(() {
                      _highlightedPosition = null;
                    });
                  },
                ),
              ),

            if (game.state == GameState.waiting)
              _buildStartGameCard(
                context,
                gameNotifier,
                bluetoothState.connectionState,
              )
            else if (game.isGameActive) ...[
              RoundScoresWidget(game: game),
            ] else if (game.isGameFinished) ...[
              GameResultWidget(
                game: game,
                onNewGame: () => gameNotifier.startGame(),
              ),
              RoundScoresWidget(game: game),
            ],

            if (game.isGameActive)
              _buildManualInputPanel(
                gameNotifier,
                bluetoothState.connectionState ==
                    BluetoothConnectionState.connected,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartGameCard(
    BuildContext context,
    CountUpGameNotifier gameNotifier,
    BluetoothConnectionState connectionState,
  ) {
    final isConnected = connectionState == BluetoothConnectionState.connected;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!isConnected) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.error),
              ),
              child: Text(
                'MANUAL MODE',
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          FilledButton(
            onPressed: () => gameNotifier.startGame(),
            style: FilledButton.styleFrom(
              backgroundColor: isConnected
                  ? colorScheme.primary
                  : colorScheme.error,
              foregroundColor: isConnected
                  ? colorScheme.onPrimary
                  : colorScheme.onError,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'START GAME',
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

  Widget _buildManualInputPanel(
    CountUpGameNotifier gameNotifier,
    bool isBluetoothConnected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isBluetoothConnected
                  ? colorScheme.surfaceContainerHigh
                  : colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isBluetoothConnected
                    ? colorScheme.outline
                    : colorScheme.error,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isBluetoothConnected ? Icons.tune : Icons.touch_app,
                  size: 18,
                  color: isBluetoothConnected
                      ? colorScheme.onSurface
                      : colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  isBluetoothConnected ? 'TEST MODE' : 'MANUAL INPUT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isBluetoothConnected
                        ? colorScheme.onSurface
                        : colorScheme.onErrorContainer,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildScoreButton('S20', 20, gameNotifier),
              _buildScoreButton('D20', 40, gameNotifier),
              _buildScoreButton('T20', 60, gameNotifier),
              _buildScoreButton('BULL', 50, gameNotifier),
              _buildScoreButton('S1', 1, gameNotifier),
              _buildScoreButton('S5', 5, gameNotifier),
              _buildScoreButton('S10', 10, gameNotifier),
              _buildScoreButton('S15', 15, gameNotifier),
              _buildScoreButton('S19', 19, gameNotifier),
              _buildScoreButton('D19', 38, gameNotifier),
              _buildScoreButton('T19', 57, gameNotifier),
              _buildScoreButton('MISS', 0, gameNotifier),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreButton(
    String position,
    int score,
    CountUpGameNotifier gameNotifier,
  ) {
    final isMiss = position == 'MISS';
    final isBull = position == 'BULL';
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton(
      onPressed: () {
        gameNotifier.addManualThrow(position);
        setState(() {
          _highlightedPosition = position;
        });
      },
      style: FilledButton.styleFrom(
        backgroundColor: isMiss
            ? colorScheme.error
            : isBull
            ? colorScheme.tertiary
            : colorScheme.primary,
        foregroundColor: isMiss
            ? colorScheme.onError
            : isBull
            ? colorScheme.onTertiary
            : colorScheme.onPrimary,
        minimumSize: const Size(70, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.zero,
      ),
      child: Text(
        '$position\n$score',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          height: 1.2,
        ),
      ),
    );
  }

  void _showResetDialog(
    BuildContext context,
    CountUpGameNotifier gameNotifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ゲームをリセット'),
        content: const Text('現在のゲームを中断してリセットしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              gameNotifier.resetGame();
            },
            child: const Text('リセット'),
          ),
        ],
      ),
    );
  }
}
