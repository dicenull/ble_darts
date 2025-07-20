import 'dart:async';

import 'package:ble_darts/data.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as fbs;
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart' as fwb;
import 'package:permission_handler/permission_handler.dart';
import 'package:universal_platform/universal_platform.dart';

const dartsLiveHomeCharacteristic = '6e40fff6-b5a3-f393-e0a9-e50e24dcca9e';
const dartsLiveHomeService = '6e400001-b5a3-f393-e0a9-e50e24dcca9e';

abstract class BluetoothManager {
  factory BluetoothManager() {
    if (UniversalPlatform.isWeb) {
      return WebBluetoothManager();
    } else {
      return MobileBluetoothManager();
    }
  }

  Future<void> initialize();
  Future<void> scanDevices();
  Future<void> connectToDevice(dynamic device);
  Future<void> disconnect();
  bool get isConnected;
  String? get connectedDeviceName;
  List<dynamic> get availableDevices;
  Stream<String> get dataStream;
}

class MobileBluetoothManager implements BluetoothManager {
  fbs.FlutterBluetoothSerial? _bluetooth;
  fbs.BluetoothConnection? _connection;
  List<fbs.BluetoothDevice> _devicesList = [];
  fbs.BluetoothDevice? _connectedDevice;

  final StreamController<String> _dataController =
      StreamController<String>.broadcast();

  @override
  Future<void> initialize() async {
    await _requestPermissions();
    await _initBluetooth();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ].request();
  }

  Future<void> _initBluetooth() async {
    _bluetooth = fbs.FlutterBluetoothSerial.instance;
    bool? isEnabled = await _bluetooth!.isEnabled;
    if (isEnabled != null && !isEnabled) {
      await _bluetooth!.requestEnable();
    }
    await scanDevices();
  }

  @override
  Future<void> scanDevices() async {
    if (_bluetooth != null) {
      List<fbs.BluetoothDevice> devices = await _bluetooth!.getBondedDevices();
      _devicesList = devices;
    }
  }

  @override
  Future<void> connectToDevice(dynamic device) async {
    if (device is! fbs.BluetoothDevice) return;

    try {
      _connection = await fbs.BluetoothConnection.toAddress(device.address);
      _connectedDevice = device;

      // データ受信のリスナーを設定
      _connection!.input!.listen((data) {
        String receivedText = String.fromCharCodes(data);
        String timestampedData =
            '${DateTime.now().toString().substring(11, 19)}: $receivedText';
        _dataController.add(timestampedData);
      });
    } catch (exception) {
      throw Exception('接続に失敗しました: $exception');
    }
  }

  @override
  Future<void> disconnect() async {
    if (_connection != null) {
      await _connection!.close();
      _connectedDevice = null;
      _connection = null;
    }
  }

  @override
  bool get isConnected => _connectedDevice != null && _connection != null;

  @override
  String? get connectedDeviceName => _connectedDevice?.name;

  @override
  List<dynamic> get availableDevices => _devicesList;

  @override
  Stream<String> get dataStream => _dataController.stream;

  // 追加のgetterメソッド
  fbs.BluetoothDevice? get connectedDevice => _connectedDevice;

  void dispose() {
    _connection?.dispose();
    _dataController.close();
  }
}

class WebBluetoothManager implements BluetoothManager {
  List<fwb.BluetoothDevice> _webDevicesList = [];
  fwb.BluetoothDevice? _connectedWebDevice;

  final StreamController<String> _dataController =
      StreamController<String>.broadcast();

  @override
  Future<void> initialize() async {
    if (fwb.FlutterWebBluetooth.instance.isBluetoothApiSupported) {
      return;
    } else {
      throw Exception('Web Bluetooth API is not supported');
    }
  }

  @override
  Future<void> scanDevices() async {
    try {
      final device = await fwb.FlutterWebBluetooth.instance.requestDevice(
        fwb.RequestOptionsBuilder.acceptAllDevices(
          optionalServices: [dartsLiveHomeService],
        ),
      );

      _webDevicesList = [device];
    } catch (e) {
      throw Exception('デバイス検索に失敗しました: $e');
    }
  }

  @override
  Future<void> connectToDevice(dynamic device) async {
    if (device is! fwb.BluetoothDevice) return;

    try {
      await device.connect();
      _connectedWebDevice = device;

      final services = await device.discoverServices();
      final service = services.first;

      // キャラクタリスティックを取得
      final characteristic = await service.getCharacteristic(
        dartsLiveHomeCharacteristic,
      );
      await characteristic.startNotifications();
      characteristic.value.listen((value) {
        final list = value.buffer.asUint8List().toList();
        final receivedText = dat[list[2]];
        String timestampedData =
            '${DateTime.now().toString().substring(11, 19)}: $receivedText';
        _dataController.add(timestampedData);
      });

      // 接続完了メッセージ
      String timestampedData =
          '${DateTime.now().toString().substring(11, 19)}: Web接続完了';
      _dataController.add(timestampedData);
    } catch (e) {
      throw Exception('接続に失敗しました: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    if (_connectedWebDevice != null) {
      _connectedWebDevice!.disconnect();
      _connectedWebDevice = null;
    }
  }

  @override
  bool get isConnected => _connectedWebDevice != null;

  @override
  String? get connectedDeviceName => _connectedWebDevice?.name;

  @override
  List<dynamic> get availableDevices => _webDevicesList;

  @override
  Stream<String> get dataStream => _dataController.stream;

  // 追加のgetterメソッド
  fwb.BluetoothDevice? get connectedWebDevice => _connectedWebDevice;

  void dispose() {
    _dataController.close();
  }
}
