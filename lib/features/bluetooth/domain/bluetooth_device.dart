import 'package:freezed_annotation/freezed_annotation.dart';

part 'bluetooth_device.freezed.dart';
part 'bluetooth_device.g.dart';

@freezed
class BluetoothDeviceInfo with _$BluetoothDeviceInfo {
  const factory BluetoothDeviceInfo({
    required String id,
    required String name,
    required String address,
    @Default(false) bool isConnected,
  }) = _BluetoothDeviceInfo;

  factory BluetoothDeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$BluetoothDeviceInfoFromJson(json);
}

enum BluetoothConnectionState { disconnected, connecting, connected, error }

@freezed
class BluetoothState with _$BluetoothState {
  const factory BluetoothState({
    @Default(BluetoothConnectionState.disconnected)
    BluetoothConnectionState connectionState,
    @Default([]) List<BluetoothDeviceInfo> availableDevices,
    BluetoothDeviceInfo? connectedDevice,
    @Default([]) List<String> receivedData,
    String? errorMessage,
  }) = _BluetoothState;

  factory BluetoothState.fromJson(Map<String, dynamic> json) =>
      _$BluetoothStateFromJson(json);
}

extension BluetoothStateX on BluetoothState {
  bool get isConnected => connectionState == BluetoothConnectionState.connected;
  String? get connectedDeviceName => connectedDevice?.name;
}
