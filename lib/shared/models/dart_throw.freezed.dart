// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dart_throw.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DartThrow _$DartThrowFromJson(Map<String, dynamic> json) {
  return _DartThrow.fromJson(json);
}

/// @nodoc
mixin _$DartThrow {
  String get position => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this DartThrow to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DartThrow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DartThrowCopyWith<DartThrow> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DartThrowCopyWith<$Res> {
  factory $DartThrowCopyWith(DartThrow value, $Res Function(DartThrow) then) =
      _$DartThrowCopyWithImpl<$Res, DartThrow>;
  @useResult
  $Res call({String position, int score, DateTime timestamp});
}

/// @nodoc
class _$DartThrowCopyWithImpl<$Res, $Val extends DartThrow>
    implements $DartThrowCopyWith<$Res> {
  _$DartThrowCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DartThrow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? score = null,
    Object? timestamp = null,
  }) {
    return _then(
      _value.copyWith(
            position: null == position
                ? _value.position
                : position // ignore: cast_nullable_to_non_nullable
                      as String,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as int,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DartThrowImplCopyWith<$Res>
    implements $DartThrowCopyWith<$Res> {
  factory _$$DartThrowImplCopyWith(
    _$DartThrowImpl value,
    $Res Function(_$DartThrowImpl) then,
  ) = __$$DartThrowImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String position, int score, DateTime timestamp});
}

/// @nodoc
class __$$DartThrowImplCopyWithImpl<$Res>
    extends _$DartThrowCopyWithImpl<$Res, _$DartThrowImpl>
    implements _$$DartThrowImplCopyWith<$Res> {
  __$$DartThrowImplCopyWithImpl(
    _$DartThrowImpl _value,
    $Res Function(_$DartThrowImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DartThrow
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? score = null,
    Object? timestamp = null,
  }) {
    return _then(
      _$DartThrowImpl(
        position: null == position
            ? _value.position
            : position // ignore: cast_nullable_to_non_nullable
                  as String,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DartThrowImpl implements _DartThrow {
  const _$DartThrowImpl({
    required this.position,
    required this.score,
    required this.timestamp,
  });

  factory _$DartThrowImpl.fromJson(Map<String, dynamic> json) =>
      _$$DartThrowImplFromJson(json);

  @override
  final String position;
  @override
  final int score;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'DartThrow(position: $position, score: $score, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DartThrowImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, position, score, timestamp);

  /// Create a copy of DartThrow
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DartThrowImplCopyWith<_$DartThrowImpl> get copyWith =>
      __$$DartThrowImplCopyWithImpl<_$DartThrowImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DartThrowImplToJson(this);
  }
}

abstract class _DartThrow implements DartThrow {
  const factory _DartThrow({
    required final String position,
    required final int score,
    required final DateTime timestamp,
  }) = _$DartThrowImpl;

  factory _DartThrow.fromJson(Map<String, dynamic> json) =
      _$DartThrowImpl.fromJson;

  @override
  String get position;
  @override
  int get score;
  @override
  DateTime get timestamp;

  /// Create a copy of DartThrow
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DartThrowImplCopyWith<_$DartThrowImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
