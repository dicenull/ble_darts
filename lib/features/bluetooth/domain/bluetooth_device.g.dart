// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bluetooth_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BluetoothDeviceInfoImpl _$$BluetoothDeviceInfoImplFromJson(
  Map<String, dynamic> json,
) => _$BluetoothDeviceInfoImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  isConnected: json['isConnected'] as bool? ?? false,
);

Map<String, dynamic> _$$BluetoothDeviceInfoImplToJson(
  _$BluetoothDeviceInfoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'isConnected': instance.isConnected,
};

_$BluetoothStateImpl _$$BluetoothStateImplFromJson(Map<String, dynamic> json) =>
    _$BluetoothStateImpl(
      connectionState:
          $enumDecodeNullable(
            _$BluetoothConnectionStateEnumMap,
            json['connectionState'],
          ) ??
          BluetoothConnectionState.disconnected,
      availableDevices:
          (json['availableDevices'] as List<dynamic>?)
              ?.map(
                (e) => BluetoothDeviceInfo.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      connectedDevice: json['connectedDevice'] == null
          ? null
          : BluetoothDeviceInfo.fromJson(
              json['connectedDevice'] as Map<String, dynamic>,
            ),
      receivedData:
          (json['receivedData'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$BluetoothStateImplToJson(
  _$BluetoothStateImpl instance,
) => <String, dynamic>{
  'connectionState':
      _$BluetoothConnectionStateEnumMap[instance.connectionState]!,
  'availableDevices': instance.availableDevices,
  'connectedDevice': instance.connectedDevice,
  'receivedData': instance.receivedData,
  'errorMessage': instance.errorMessage,
};

const _$BluetoothConnectionStateEnumMap = {
  BluetoothConnectionState.disconnected: 'disconnected',
  BluetoothConnectionState.connecting: 'connecting',
  BluetoothConnectionState.connected: 'connected',
  BluetoothConnectionState.error: 'error',
};
