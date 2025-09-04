// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dart_position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DartPositionImpl _$$DartPositionImplFromJson(Map<String, dynamic> json) =>
    _$DartPositionImpl(
      number: (json['number'] as num).toInt(),
      ring: $enumDecode(_$DartRingEnumMap, json['ring']),
      area: $enumDecodeNullable(_$DartAreaEnumMap, json['area']),
    );

Map<String, dynamic> _$$DartPositionImplToJson(_$DartPositionImpl instance) =>
    <String, dynamic>{
      'number': instance.number,
      'ring': _$DartRingEnumMap[instance.ring]!,
      'area': _$DartAreaEnumMap[instance.area],
    };

const _$DartRingEnumMap = {
  DartRing.single: 'single',
  DartRing.double: 'double',
  DartRing.triple: 'triple',
};

const _$DartAreaEnumMap = {DartArea.inner: 'inner', DartArea.outer: 'outer'};
