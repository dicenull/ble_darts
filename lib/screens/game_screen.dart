import 'package:flutter/material.dart';
import '../bluetooth_manager.dart';
import 'count_up_game_screen.dart';

class GameScreen extends StatelessWidget {
  final BluetoothManager bluetoothManager;

  const GameScreen({super.key, required this.bluetoothManager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ダーツゲーム'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!bluetoothManager.isConnected)
              const Card(
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.bluetooth_disabled,
                        size: 48,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Bluetooth接続が必要です',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'ゲームを開始するには、まずダーツボードとBluetooth接続を行ってください。',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: [
                  const Card(
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.bluetooth_connected,
                            size: 48,
                            color: Colors.green,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Bluetooth接続済み',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'ダーツボードと接続されています。ゲームを選択してください。',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildGameCard(
                    context,
                    title: 'カウントアップ',
                    description: '8ラウンドでの累計スコアを競うゲームです',
                    icon: Icons.trending_up,
                    onTap: () => _startCountUpGame(context),
                  ),
                  const SizedBox(height: 16),
                  _buildGameCard(
                    context,
                    title: '501（準備中）',
                    description: '501点から0点を目指すゲームです',
                    icon: Icons.track_changes,
                    onTap: null,
                  ),
                  const SizedBox(height: 16),
                  _buildGameCard(
                    context,
                    title: 'クリケット（準備中）',
                    description: '特定のナンバーを狙うゲームです',
                    icon: Icons.sports_cricket,
                    onTap: null,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: onTap != null
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: onTap != null ? null : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: onTap != null ? Colors.grey[600] : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: onTap != null ? Colors.grey : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startCountUpGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CountUpGameScreen(bluetoothManager: bluetoothManager),
      ),
    );
  }
}
