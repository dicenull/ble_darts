import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as fbs;
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart' as fwb;
import 'package:permission_handler/permission_handler.dart';
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
  // Mobile用
  fbs.FlutterBluetoothSerial? _bluetooth;
  fbs.BluetoothConnection? connection;
  List<fbs.BluetoothDevice> _devicesList = [];
  fbs.BluetoothDevice? _connectedDevice;

  // Web用
  List<fwb.BluetoothDevice> _webDevicesList = [];
  fwb.BluetoothDevice? _connectedWebDevice;

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
        fwb.RequestOptionsBuilder.acceptAllDevices(optionalServices: []),
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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${device.name}に接続しました')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('接続に失敗しました: $e')));
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
            child: UniversalPlatform.isWeb
                ? _buildWebDevicesList()
                : _buildMobileDevicesList(),
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
    super.dispose();
  }
}
