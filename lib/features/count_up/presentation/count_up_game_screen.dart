import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/count_up_provider.dart';
import '../domain/count_up_game.dart';
import '../../bluetooth/data/bluetooth_provider.dart';
import '../../bluetooth/domain/bluetooth_device.dart';
import 'widgets/score_widgets.dart';

class CountUpGameScreen extends ConsumerWidget {
  const CountUpGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(countUpGameNotifierProvider);
    final gameNotifier = ref.read(countUpGameNotifierProvider.notifier);
    final bluetoothState = ref.watch(bluetoothNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('カウントアップ'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (game.isGameActive)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _showResetDialog(context, gameNotifier),
              tooltip: 'ゲームをリセット',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (bluetoothState.connectionState != BluetoothConnectionState.connected)
              const Card(
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Bluetooth接続が切断されました'),
                    ],
                  ),
                ),
              ),
            
            ScoreDisplayWidget(game: game),
            
            if (game.state == GameState.waiting)
              _buildStartGameCard(context, gameNotifier, bluetoothState.connectionState)
            else if (game.isGameActive) ...[
              CurrentRoundWidget(game: game),
              RoundScoresWidget(game: game),
            ] else if (game.isGameFinished) ...[
              GameResultWidget(
                game: game,
                onNewGame: () => gameNotifier.startGame(),
              ),
              RoundScoresWidget(game: game),
            ],
            
            if (game.isGameActive)
              _buildManualInputPanel(gameNotifier, bluetoothState.connectionState == BluetoothConnectionState.connected),
          ],
        ),
      ),
    );
  }

  Widget _buildStartGameCard(BuildContext context, CountUpGameNotifier gameNotifier, BluetoothConnectionState connectionState) {
    final isConnected = connectionState == BluetoothConnectionState.connected;
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.play_circle_outline,
              size: 64,
              color: isConnected ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              'カウントアップゲーム',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '8ラウンド（各3投射）でできるだけ高いスコアを目指しましょう！',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            if (!isConnected) ...[
              const SizedBox(height: 8),
              Text(
                '手動入力モードでプレイします',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => gameNotifier.startGame(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: isConnected ? null : Colors.orange,
                foregroundColor: isConnected ? null : Colors.white,
              ),
              child: Text(isConnected ? 'ゲーム開始' : '手動入力でゲーム開始'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualInputPanel(CountUpGameNotifier gameNotifier, bool isBluetoothConnected) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isBluetoothConnected ? Icons.settings : Icons.touch_app,
                  size: 20,
                  color: isBluetoothConnected ? Colors.grey : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  isBluetoothConnected ? 'テスト用（手動入力）' : '手動入力',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isBluetoothConnected ? null : Colors.orange[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isBluetoothConnected 
                  ? 'ダーツボードが接続されていない場合のテスト用機能です'
                  : 'スコアボタンをタップしてダーツの投射を記録してください',
              style: TextStyle(
                fontSize: 12,
                color: isBluetoothConnected ? Colors.grey : Colors.orange[600],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
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
      ),
    );
  }

  Widget _buildScoreButton(String position, int score, CountUpGameNotifier gameNotifier) {
    return ElevatedButton(
      onPressed: () => gameNotifier.addManualThrow(position),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(70, 40),
        backgroundColor: position == 'MISS' ? Colors.red[50] : null,
        foregroundColor: position == 'MISS' ? Colors.red[700] : null,
      ),
      child: Text(
        '$position\n$score',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _showResetDialog(BuildContext context, CountUpGameNotifier gameNotifier) {
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