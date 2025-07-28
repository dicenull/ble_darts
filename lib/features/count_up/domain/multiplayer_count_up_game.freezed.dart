// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'multiplayer_count_up_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlayerGameData _$PlayerGameDataFromJson(Map<String, dynamic> json) {
  return _PlayerGameData.fromJson(json);
}

/// @nodoc
mixin _$PlayerGameData {
  Player get player => throw _privateConstructorUsedError;
  CountUpGame get game => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;

  /// Serializes this PlayerGameData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayerGameData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayerGameDataCopyWith<PlayerGameData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerGameDataCopyWith<$Res> {
  factory $PlayerGameDataCopyWith(
    PlayerGameData value,
    $Res Function(PlayerGameData) then,
  ) = _$PlayerGameDataCopyWithImpl<$Res, PlayerGameData>;
  @useResult
  $Res call({Player player, CountUpGame game, bool isActive});

  $PlayerCopyWith<$Res> get player;
  $CountUpGameCopyWith<$Res> get game;
}

/// @nodoc
class _$PlayerGameDataCopyWithImpl<$Res, $Val extends PlayerGameData>
    implements $PlayerGameDataCopyWith<$Res> {
  _$PlayerGameDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayerGameData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? game = null,
    Object? isActive = null,
  }) {
    return _then(
      _value.copyWith(
            player: null == player
                ? _value.player
                : player // ignore: cast_nullable_to_non_nullable
                      as Player,
            game: null == game
                ? _value.game
                : game // ignore: cast_nullable_to_non_nullable
                      as CountUpGame,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of PlayerGameData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get player {
    return $PlayerCopyWith<$Res>(_value.player, (value) {
      return _then(_value.copyWith(player: value) as $Val);
    });
  }

  /// Create a copy of PlayerGameData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CountUpGameCopyWith<$Res> get game {
    return $CountUpGameCopyWith<$Res>(_value.game, (value) {
      return _then(_value.copyWith(game: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlayerGameDataImplCopyWith<$Res>
    implements $PlayerGameDataCopyWith<$Res> {
  factory _$$PlayerGameDataImplCopyWith(
    _$PlayerGameDataImpl value,
    $Res Function(_$PlayerGameDataImpl) then,
  ) = __$$PlayerGameDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Player player, CountUpGame game, bool isActive});

  @override
  $PlayerCopyWith<$Res> get player;
  @override
  $CountUpGameCopyWith<$Res> get game;
}

/// @nodoc
class __$$PlayerGameDataImplCopyWithImpl<$Res>
    extends _$PlayerGameDataCopyWithImpl<$Res, _$PlayerGameDataImpl>
    implements _$$PlayerGameDataImplCopyWith<$Res> {
  __$$PlayerGameDataImplCopyWithImpl(
    _$PlayerGameDataImpl _value,
    $Res Function(_$PlayerGameDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlayerGameData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? game = null,
    Object? isActive = null,
  }) {
    return _then(
      _$PlayerGameDataImpl(
        player: null == player
            ? _value.player
            : player // ignore: cast_nullable_to_non_nullable
                  as Player,
        game: null == game
            ? _value.game
            : game // ignore: cast_nullable_to_non_nullable
                  as CountUpGame,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayerGameDataImpl implements _PlayerGameData {
  const _$PlayerGameDataImpl({
    required this.player,
    required this.game,
    this.isActive = false,
  });

  factory _$PlayerGameDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayerGameDataImplFromJson(json);

  @override
  final Player player;
  @override
  final CountUpGame game;
  @override
  @JsonKey()
  final bool isActive;

  @override
  String toString() {
    return 'PlayerGameData(player: $player, game: $game, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayerGameDataImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.game, game) || other.game == game) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, player, game, isActive);

  /// Create a copy of PlayerGameData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayerGameDataImplCopyWith<_$PlayerGameDataImpl> get copyWith =>
      __$$PlayerGameDataImplCopyWithImpl<_$PlayerGameDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayerGameDataImplToJson(this);
  }
}

abstract class _PlayerGameData implements PlayerGameData {
  const factory _PlayerGameData({
    required final Player player,
    required final CountUpGame game,
    final bool isActive,
  }) = _$PlayerGameDataImpl;

  factory _PlayerGameData.fromJson(Map<String, dynamic> json) =
      _$PlayerGameDataImpl.fromJson;

  @override
  Player get player;
  @override
  CountUpGame get game;
  @override
  bool get isActive;

  /// Create a copy of PlayerGameData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayerGameDataImplCopyWith<_$PlayerGameDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MultiplayerCountUpGame _$MultiplayerCountUpGameFromJson(
  Map<String, dynamic> json,
) {
  return _MultiplayerCountUpGame.fromJson(json);
}

/// @nodoc
mixin _$MultiplayerCountUpGame {
  MultiplayerGameState get state => throw _privateConstructorUsedError;
  List<PlayerGameData> get players => throw _privateConstructorUsedError;
  int get currentPlayerIndex => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;

  /// Serializes this MultiplayerCountUpGame to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MultiplayerCountUpGame
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MultiplayerCountUpGameCopyWith<MultiplayerCountUpGame> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MultiplayerCountUpGameCopyWith<$Res> {
  factory $MultiplayerCountUpGameCopyWith(
    MultiplayerCountUpGame value,
    $Res Function(MultiplayerCountUpGame) then,
  ) = _$MultiplayerCountUpGameCopyWithImpl<$Res, MultiplayerCountUpGame>;
  @useResult
  $Res call({
    MultiplayerGameState state,
    List<PlayerGameData> players,
    int currentPlayerIndex,
    DateTime? startTime,
    DateTime? endTime,
  });
}

/// @nodoc
class _$MultiplayerCountUpGameCopyWithImpl<
  $Res,
  $Val extends MultiplayerCountUpGame
>
    implements $MultiplayerCountUpGameCopyWith<$Res> {
  _$MultiplayerCountUpGameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MultiplayerCountUpGame
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? players = null,
    Object? currentPlayerIndex = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            state: null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                      as MultiplayerGameState,
            players: null == players
                ? _value.players
                : players // ignore: cast_nullable_to_non_nullable
                      as List<PlayerGameData>,
            currentPlayerIndex: null == currentPlayerIndex
                ? _value.currentPlayerIndex
                : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
                      as int,
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
abstract class _$$MultiplayerCountUpGameImplCopyWith<$Res>
    implements $MultiplayerCountUpGameCopyWith<$Res> {
  factory _$$MultiplayerCountUpGameImplCopyWith(
    _$MultiplayerCountUpGameImpl value,
    $Res Function(_$MultiplayerCountUpGameImpl) then,
  ) = __$$MultiplayerCountUpGameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    MultiplayerGameState state,
    List<PlayerGameData> players,
    int currentPlayerIndex,
    DateTime? startTime,
    DateTime? endTime,
  });
}

/// @nodoc
class __$$MultiplayerCountUpGameImplCopyWithImpl<$Res>
    extends
        _$MultiplayerCountUpGameCopyWithImpl<$Res, _$MultiplayerCountUpGameImpl>
    implements _$$MultiplayerCountUpGameImplCopyWith<$Res> {
  __$$MultiplayerCountUpGameImplCopyWithImpl(
    _$MultiplayerCountUpGameImpl _value,
    $Res Function(_$MultiplayerCountUpGameImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MultiplayerCountUpGame
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? players = null,
    Object? currentPlayerIndex = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(
      _$MultiplayerCountUpGameImpl(
        state: null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as MultiplayerGameState,
        players: null == players
            ? _value._players
            : players // ignore: cast_nullable_to_non_nullable
                  as List<PlayerGameData>,
        currentPlayerIndex: null == currentPlayerIndex
            ? _value.currentPlayerIndex
            : currentPlayerIndex // ignore: cast_nullable_to_non_nullable
                  as int,
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
class _$MultiplayerCountUpGameImpl implements _MultiplayerCountUpGame {
  const _$MultiplayerCountUpGameImpl({
    this.state = MultiplayerGameState.setup,
    final List<PlayerGameData> players = const [],
    this.currentPlayerIndex = 0,
    this.startTime,
    this.endTime,
  }) : _players = players;

  factory _$MultiplayerCountUpGameImpl.fromJson(Map<String, dynamic> json) =>
      _$$MultiplayerCountUpGameImplFromJson(json);

  @override
  @JsonKey()
  final MultiplayerGameState state;
  final List<PlayerGameData> _players;
  @override
  @JsonKey()
  List<PlayerGameData> get players {
    if (_players is EqualUnmodifiableListView) return _players;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_players);
  }

  @override
  @JsonKey()
  final int currentPlayerIndex;
  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;

  @override
  String toString() {
    return 'MultiplayerCountUpGame(state: $state, players: $players, currentPlayerIndex: $currentPlayerIndex, startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MultiplayerCountUpGameImpl &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other._players, _players) &&
            (identical(other.currentPlayerIndex, currentPlayerIndex) ||
                other.currentPlayerIndex == currentPlayerIndex) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    state,
    const DeepCollectionEquality().hash(_players),
    currentPlayerIndex,
    startTime,
    endTime,
  );

  /// Create a copy of MultiplayerCountUpGame
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MultiplayerCountUpGameImplCopyWith<_$MultiplayerCountUpGameImpl>
  get copyWith =>
      __$$MultiplayerCountUpGameImplCopyWithImpl<_$MultiplayerCountUpGameImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MultiplayerCountUpGameImplToJson(this);
  }
}

abstract class _MultiplayerCountUpGame implements MultiplayerCountUpGame {
  const factory _MultiplayerCountUpGame({
    final MultiplayerGameState state,
    final List<PlayerGameData> players,
    final int currentPlayerIndex,
    final DateTime? startTime,
    final DateTime? endTime,
  }) = _$MultiplayerCountUpGameImpl;

  factory _MultiplayerCountUpGame.fromJson(Map<String, dynamic> json) =
      _$MultiplayerCountUpGameImpl.fromJson;

  @override
  MultiplayerGameState get state;
  @override
  List<PlayerGameData> get players;
  @override
  int get currentPlayerIndex;
  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;

  /// Create a copy of MultiplayerCountUpGame
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MultiplayerCountUpGameImplCopyWith<_$MultiplayerCountUpGameImpl>
  get copyWith => throw _privateConstructorUsedError;
}
