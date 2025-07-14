import 'package:ble_darts/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as fbs;
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart' as fwb;
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_platform/universal_platform.dart';

const dartsLiveHomeCharacteristic = '6e40fff6-b5a3-f393-e0a9-e50e24dcca9e';
const dartsLiveHomeService = '6e400001-b5a3-f393-e0a9-e50e24dcca9e';

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
  // Mobile用
  fbs.FlutterBluetoothSerial? _bluetooth;
  fbs.BluetoothConnection? connection;
  List<fbs.BluetoothDevice> _devicesList = [];
  fbs.BluetoothDevice? _connectedDevice;

  // Web用
  List<fwb.BluetoothDevice> _webDevicesList = [];
  fwb.BluetoothDevice? _connectedWebDevice;

  // 受信データ用
  final List<String> _receivedData = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (UniversalPlatform.isWeb) {
      _initWebBluetooth();
    } else {
      _requestPermissions();
      _initMobileBluetooth();
    }
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ].request();
  }

  Future<void> _initMobileBluetooth() async {
    _bluetooth = fbs.FlutterBluetoothSerial.instance;
    bool? isEnabled = await _bluetooth!.isEnabled;
    if (isEnabled != null && !isEnabled) {
      await _bluetooth!.requestEnable();
    }
    _getPairedDevices();
  }

  Future<void> _initWebBluetooth() async {
    if (fwb.FlutterWebBluetooth.instance.isBluetoothApiSupported) {
      print('Web Bluetooth API is supported');
    } else {
      print('Web Bluetooth API is not supported');
    }
  }

  void _getPairedDevices() async {
    if (_bluetooth != null) {
      List<fbs.BluetoothDevice> devices = await _bluetooth!.getBondedDevices();
      setState(() {
        _devicesList = devices;
      });
    }
  }

  void _connectToMobileDevice(fbs.BluetoothDevice device) async {
    try {
      connection = await fbs.BluetoothConnection.toAddress(device.address);
      setState(() {
        _connectedDevice = device;
      });

      // データ受信のリスナーを設定
      connection!.input!.listen((data) {
        String receivedText = String.fromCharCodes(data);
        setState(() {
          _receivedData.add(
            '${DateTime.now().toString().substring(11, 19)}: $receivedText',
          );
        });
        // 自動スクロール
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${device.name}に接続しました')));
    } catch (exception) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('接続に失敗しました: $exception')));
    }
  }

  void _scanForWebDevices() async {
    try {
      final device = await fwb.FlutterWebBluetooth.instance.requestDevice(
        fwb.RequestOptionsBuilder.acceptAllDevices(
          optionalServices: [dartsLiveHomeService],
        ),
      );

      setState(() {
        _webDevicesList = [device];
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('デバイス ${device.name} を発見しました')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('デバイス検索に失敗しました: $e')));
    }
  }

  void _connectToWebDevice(fwb.BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        _connectedWebDevice = device;
      });

      final services = await device.discoverServices();
      final service = services.first;

      // Now get the characteristic
      final characteristic = await service.getCharacteristic(
        dartsLiveHomeCharacteristic,
      );
      await characteristic.startNotifications();
      characteristic.value.listen((value) {
        final list = value.buffer.asUint8List().toList();
        final receivedText = dat[list[2]];
        setState(() {
          _receivedData.add(
            '${DateTime.now().toString().substring(11, 19)}: $receivedText',
          );
        });
        // 自動スクロール
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      });

      // Web用のデータ受信設定（実装例）
      // 実際の実装では、特定のサービスとキャラクタリスティックを使用します
      _setupWebDataReceiving(device);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${device.name}に接続しました')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('接続に失敗しました: $e')));
    }
  }

  void _setupWebDataReceiving(fwb.BluetoothDevice device) async {
    try {
      // サンプルデータの追加（実際の実装では実際のBLEサービスからデータを受信）
      setState(() {
        _receivedData.add(
          '${DateTime.now().toString().substring(11, 19)}: Web接続完了',
        );
      });
    } catch (e) {
      print('データ受信設定エラー: $e');
    }
  }

  void _disconnect() async {
    if (UniversalPlatform.isWeb) {
      if (_connectedWebDevice != null) {
        _connectedWebDevice!.disconnect();
        setState(() {
          _connectedWebDevice = null;
        });
      }
    } else {
      if (connection != null) {
        await connection!.close();
        setState(() {
          _connectedDevice = null;
          connection = null;
        });
      }
    }

    // 受信データをクリア
    setState(() {
      _receivedData.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('接続を切断しました')));
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
          if ((UniversalPlatform.isWeb && _connectedWebDevice != null) ||
              (!UniversalPlatform.isWeb && _connectedDevice != null))
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '接続中: ${UniversalPlatform.isWeb ? _connectedWebDevice?.name ?? 'Unknown' : _connectedDevice?.name ?? 'Unknown'}',
                  ),
                  ElevatedButton(
                    onPressed: _disconnect,
                    child: const Text('切断'),
                  ),
                ],
              ),
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
            child: UniversalPlatform.isWeb
                ? _buildWebDevicesList()
                : _buildMobileDevicesList(),
          ),

          // 受信データ表示エリア
          if ((UniversalPlatform.isWeb && _connectedWebDevice != null) ||
              (!UniversalPlatform.isWeb && _connectedDevice != null))
            Container(
              height: 300,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(7),
                        topRight: Radius.circular(7),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '受信データ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _receivedData.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(60, 30),
                          ),
                          child: const Text('クリア'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _receivedData.isEmpty
                        ? const Center(
                            child: Text(
                              'データを受信していません',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: _receivedData.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  _receivedData[index],
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: UniversalPlatform.isWeb
            ? _scanForWebDevices
            : _getPairedDevices,
        tooltip: UniversalPlatform.isWeb ? 'デバイスを検索' : 'デバイスを再取得',
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildWebDevicesList() {
    return ListView.builder(
      itemCount: _webDevicesList.length,
      itemBuilder: (context, index) {
        fwb.BluetoothDevice device = _webDevicesList[index];
        return ListTile(
          leading: const Icon(Icons.bluetooth),
          title: Text(device.name ?? 'Unknown Device'),
          subtitle: Text(device.id),
          trailing: _connectedWebDevice?.id == device.id
              ? const Icon(Icons.check_circle, color: Colors.green)
              : ElevatedButton(
                  onPressed: () => _connectToWebDevice(device),
                  child: const Text('接続'),
                ),
        );
      },
    );
  }

  Widget _buildMobileDevicesList() {
    return ListView.builder(
      itemCount: _devicesList.length,
      itemBuilder: (context, index) {
        fbs.BluetoothDevice device = _devicesList[index];
        return ListTile(
          leading: const Icon(Icons.bluetooth),
          title: Text(device.name ?? 'Unknown Device'),
          subtitle: Text(device.address),
          trailing: _connectedDevice?.address == device.address
              ? const Icon(Icons.check_circle, color: Colors.green)
              : ElevatedButton(
                  onPressed: () => _connectToMobileDevice(device),
                  child: const Text('接続'),
                ),
        );
      },
    );
  }

  @override
  void dispose() {
    connection?.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
