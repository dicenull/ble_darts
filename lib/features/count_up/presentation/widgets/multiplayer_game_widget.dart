import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../bluetooth/data/bluetooth_provider.dart';
import '../../../bluetooth/domain/bluetooth_device.dart';
import '../../data/multiplayer_count_up_provider.dart';
import '../../domain/multiplayer_count_up_game.dart';
import 'dart_board_widget.dart';
import 'multiplayer_score_widgets.dart';

class MultiplayerGameWidget extends ConsumerStatefulWidget {
  const MultiplayerGameWidget({super.key});

  @override
  ConsumerState<MultiplayerGameWidget> createState() => _MultiplayerGameWidgetState();
}

class _MultiplayerGameWidgetState extends ConsumerState<MultiplayerGameWidget> {
  String? _highlightedPosition;

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(multiplayerCountUpGameNotifierProvider);
    final gameNotifier = ref.read(multiplayerCountUpGameNotifierProvider.notifier);
    final bluetoothState = ref.watch(bluetoothNotifierProvider);

    ref.listen<MultiplayerCountUpGame>(multiplayerCountUpGameNotifierProvider, (previous, current) {
      if (previous != null && current.currentPlayer != null) {
        final previousPlayerGame = previous.currentPlayer?.game;
        
        if (previousPlayerGame != null &&
            current.currentPlayer!.game.rounds.isNotEmpty &&
            current.currentPlayer!.game.rounds[current.currentPlayer!.game.currentRound - 1].length >
                (previous.currentPlayer?.game.rounds.isNotEmpty == true &&
                 previous.currentPlayer!.game.rounds.length >= previous.currentPlayer!.game.currentRound
                    ? previous.currentPlayer!.game.rounds[previous.currentPlayer!.game.currentRound - 1].length
                    : 0)) {
          final currentRoundThrows = current.currentPlayer!.game.rounds[current.currentPlayer!.game.currentRound - 1];
          final latestThrow = currentRoundThrows.last;
          setState(() {
            _highlightedPosition = latestThrow.position;
          });
        }
      }
    });

    return Column(
      children: [
        // Bluetooth接続状態
        if (bluetoothState.connectionState != BluetoothConnectionState.connected)
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
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 4),
                Text(
                  'BT未接続',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        
        Expanded(
          child: Row(
            children: [
              // 左列: プレイヤー情報とスコア
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // 現在のプレイヤー表示
                    if (game.currentPlayer != null)
                      CurrentPlayerWidget(playerData: game.currentPlayer!),
                    const SizedBox(height: 8),
                    
                    // プレイヤーリストとスコア
                    Expanded(
                      child: MultiplayerScoreWidget(game: game),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // ゲーム終了時の結果
                    if (game.isGameFinished)
                      MultiplayerResultWidget(
                        game: game,
                        onNewGame: () => gameNotifier.resetGame(),
                      ),
                    
                    // リセットボタン
                    if (game.isGameActive)
                      ElevatedButton(
                        onPressed: () => _showResetDialog(context, gameNotifier),
                        child: const Text('ゲームリセット'),
                      ),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3),
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
                            gameNotifier.addManualThrow(position);
                            setState(() {
                              _highlightedPosition = position;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 8),
              
              // 右列: 統計情報
              Expanded(
                flex: 2,
                child: MultiplayerStatisticsWidget(game: game),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showResetDialog(
    BuildContext context,
    MultiplayerCountUpGameNotifier gameNotifier,
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