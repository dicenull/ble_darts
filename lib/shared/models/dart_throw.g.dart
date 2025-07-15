// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dart_throw.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DartThrowImpl _$$DartThrowImplFromJson(Map<String, dynamic> json) =>
    _$DartThrowImpl(
      position: json['position'] as String,
      score: (json['score'] as num).toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$DartThrowImplToJson(_$DartThrowImpl instance) =>
    <String, dynamic>{
      'position': instance.position,
      'score': instance.score,
      'timestamp': instance.timestamp.toIso8601String(),
    };
