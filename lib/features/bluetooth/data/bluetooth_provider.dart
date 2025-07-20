import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:universal_platform/universal_platform.dart';
import '../../../bluetooth_manager.dart';
import '../domain/bluetooth_device.dart';

part 'bluetooth_provider.g.dart';

@riverpod
class BluetoothNotifier extends _$BluetoothNotifier {
  BluetoothManager? _bluetoothManager;

  @override
  BluetoothState build() {
    _initializeBluetooth();
    return const BluetoothState();
  }

  Future<void> _initializeBluetooth() async {
    try {
      _bluetoothManager = BluetoothManager();
      await _bluetoothManager!.initialize();

      _bluetoothManager!.dataStream.listen((data) {
        _onDataReceived(data);
      });

      state = state.copyWith(
        connectionState: BluetoothConnectionState.disconnected,
      );
    } catch (e) {
      state = state.copyWith(
        connectionState: BluetoothConnectionState.error,
        errorMessage: '初期化に失敗しました: $e',
      );
    }
  }

  void _onDataReceived(String data) {
    final updatedData = [...state.receivedData, data];
    state = state.copyWith(receivedData: updatedData);
  }

  Future<void> scanDevices() async {
    if (_bluetoothManager == null) return;

    try {
      await _bluetoothManager!.scanDevices();
      final devices = _bluetoothManager!.availableDevices.map((device) {
        return BluetoothDeviceInfo(
          id: UniversalPlatform.isWeb ? device.id : device.address,
          name: device.name ?? 'Unknown Device',
          address: UniversalPlatform.isWeb ? device.id : device.address,
        );
      }).toList();

      state = state.copyWith(availableDevices: devices);
    } catch (e) {
      state = state.copyWith(
        connectionState: BluetoothConnectionState.error,
        errorMessage: 'デバイス検索に失敗しました: $e',
      );
    }
  }

  Future<void> connectToDevice(BluetoothDeviceInfo deviceInfo) async {
    if (_bluetoothManager == null) return;

    try {
      state = state.copyWith(
        connectionState: BluetoothConnectionState.connecting,
      );

      final device = _bluetoothManager!.availableDevices.firstWhere(
        (device) =>
            (UniversalPlatform.isWeb ? device.id : device.address) ==
            deviceInfo.id,
      );

      await _bluetoothManager!.connectToDevice(device);

      state = state.copyWith(
        connectionState: BluetoothConnectionState.connected,
        connectedDevice: deviceInfo.copyWith(isConnected: true),
      );
    } catch (e) {
      state = state.copyWith(
        connectionState: BluetoothConnectionState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> disconnect() async {
    if (_bluetoothManager == null) return;

    try {
      await _bluetoothManager!.disconnect();
      state = state.copyWith(
        connectionState: BluetoothConnectionState.disconnected,
        connectedDevice: null,
        receivedData: [],
      );
    } catch (e) {
      state = state.copyWith(
        connectionState: BluetoothConnectionState.error,
        errorMessage: '切断に失敗しました: $e',
      );
    }
  }

  void clearData() {
    state = state.copyWith(receivedData: []);
  }

  Stream<String> get dataStream =>
      _bluetoothManager?.dataStream ?? const Stream.empty();
}
