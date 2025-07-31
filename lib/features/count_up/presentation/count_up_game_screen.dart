import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bluetooth/data/bluetooth_provider.dart';
import '../../bluetooth/domain/bluetooth_device.dart';
import '../data/multiplayer_count_up_provider.dart';
import '../domain/multiplayer_count_up_game.dart';
import 'widgets/dart_board_widget.dart';
import 'widgets/multiplayer_score_widgets.dart';

class CountUpGameScreen extends ConsumerStatefulWidget {
  const CountUpGameScreen({super.key});

  @override
  ConsumerState<CountUpGameScreen> createState() => _CountUpGameScreenState();
}

class _CountUpGameScreenState extends ConsumerState<CountUpGameScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('カウントアップ'),
        actions: [
          if (game.isGameActive)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _showResetDialog(context, gameNotifier),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
                        
                        // プレイヤーリストとスコア（1人の場合は簡素化）
                        Expanded(
                          child: game.players.length == 1 
                              ? _buildSinglePlayerScore(game)
                              : MultiplayerScoreWidget(game: game),
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
                            child: const Text('RESET'),
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
        ),
      ),
    );
  }

  // 1人プレイ用の簡素化されたスコア表示
  Widget _buildSinglePlayerScore(MultiplayerCountUpGame game) {
    final player = game.players.first;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              player.player.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${player.game.totalScore}',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'R${player.game.currentRound}/8',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(
    BuildContext context,
    MultiplayerCountUpGameNotifier gameNotifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('RESET?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('NO'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              gameNotifier.resetGame();
              Navigator.pop(context); // プレイヤー設定画面に戻る
            },
            child: const Text('YES'),
          ),
        ],
      ),
    );
  }
}