import 'dart:async';

import 'package:ble_darts/bluetooth_manager.dart';
import 'package:ble_darts/widgets/bluetooth_widgets.dart';
import 'package:ble_darts/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Darts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  late BluetoothManager _bluetoothManager;
  final List<String> _receivedData = [];
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<String>? _dataSubscription;

  @override
  void initState() {
    super.initState();
    _bluetoothManager = BluetoothManager();
    _initializeBluetooth();
  }

  Future<void> _initializeBluetooth() async {
    try {
      await _bluetoothManager.initialize();
      _subscribeToDataStream();
      setState(() {});
    } catch (e) {
      _showSnackBar('初期化に失敗しました: $e');
    }
  }

  void _subscribeToDataStream() {
    _dataSubscription = _bluetoothManager.dataStream.listen((data) {
      setState(() {
        _receivedData.add(data);
      });
      _autoScroll();
    });
  }

  void _autoScroll() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _scanDevices() async {
    try {
      await _bluetoothManager.scanDevices();
      setState(() {});
      if (UniversalPlatform.isWeb &&
          _bluetoothManager.availableDevices.isNotEmpty) {
        final device = _bluetoothManager.availableDevices.first;
        _showSnackBar('デバイス ${device.name} を発見しました');
      }
    } catch (e) {
      _showSnackBar('デバイス検索に失敗しました: $e');
    }
  }

  Future<void> _connectToDevice(dynamic device) async {
    try {
      await _bluetoothManager.connectToDevice(device);
      setState(() {});
      _showSnackBar('${device.name}に接続しました');
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  Future<void> _disconnect() async {
    try {
      await _bluetoothManager.disconnect();
      setState(() {
        _receivedData.clear();
      });
      _showSnackBar('接続を切断しました');
    } catch (e) {
      _showSnackBar('切断に失敗しました: $e');
    }
  }

  void _clearData() {
    setState(() {
      _receivedData.clear();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToGameScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          bluetoothManager: _bluetoothManager,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            isConnected: _bluetoothManager.isConnected,
            deviceName: _bluetoothManager.connectedDeviceName,
            onDisconnect: _disconnect,
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
            child: BluetoothDeviceList(
              devices: _bluetoothManager.availableDevices,
              connectedDevice: UniversalPlatform.isWeb
                  ? (_bluetoothManager as WebBluetoothManager)
                        .connectedWebDevice
                  : (_bluetoothManager as MobileBluetoothManager)
                        .connectedDevice,
              onDeviceConnect: _connectToDevice,
              isWeb: UniversalPlatform.isWeb,
            ),
          ),

          // 受信データ表示エリア
          if (_bluetoothManager.isConnected)
            DataDisplayWidget(
              receivedData: _receivedData,
              scrollController: _scrollController,
              onClear: _clearData,
            ),
          
          // ゲームボタン
          if (_bluetoothManager.isConnected)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => _navigateToGameScreen(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('ゲームを開始'),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanDevices,
        tooltip: UniversalPlatform.isWeb ? 'デバイスを検索' : 'デバイスを再取得',
        child: const Icon(Icons.search),
      ),
    );
  }

  @override
  void dispose() {
    _dataSubscription?.cancel();
    _scrollController.dispose();
    if (_bluetoothManager is MobileBluetoothManager) {
      (_bluetoothManager as MobileBluetoothManager).dispose();
    } else if (_bluetoothManager is WebBluetoothManager) {
      (_bluetoothManager as WebBluetoothManager).dispose();
    }
    super.dispose();
  }
}
