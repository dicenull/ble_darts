// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiplayer_count_up_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerGameDataImpl _$$PlayerGameDataImplFromJson(Map<String, dynamic> json) =>
    _$PlayerGameDataImpl(
      player: Player.fromJson(json['player'] as Map<String, dynamic>),
      game: CountUpGame.fromJson(json['game'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool? ?? false,
    );

Map<String, dynamic> _$$PlayerGameDataImplToJson(
  _$PlayerGameDataImpl instance,
) => <String, dynamic>{
  'player': instance.player,
  'game': instance.game,
  'isActive': instance.isActive,
};

_$MultiplayerCountUpGameImpl _$$MultiplayerCountUpGameImplFromJson(
  Map<String, dynamic> json,
) => _$MultiplayerCountUpGameImpl(
  state:
      $enumDecodeNullable(_$MultiplayerGameStateEnumMap, json['state']) ??
      MultiplayerGameState.setup,
  players:
      (json['players'] as List<dynamic>?)
          ?.map((e) => PlayerGameData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  currentPlayerIndex: (json['currentPlayerIndex'] as num?)?.toInt() ?? 0,
  startTime: json['startTime'] == null
      ? null
      : DateTime.parse(json['startTime'] as String),
  endTime: json['endTime'] == null
      ? null
      : DateTime.parse(json['endTime'] as String),
);

Map<String, dynamic> _$$MultiplayerCountUpGameImplToJson(
  _$MultiplayerCountUpGameImpl instance,
) => <String, dynamic>{
  'state': _$MultiplayerGameStateEnumMap[instance.state]!,
  'players': instance.players,
  'currentPlayerIndex': instance.currentPlayerIndex,
  'startTime': instance.startTime?.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
};

const _$MultiplayerGameStateEnumMap = {
  MultiplayerGameState.setup: 'setup',
  MultiplayerGameState.playing: 'playing',
  MultiplayerGameState.finished: 'finished',
};
