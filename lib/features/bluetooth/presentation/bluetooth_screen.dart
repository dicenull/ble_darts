import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_platform/universal_platform.dart';
import '../data/bluetooth_provider.dart';
import '../domain/bluetooth_device.dart';
import 'widgets/bluetooth_widgets.dart';
import '../../count_up/presentation/game_screen.dart';

class BluetoothScreen extends ConsumerWidget {
  const BluetoothScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bluetoothState = ref.watch(bluetoothNotifierProvider);
    final bluetoothNotifier = ref.read(bluetoothNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          UniversalPlatform.isWeb ? 'BLE Darts (Web)' : 'BLE Darts (Mobile)',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // 接続状態表示
          ConnectionStatusWidget(
            isConnected: bluetoothState.isConnected,
            deviceName: bluetoothState.connectedDeviceName,
            onDisconnect: () => bluetoothNotifier.disconnect(),
          ),

          // プラットフォーム情報
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              UniversalPlatform.isWeb
                  ? 'Web環境でのBluetooth接続'
                  : 'モバイル環境でのBluetooth接続',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // エラーメッセージ表示
          if (bluetoothState.errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          bluetoothState.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // デバイス一覧タイトル
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              UniversalPlatform.isWeb ? '検索されたデバイス一覧' : 'ペアリング済みデバイス一覧',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // デバイス一覧
          Expanded(
            flex: 1,
            child: BluetoothDeviceListWidget(
              devices: bluetoothState.availableDevices,
              connectedDevice: bluetoothState.connectedDevice,
              onDeviceConnect: (device) => bluetoothNotifier.connectToDevice(device),
              isWeb: UniversalPlatform.isWeb,
            ),
          ),

          // 受信データ表示エリア
          if (bluetoothState.isConnected)
            DataDisplayWidget(
              receivedData: bluetoothState.receivedData,
              onClear: () => bluetoothNotifier.clearData(),
            ),
          
          // ゲームボタン
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (bluetoothState.isConnected)
                  ElevatedButton(
                    onPressed: () => _navigateToGameScreen(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('ゲームを開始'),
                  ),
                if (!bluetoothState.isConnected) ...[
                  ElevatedButton(
                    onPressed: () => _navigateToGameScreen(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Bluetooth接続をスキップしてゲームを開始'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '手動入力モードでゲームをプレイできます',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bluetoothNotifier.scanDevices(),
        tooltip: UniversalPlatform.isWeb ? 'デバイスを検索' : 'デバイスを再取得',
        child: const Icon(Icons.search),
      ),
    );
  }

  void _navigateToGameScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GameScreen(),
      ),
    );
  }
}