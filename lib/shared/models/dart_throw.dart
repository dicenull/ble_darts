import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart_position.dart';

part 'dart_throw.freezed.dart';
part 'dart_throw.g.dart';

@freezed
class DartThrow with _$DartThrow {
  const DartThrow._();
  
  const factory DartThrow({
    required DartPosition position,
    required int score,
    required DateTime timestamp,
  }) = _DartThrow;

  factory DartThrow.fromJson(Map<String, dynamic> json) =>
      _$DartThrowFromJson(json);

  String get positionString => position.toDisplayString();
}

extension DartThrowX on DartThrow {
  static DartThrow fromDartsLiveData(String dartsLivePosition) {
    final position = DartPosition.fromDisplayString(dartsLivePosition);
    return DartThrow(
      position: position,
      score: position.score,
      timestamp: DateTime.now(),
    );
  }

  static DartThrow fromDataString(String dataString) {
    final position = DartPosition.fromDataString(dataString);
    return DartThrow(
      position: position,
      score: position.score,
      timestamp: DateTime.now(),
    );
  }
}
