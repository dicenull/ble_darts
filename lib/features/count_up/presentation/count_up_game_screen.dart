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
              _buildStartGameCard(context, gameNotifier, bluetoothState.connectionState == BluetoothConnectionState.connected)
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
              _buildDebugPanel(gameNotifier),
          ],
        ),
      ),
    );
  }

  Widget _buildStartGameCard(BuildContext context, CountUpGameNotifier gameNotifier, bool isBluetoothConnected) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.play_circle_outline,
              size: 64,
              color: Colors.green,
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
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isBluetoothConnected ? () => gameNotifier.startGame() : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('ゲーム開始'),
            ),
            if (!isBluetoothConnected)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Bluetooth接続が必要です',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugPanel(CountUpGameNotifier gameNotifier) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'テスト用（手動入力）',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ダーツボードが接続されていない場合のテスト用機能です',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTestButton('S20', 20, gameNotifier),
                _buildTestButton('D20', 40, gameNotifier),
                _buildTestButton('T20', 60, gameNotifier),
                _buildTestButton('BULL', 50, gameNotifier),
                _buildTestButton('S1', 1, gameNotifier),
                _buildTestButton('S5', 5, gameNotifier),
                _buildTestButton('S10', 10, gameNotifier),
                _buildTestButton('S15', 15, gameNotifier),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(String position, int score, CountUpGameNotifier gameNotifier) {
    return ElevatedButton(
      onPressed: () => gameNotifier.addManualThrow(position),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(60, 36),
      ),
      child: Text(
        '$position\n$score',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 10),
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