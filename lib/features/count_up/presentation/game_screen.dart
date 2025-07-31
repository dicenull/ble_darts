import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../bluetooth/data/bluetooth_provider.dart';
import '../../bluetooth/domain/bluetooth_device.dart';
import 'player_setup_screen.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bluetoothState = ref.watch(bluetoothNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ダーツゲーム'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 接続状態の表示
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      bluetoothState.connectionState ==
                              BluetoothConnectionState.connected
                          ? Icons.bluetooth_connected
                          : Icons.settings_input_antenna,
                      size: 48,
                      color:
                          bluetoothState.connectionState ==
                              BluetoothConnectionState.connected
                          ? Colors.green
                          : Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      bluetoothState.connectionState ==
                              BluetoothConnectionState.connected
                          ? 'Bluetooth接続済み'
                          : '手動入力モード',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bluetoothState.connectionState ==
                              BluetoothConnectionState.connected
                          ? 'ダーツボードと接続されています。ゲームを選択してください。'
                          : '手動でスコアを入力してゲームをプレイできます。',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            // ゲーム選択
            Column(
              children: [
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
      MaterialPageRoute(builder: (context) => const PlayerSetupScreen()),
    );
  }
}
