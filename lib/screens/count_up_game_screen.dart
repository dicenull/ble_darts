import 'package:flutter/material.dart';
import 'dart:async';
import '../bluetooth_manager.dart';
import '../services/game_service.dart';
import '../models/count_up_game.dart';
import '../widgets/score_widgets.dart';

class CountUpGameScreen extends StatefulWidget {
  final BluetoothManager bluetoothManager;

  const CountUpGameScreen({
    super.key,
    required this.bluetoothManager,
  });

  @override
  State<CountUpGameScreen> createState() => _CountUpGameScreenState();
}

class _CountUpGameScreenState extends State<CountUpGameScreen> {
  late GameService _gameService;
  StreamSubscription<CountUpGame>? _gameSubscription;
  CountUpGame? _currentGame;

  @override
  void initState() {
    super.initState();
    _gameService = GameService();
    _gameService.connectToBluetoothStream(widget.bluetoothManager.dataStream);
    
    _gameSubscription = _gameService.gameStateStream.listen((game) {
      setState(() {
        _currentGame = game;
      });
    });
    
    _currentGame = _gameService.currentGame;
  }

  @override
  void dispose() {
    _gameSubscription?.cancel();
    _gameService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('カウントアップ'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_currentGame?.isGameActive == true)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _showResetDialog,
              tooltip: 'ゲームをリセット',
            ),
        ],
      ),
      body: _currentGame == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (!widget.bluetoothManager.isConnected)
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
                  
                  ScoreDisplayWidget(game: _currentGame!),
                  
                  if (_currentGame!.state == GameState.waiting)
                    _buildStartGameCard()
                  else if (_currentGame!.isGameActive) ...[
                    CurrentRoundWidget(game: _currentGame!),
                    RoundScoresWidget(game: _currentGame!),
                  ] else if (_currentGame!.isGameFinished) ...[
                    GameResultWidget(
                      game: _currentGame!,
                      onNewGame: _startNewGame,
                    ),
                    RoundScoresWidget(game: _currentGame!),
                  ],
                  
                  if (_currentGame!.isGameActive)
                    _buildDebugPanel(),
                ],
              ),
            ),
    );
  }

  Widget _buildStartGameCard() {
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
              onPressed: widget.bluetoothManager.isConnected ? _startNewGame : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('ゲーム開始'),
            ),
            if (!widget.bluetoothManager.isConnected)
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

  Widget _buildDebugPanel() {
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
                _buildTestButton('S20', 20),
                _buildTestButton('D20', 40),
                _buildTestButton('T20', 60),
                _buildTestButton('BULL', 50),
                _buildTestButton('S1', 1),
                _buildTestButton('S5', 5),
                _buildTestButton('S10', 10),
                _buildTestButton('S15', 15),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(String position, int score) {
    return ElevatedButton(
      onPressed: () => _gameService.addManualThrow(position),
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

  void _startNewGame() {
    _gameService.startNewGame();
  }

  void _showResetDialog() {
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
              _gameService.resetGame();
            },
            child: const Text('リセット'),
          ),
        ],
      ),
    );
  }
}