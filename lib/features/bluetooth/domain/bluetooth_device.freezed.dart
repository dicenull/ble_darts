// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bluetooth_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BluetoothDeviceInfo _$BluetoothDeviceInfoFromJson(Map<String, dynamic> json) {
  return _BluetoothDeviceInfo.fromJson(json);
}

/// @nodoc
mixin _$BluetoothDeviceInfo {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;

  /// Serializes this BluetoothDeviceInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BluetoothDeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BluetoothDeviceInfoCopyWith<BluetoothDeviceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BluetoothDeviceInfoCopyWith<$Res> {
  factory $BluetoothDeviceInfoCopyWith(
    BluetoothDeviceInfo value,
    $Res Function(BluetoothDeviceInfo) then,
  ) = _$BluetoothDeviceInfoCopyWithImpl<$Res, BluetoothDeviceInfo>;
  @useResult
  $Res call({String id, String name, String address, bool isConnected});
}

/// @nodoc
class _$BluetoothDeviceInfoCopyWithImpl<$Res, $Val extends BluetoothDeviceInfo>
    implements $BluetoothDeviceInfoCopyWith<$Res> {
  _$BluetoothDeviceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BluetoothDeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? isConnected = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            isConnected: null == isConnected
                ? _value.isConnected
                : isConnected // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BluetoothDeviceInfoImplCopyWith<$Res>
    implements $BluetoothDeviceInfoCopyWith<$Res> {
  factory _$$BluetoothDeviceInfoImplCopyWith(
    _$BluetoothDeviceInfoImpl value,
    $Res Function(_$BluetoothDeviceInfoImpl) then,
  ) = __$$BluetoothDeviceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String address, bool isConnected});
}

/// @nodoc
class __$$BluetoothDeviceInfoImplCopyWithImpl<$Res>
    extends _$BluetoothDeviceInfoCopyWithImpl<$Res, _$BluetoothDeviceInfoImpl>
    implements _$$BluetoothDeviceInfoImplCopyWith<$Res> {
  __$$BluetoothDeviceInfoImplCopyWithImpl(
    _$BluetoothDeviceInfoImpl _value,
    $Res Function(_$BluetoothDeviceInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BluetoothDeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? isConnected = null,
  }) {
    return _then(
      _$BluetoothDeviceInfoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        isConnected: null == isConnected
            ? _value.isConnected
            : isConnected // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BluetoothDeviceInfoImpl implements _BluetoothDeviceInfo {
  const _$BluetoothDeviceInfoImpl({
    required this.id,
    required this.name,
    required this.address,
    this.isConnected = false,
  });

  factory _$BluetoothDeviceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BluetoothDeviceInfoImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String address;
  @override
  @JsonKey()
  final bool isConnected;

  @override
  String toString() {
    return 'BluetoothDeviceInfo(id: $id, name: $name, address: $address, isConnected: $isConnected)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BluetoothDeviceInfoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, address, isConnected);

  /// Create a copy of BluetoothDeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BluetoothDeviceInfoImplCopyWith<_$BluetoothDeviceInfoImpl> get copyWith =>
      __$$BluetoothDeviceInfoImplCopyWithImpl<_$BluetoothDeviceInfoImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BluetoothDeviceInfoImplToJson(this);
  }
}

abstract class _BluetoothDeviceInfo implements BluetoothDeviceInfo {
  const factory _BluetoothDeviceInfo({
    required final String id,
    required final String name,
    required final String address,
    final bool isConnected,
  }) = _$BluetoothDeviceInfoImpl;

  factory _BluetoothDeviceInfo.fromJson(Map<String, dynamic> json) =
      _$BluetoothDeviceInfoImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get address;
  @override
  bool get isConnected;

  /// Create a copy of BluetoothDeviceInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BluetoothDeviceInfoImplCopyWith<_$BluetoothDeviceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BluetoothState _$BluetoothStateFromJson(Map<String, dynamic> json) {
  return _BluetoothState.fromJson(json);
}

/// @nodoc
mixin _$BluetoothState {
  BluetoothConnectionState get connectionState =>
      throw _privateConstructorUsedError;
  List<BluetoothDeviceInfo> get availableDevices =>
      throw _privateConstructorUsedError;
  BluetoothDeviceInfo? get connectedDevice =>
      throw _privateConstructorUsedError;
  List<String> get receivedData => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this BluetoothState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BluetoothState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BluetoothStateCopyWith<BluetoothState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BluetoothStateCopyWith<$Res> {
  factory $BluetoothStateCopyWith(
    BluetoothState value,
    $Res Function(BluetoothState) then,
  ) = _$BluetoothStateCopyWithImpl<$Res, BluetoothState>;
  @useResult
  $Res call({
    BluetoothConnectionState connectionState,
    List<BluetoothDeviceInfo> availableDevices,
    BluetoothDeviceInfo? connectedDevice,
    List<String> receivedData,
    String? errorMessage,
  });

  $BluetoothDeviceInfoCopyWith<$Res>? get connectedDevice;
}

/// @nodoc
class _$BluetoothStateCopyWithImpl<$Res, $Val extends BluetoothState>
    implements $BluetoothStateCopyWith<$Res> {
  _$BluetoothStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BluetoothState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectionState = null,
    Object? availableDevices = null,
    Object? connectedDevice = freezed,
    Object? receivedData = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            connectionState: null == connectionState
                ? _value.connectionState
                : connectionState // ignore: cast_nullable_to_non_nullable
                      as BluetoothConnectionState,
            availableDevices: null == availableDevices
                ? _value.availableDevices
                : availableDevices // ignore: cast_nullable_to_non_nullable
                      as List<BluetoothDeviceInfo>,
            connectedDevice: freezed == connectedDevice
                ? _value.connectedDevice
                : connectedDevice // ignore: cast_nullable_to_non_nullable
                      as BluetoothDeviceInfo?,
            receivedData: null == receivedData
                ? _value.receivedData
                : receivedData // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of BluetoothState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BluetoothDeviceInfoCopyWith<$Res>? get connectedDevice {
    if (_value.connectedDevice == null) {
      return null;
    }

    return $BluetoothDeviceInfoCopyWith<$Res>(_value.connectedDevice!, (value) {
      return _then(_value.copyWith(connectedDevice: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BluetoothStateImplCopyWith<$Res>
    implements $BluetoothStateCopyWith<$Res> {
  factory _$$BluetoothStateImplCopyWith(
    _$BluetoothStateImpl value,
    $Res Function(_$BluetoothStateImpl) then,
  ) = __$$BluetoothStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    BluetoothConnectionState connectionState,
    List<BluetoothDeviceInfo> availableDevices,
    BluetoothDeviceInfo? connectedDevice,
    List<String> receivedData,
    String? errorMessage,
  });

  @override
  $BluetoothDeviceInfoCopyWith<$Res>? get connectedDevice;
}

/// @nodoc
class __$$BluetoothStateImplCopyWithImpl<$Res>
    extends _$BluetoothStateCopyWithImpl<$Res, _$BluetoothStateImpl>
    implements _$$BluetoothStateImplCopyWith<$Res> {
  __$$BluetoothStateImplCopyWithImpl(
    _$BluetoothStateImpl _value,
    $Res Function(_$BluetoothStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BluetoothState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectionState = null,
    Object? availableDevices = null,
    Object? connectedDevice = freezed,
    Object? receivedData = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$BluetoothStateImpl(
        connectionState: null == connectionState
            ? _value.connectionState
            : connectionState // ignore: cast_nullable_to_non_nullable
                  as BluetoothConnectionState,
        availableDevices: null == availableDevices
            ? _value._availableDevices
            : availableDevices // ignore: cast_nullable_to_non_nullable
                  as List<BluetoothDeviceInfo>,
        connectedDevice: freezed == connectedDevice
            ? _value.connectedDevice
            : connectedDevice // ignore: cast_nullable_to_non_nullable
                  as BluetoothDeviceInfo?,
        receivedData: null == receivedData
            ? _value._receivedData
            : receivedData // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BluetoothStateImpl implements _BluetoothState {
  const _$BluetoothStateImpl({
    this.connectionState = BluetoothConnectionState.disconnected,
    final List<BluetoothDeviceInfo> availableDevices = const [],
    this.connectedDevice,
    final List<String> receivedData = const [],
    this.errorMessage,
  }) : _availableDevices = availableDevices,
       _receivedData = receivedData;

  factory _$BluetoothStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$BluetoothStateImplFromJson(json);

  @override
  @JsonKey()
  final BluetoothConnectionState connectionState;
  final List<BluetoothDeviceInfo> _availableDevices;
  @override
  @JsonKey()
  List<BluetoothDeviceInfo> get availableDevices {
    if (_availableDevices is EqualUnmodifiableListView)
      return _availableDevices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableDevices);
  }

  @override
  final BluetoothDeviceInfo? connectedDevice;
  final List<String> _receivedData;
  @override
  @JsonKey()
  List<String> get receivedData {
    if (_receivedData is EqualUnmodifiableListView) return _receivedData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_receivedData);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'BluetoothState(connectionState: $connectionState, availableDevices: $availableDevices, connectedDevice: $connectedDevice, receivedData: $receivedData, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BluetoothStateImpl &&
            (identical(other.connectionState, connectionState) ||
                other.connectionState == connectionState) &&
            const DeepCollectionEquality().equals(
              other._availableDevices,
              _availableDevices,
            ) &&
            (identical(other.connectedDevice, connectedDevice) ||
                other.connectedDevice == connectedDevice) &&
            const DeepCollectionEquality().equals(
              other._receivedData,
              _receivedData,
            ) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    connectionState,
    const DeepCollectionEquality().hash(_availableDevices),
    connectedDevice,
    const DeepCollectionEquality().hash(_receivedData),
    errorMessage,
  );

  /// Create a copy of BluetoothState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BluetoothStateImplCopyWith<_$BluetoothStateImpl> get copyWith =>
      __$$BluetoothStateImplCopyWithImpl<_$BluetoothStateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BluetoothStateImplToJson(this);
  }
}

abstract class _BluetoothState implements BluetoothState {
  const factory _BluetoothState({
    final BluetoothConnectionState connectionState,
    final List<BluetoothDeviceInfo> availableDevices,
    final BluetoothDeviceInfo? connectedDevice,
    final List<String> receivedData,
    final String? errorMessage,
  }) = _$BluetoothStateImpl;

  factory _BluetoothState.fromJson(Map<String, dynamic> json) =
      _$BluetoothStateImpl.fromJson;

  @override
  BluetoothConnectionState get connectionState;
  @override
  List<BluetoothDeviceInfo> get availableDevices;
  @override
  BluetoothDeviceInfo? get connectedDevice;
  @override
  List<String> get receivedData;
  @override
  String? get errorMessage;

  /// Create a copy of BluetoothState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BluetoothStateImplCopyWith<_$BluetoothStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
