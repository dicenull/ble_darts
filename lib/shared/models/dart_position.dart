import 'package:freezed_annotation/freezed_annotation.dart';

part 'dart_position.freezed.dart';
part 'dart_position.g.dart';

enum DartRing {
  single,
  double,
  triple,
}

enum DartArea {
  inner,
  outer,
}

@freezed
class DartPosition with _$DartPosition {
  const DartPosition._();
  
  const factory DartPosition({
    required int number,
    required DartRing ring,
    DartArea? area,
  }) = _DartPosition;

  factory DartPosition.fromJson(Map<String, dynamic> json) =>
      _$DartPositionFromJson(json);

  String toDataString() {
    // 0はデバイスからの"CHANGE"を表しスコア0扱い
    if (number == 0) {
      return 'CHANGE';
    }
    if (number == 25) {
      return ring == DartRing.double ? 'D-BULL' : 'S-BULL';
    }

    return switch (ring) {
      DartRing.single => area == DartArea.inner
          ? 'S${number}_I'
          : 'S${number}_O',
      DartRing.double => 'D$number',
      DartRing.triple => 'T$number',
    };
  }

  String toDisplayString() {
    // 表示用も0は特殊値として"CHANGE"を返す
    if (number == 0) {
      return 'CHANGE';
    }
    if (number == 25) {
      return ring == DartRing.double ? 'D-BULL' : 'S-BULL';
    }
    final prefix = switch (ring) {
      DartRing.single => 'S',
      DartRing.double => 'D',
      DartRing.triple => 'T',
    };
    return '$prefix$number';
  }

  factory DartPosition.fromDataString(String str) {
    if (str == 'D-BULL') {
      return DartPosition(number: 25, ring: DartRing.double);
    }
    if (str == 'S-BULL') {
      return DartPosition(number: 25, ring: DartRing.single);
    }
    if (str == 'CHANGE') {
      return DartPosition(number: 0, ring: DartRing.single);
    }

    final regex = RegExp(r'([SDT])(\d+)(_[IO])?');
    final match = regex.firstMatch(str);
    if (match == null) throw FormatException('Invalid dart position: $str');

    final type = match.group(1);
    final number = int.parse(match.group(2)!);
    final areaStr = match.group(3);

    return DartPosition(
      number: number,
      ring: type == 'S'
          ? DartRing.single
          : type == 'D'
              ? DartRing.double
              : DartRing.triple,
      area: areaStr == '_I'
          ? DartArea.inner
          : areaStr == '_O'
              ? DartArea.outer
              : null,
    );
  }

  factory DartPosition.fromDisplayString(String str) {
    if (str == 'D-BULL') {
      return DartPosition(number: 25, ring: DartRing.double);
    }
    if (str == 'S-BULL') {
      return DartPosition(number: 25, ring: DartRing.single);
    }
    if (str == 'CHANGE') {
      return DartPosition(number: 0, ring: DartRing.single);
    }

    final regex = RegExp(r'([SDT])(\d+)');
    final match = regex.firstMatch(str);
    if (match == null) throw FormatException('Invalid dart position: $str');

    final type = match.group(1);
    final number = int.parse(match.group(2)!);

    return DartPosition(
      number: number,
      ring: type == 'S'
          ? DartRing.single
          : type == 'D'
              ? DartRing.double
              : DartRing.triple,
    );
  }

  int get score {
    if (number == 0) return 0;
    return switch (ring) {
      DartRing.single => number,
      DartRing.double => number == 25 ? 50 : number * 2,
      DartRing.triple => number * 3,
    };
  }
}