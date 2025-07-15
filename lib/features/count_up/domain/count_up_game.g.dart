// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_up_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CountUpGameImpl _$$CountUpGameImplFromJson(Map<String, dynamic> json) =>
    _$CountUpGameImpl(
      state:
          $enumDecodeNullable(_$GameStateEnumMap, json['state']) ??
          GameState.waiting,
      currentRound: (json['currentRound'] as num?)?.toInt() ?? 1,
      currentThrow: (json['currentThrow'] as num?)?.toInt() ?? 1,
      totalScore: (json['totalScore'] as num?)?.toInt() ?? 0,
      rounds:
          (json['rounds'] as List<dynamic>?)
              ?.map(
                (e) => (e as List<dynamic>)
                    .map((e) => DartThrow.fromJson(e as Map<String, dynamic>))
                    .toList(),
              )
              .toList() ??
          const [],
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$$CountUpGameImplToJson(_$CountUpGameImpl instance) =>
    <String, dynamic>{
      'state': _$GameStateEnumMap[instance.state]!,
      'currentRound': instance.currentRound,
      'currentThrow': instance.currentThrow,
      'totalScore': instance.totalScore,
      'rounds': instance.rounds,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
    };

const _$GameStateEnumMap = {
  GameState.waiting: 'waiting',
  GameState.playing: 'playing',
  GameState.finished: 'finished',
};
