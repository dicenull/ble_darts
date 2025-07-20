import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../count_up/presentation/game_screen.dart';
import '../data/bluetooth_provider.dart';
import '../domain/bluetooth_device.dart';
import 'widgets/bluetooth_widgets.dart';

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

          // デバイス検索ボタン
          Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 80,
                  child: ElevatedButton.icon(
                    onPressed: () => bluetoothNotifier.scanDevices(),
                    icon: const Icon(Icons.search, size: 32),
                    label: Text(
                      UniversalPlatform.isWeb ? 'デバイスを検索' : 'デバイスを再取得',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
                if (!bluetoothState.isConnected) ...[
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => _navigateToGameScreen(context),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('BTなしで開始'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(80, 48),
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
                if (bluetoothState.isConnected) ...[
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 80,
                    child: ElevatedButton.icon(
                      onPressed: () => _navigateToGameScreen(context),
                      icon: const Icon(Icons.play_arrow, size: 32),
                      label: const Text(
                        'ゲームを開始',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // デバイス一覧タイトル
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
              onDeviceConnect: (device) =>
                  bluetoothNotifier.connectToDevice(device),
              isWeb: UniversalPlatform.isWeb,
            ),
          ),

          // 受信データ表示エリア
          if (bluetoothState.isConnected)
            DataDisplayWidget(
              receivedData: bluetoothState.receivedData,
              onClear: () => bluetoothNotifier.clearData(),
            ),
        ],
      ),
    );
  }

  void _navigateToGameScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }
}
