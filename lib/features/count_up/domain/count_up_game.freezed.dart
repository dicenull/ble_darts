// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'count_up_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CountUpGame _$CountUpGameFromJson(Map<String, dynamic> json) {
  return _CountUpGame.fromJson(json);
}

/// @nodoc
mixin _$CountUpGame {
  GameState get state => throw _privateConstructorUsedError;
  int get currentRound => throw _privateConstructorUsedError;
  int get currentThrow => throw _privateConstructorUsedError;
  int get totalScore => throw _privateConstructorUsedError;
  List<List<DartThrow>> get rounds => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;

  /// Serializes this CountUpGame to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CountUpGame
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CountUpGameCopyWith<CountUpGame> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CountUpGameCopyWith<$Res> {
  factory $CountUpGameCopyWith(
    CountUpGame value,
    $Res Function(CountUpGame) then,
  ) = _$CountUpGameCopyWithImpl<$Res, CountUpGame>;
  @useResult
  $Res call({
    GameState state,
    int currentRound,
    int currentThrow,
    int totalScore,
    List<List<DartThrow>> rounds,
    DateTime? startTime,
    DateTime? endTime,
  });
}

/// @nodoc
class _$CountUpGameCopyWithImpl<$Res, $Val extends CountUpGame>
    implements $CountUpGameCopyWith<$Res> {
  _$CountUpGameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CountUpGame
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? currentRound = null,
    Object? currentThrow = null,
    Object? totalScore = null,
    Object? rounds = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as GameState,
            currentRound: null == currentRound
                ? _value.currentRound
                : currentRound // ignore: cast_nullable_to_non_nullable
                      as int,
            currentThrow: null == currentThrow
                ? _value.currentThrow
                : currentThrow // ignore: cast_nullable_to_non_nullable
                      as int,
            totalScore: null == totalScore
                ? _value.totalScore
                : totalScore // ignore: cast_nullable_to_non_nullable
                      as int,
            rounds: null == rounds
                ? _value.rounds
                : rounds // ignore: cast_nullable_to_non_nullable
                      as List<List<DartThrow>>,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CountUpGameImplCopyWith<$Res>
    implements $CountUpGameCopyWith<$Res> {
  factory _$$CountUpGameImplCopyWith(
    _$CountUpGameImpl value,
    $Res Function(_$CountUpGameImpl) then,
  ) = __$$CountUpGameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    GameState state,
    int currentRound,
    int currentThrow,
    int totalScore,
    List<List<DartThrow>> rounds,
    DateTime? startTime,
    DateTime? endTime,
  });
}

/// @nodoc
class __$$CountUpGameImplCopyWithImpl<$Res>
    extends _$CountUpGameCopyWithImpl<$Res, _$CountUpGameImpl>
    implements _$$CountUpGameImplCopyWith<$Res> {
  __$$CountUpGameImplCopyWithImpl(
    _$CountUpGameImpl _value,
    $Res Function(_$CountUpGameImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CountUpGame
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? currentRound = null,
    Object? currentThrow = null,
    Object? totalScore = null,
    Object? rounds = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(
      _$CountUpGameImpl(
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as GameState,
        currentRound: null == currentRound
            ? _value.currentRound
            : currentRound // ignore: cast_nullable_to_non_nullable
                  as int,
        currentThrow: null == currentThrow
            ? _value.currentThrow
            : currentThrow // ignore: cast_nullable_to_non_nullable
                  as int,
        totalScore: null == totalScore
            ? _value.totalScore
            : totalScore // ignore: cast_nullable_to_non_nullable
                  as int,
        rounds: null == rounds
            ? _value._rounds
            : rounds // ignore: cast_nullable_to_non_nullable
                  as List<List<DartThrow>>,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CountUpGameImpl implements _CountUpGame {
  const _$CountUpGameImpl({
    this.state = GameState.waiting,
    this.currentRound = 1,
    this.currentThrow = 1,
    this.totalScore = 0,
    final List<List<DartThrow>> rounds = const [],
    this.startTime,
    this.endTime,
  }) : _rounds = rounds;

  factory _$CountUpGameImpl.fromJson(Map<String, dynamic> json) =>
      _$$CountUpGameImplFromJson(json);

  @override
  @JsonKey()
  final GameState state;
  @override
  @JsonKey()
  final int currentRound;
  @override
  @JsonKey()
  final int currentThrow;
  @override
  @JsonKey()
  final int totalScore;
  final List<List<DartThrow>> _rounds;
  @override
  @JsonKey()
  List<List<DartThrow>> get rounds {
    if (_rounds is EqualUnmodifiableListView) return _rounds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rounds);
  }

  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;

  @override
  String toString() {
    return 'CountUpGame(state: $state, currentRound: $currentRound, currentThrow: $currentThrow, totalScore: $totalScore, rounds: $rounds, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CountUpGameImpl &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.currentRound, currentRound) ||
                other.currentRound == currentRound) &&
            (identical(other.currentThrow, currentThrow) ||
                other.currentThrow == currentThrow) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            const DeepCollectionEquality().equals(other._rounds, _rounds) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    state,
    currentRound,
    currentThrow,
    totalScore,
    const DeepCollectionEquality().hash(_rounds),
    startTime,
    endTime,
  );

  /// Create a copy of CountUpGame
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CountUpGameImplCopyWith<_$CountUpGameImpl> get copyWith =>
      __$$CountUpGameImplCopyWithImpl<_$CountUpGameImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CountUpGameImplToJson(this);
  }
}

abstract class _CountUpGame implements CountUpGame {
  const factory _CountUpGame({
    final GameState state,
    final int currentRound,
    final int currentThrow,
    final int totalScore,
    final List<List<DartThrow>> rounds,
    final DateTime? startTime,
    final DateTime? endTime,
  }) = _$CountUpGameImpl;

  factory _CountUpGame.fromJson(Map<String, dynamic> json) =
      _$CountUpGameImpl.fromJson;

  @override
  GameState get state;
  @override
  int get currentRound;
  @override
  int get currentThrow;
  @override
  int get totalScore;
  @override
  List<List<DartThrow>> get rounds;
  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;

  /// Create a copy of CountUpGame
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CountUpGameImplCopyWith<_$CountUpGameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
