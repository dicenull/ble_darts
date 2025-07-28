// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerImpl _$$PlayerImplFromJson(Map<String, dynamic> json) => _$PlayerImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  totalScore: (json['totalScore'] as num?)?.toInt() ?? 0,
  gamesPlayed: (json['gamesPlayed'] as num?)?.toInt() ?? 0,
  gamesWon: (json['gamesWon'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$PlayerImplToJson(_$PlayerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'totalScore': instance.totalScore,
      'gamesPlayed': instance.gamesPlayed,
      'gamesWon': instance.gamesWon,
    };
