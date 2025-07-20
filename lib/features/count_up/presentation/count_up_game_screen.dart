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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // 左列: ラウンド情報、ヒット情報、その他UI
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Bluetooth接続状態
                      if (bluetoothState.connectionState !=
                          BluetoothConnectionState.connected)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bluetooth_disabled,
                                size: 16,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'BT未接続',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onErrorContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // ラウンド・ヒット情報
                      if (game.isGameActive || game.isGameFinished) ...[
                        RoundScoresWidget(game: game),
                        const SizedBox(height: 8),
                      ],

                      // ゲーム開始カード
                      if (game.state == GameState.waiting)
                        Expanded(
                          child: _buildStartGameCard(
                            context,
                            gameNotifier,
                            bluetoothState.connectionState,
                          ),
                        ),

                      // ゲーム終了結果
                      if (game.isGameFinished) ...[
                        GameResultWidget(
                          game: game,
                          onNewGame: () => gameNotifier.startGame(),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // 中央: ダーツボード
                Expanded(
                  flex: 4,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: (game.isGameActive || game.isGameFinished)
                          ? Container(
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainer,
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
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: DartBoardWidget(
                                  highlightedPosition: _highlightedPosition,
                                  onHighlightEnd: () {
                                    setState(() {
                                      _highlightedPosition = null;
                                    });
                                  },
                                  onPositionTapped: (position) {
                                    print(
                                      'Detected position: $position',
                                    ); // デバッグ用
                                    gameNotifier.addManualThrow(position);
                                    setState(() {
                                      _highlightedPosition = position;
                                    });
                                  },
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // 右列: 得点表示
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      ScoreDisplayWidget(game: game),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isConnected) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.error),
              ),
              child: Text(
                'MANUAL MODE',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onErrorContainer,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(height: 16),
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
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: const Text(
              'START GAME',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
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
