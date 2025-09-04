// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dart_position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DartPosition _$DartPositionFromJson(Map<String, dynamic> json) {
  return _DartPosition.fromJson(json);
}

/// @nodoc
mixin _$DartPosition {
  int get number => throw _privateConstructorUsedError;
  DartRing get ring => throw _privateConstructorUsedError;
  DartArea? get area => throw _privateConstructorUsedError;

  /// Serializes this DartPosition to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DartPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DartPositionCopyWith<DartPosition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DartPositionCopyWith<$Res> {
  factory $DartPositionCopyWith(
    DartPosition value,
    $Res Function(DartPosition) then,
  ) = _$DartPositionCopyWithImpl<$Res, DartPosition>;
  @useResult
  $Res call({int number, DartRing ring, DartArea? area});
}

/// @nodoc
class _$DartPositionCopyWithImpl<$Res, $Val extends DartPosition>
    implements $DartPositionCopyWith<$Res> {
  _$DartPositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DartPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? ring = null,
    Object? area = freezed,
  }) {
    return _then(
      _value.copyWith(
            number: null == number
                ? _value.number
                : number // ignore: cast_nullable_to_non_nullable
                      as int,
            ring: null == ring
                ? _value.ring
                : ring // ignore: cast_nullable_to_non_nullable
                      as DartRing,
            area: freezed == area
                ? _value.area
                : area // ignore: cast_nullable_to_non_nullable
                      as DartArea?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DartPositionImplCopyWith<$Res>
    implements $DartPositionCopyWith<$Res> {
  factory _$$DartPositionImplCopyWith(
    _$DartPositionImpl value,
    $Res Function(_$DartPositionImpl) then,
  ) = __$$DartPositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int number, DartRing ring, DartArea? area});
}

/// @nodoc
class __$$DartPositionImplCopyWithImpl<$Res>
    extends _$DartPositionCopyWithImpl<$Res, _$DartPositionImpl>
    implements _$$DartPositionImplCopyWith<$Res> {
  __$$DartPositionImplCopyWithImpl(
    _$DartPositionImpl _value,
    $Res Function(_$DartPositionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DartPosition
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = null,
    Object? ring = null,
    Object? area = freezed,
  }) {
    return _then(
      _$DartPositionImpl(
        number: null == number
            ? _value.number
            : number // ignore: cast_nullable_to_non_nullable
                  as int,
        ring: null == ring
            ? _value.ring
            : ring // ignore: cast_nullable_to_non_nullable
                  as DartRing,
        area: freezed == area
            ? _value.area
            : area // ignore: cast_nullable_to_non_nullable
                  as DartArea?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DartPositionImpl extends _DartPosition {
  const _$DartPositionImpl({
    required this.number,
    required this.ring,
    this.area,
  }) : super._();

  factory _$DartPositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DartPositionImplFromJson(json);

  @override
  final int number;
  @override
  final DartRing ring;
  @override
  final DartArea? area;

  @override
  String toString() {
    return 'DartPosition(number: $number, ring: $ring, area: $area)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DartPositionImpl &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.ring, ring) || other.ring == ring) &&
            (identical(other.area, area) || other.area == area));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, number, ring, area);

  /// Create a copy of DartPosition
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DartPositionImplCopyWith<_$DartPositionImpl> get copyWith =>
      __$$DartPositionImplCopyWithImpl<_$DartPositionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DartPositionImplToJson(this);
  }
}

abstract class _DartPosition extends DartPosition {
  const factory _DartPosition({
    required final int number,
    required final DartRing ring,
    final DartArea? area,
  }) = _$DartPositionImpl;
  const _DartPosition._() : super._();

  factory _DartPosition.fromJson(Map<String, dynamic> json) =
      _$DartPositionImpl.fromJson;

  @override
  int get number;
  @override
  DartRing get ring;
  @override
  DartArea? get area;

  /// Create a copy of DartPosition
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DartPositionImplCopyWith<_$DartPositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
