import 'package:freezed_annotation/freezed_annotation.dart';

part 'dart_throw.freezed.dart';
part 'dart_throw.g.dart';

@freezed
class DartThrow with _$DartThrow {
  const factory DartThrow({
    required String position,
    required int score,
    required DateTime timestamp,
  }) = _DartThrow;

  factory DartThrow.fromJson(Map<String, dynamic> json) => _$DartThrowFromJson(json);
}

extension DartThrowX on DartThrow {
  static DartThrow fromDartsLiveData(String dartsLivePosition) {
    return DartThrow(
      position: dartsLivePosition,
      score: _calculateScore(dartsLivePosition),
      timestamp: DateTime.now(),
    );
  }

  static int _calculateScore(String position) {
    if (position == 'BULL') return 50;
    if (position == 'D-BULL') return 25;
    if (position == 'CHANGE') return 0;

    final regex = RegExp(r'([SDT])(\d+)');
    final match = regex.firstMatch(position);
    
    if (match == null) return 0;
    
    final multiplier = match.group(1);
    final number = int.parse(match.group(2)!);
    
    switch (multiplier) {
      case 'S':
        return number;
      case 'D':
        return number * 2;
      case 'T':
        return number * 3;
      default:
        return 0;
    }
  }
}