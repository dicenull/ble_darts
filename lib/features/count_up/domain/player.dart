import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player with _$Player {
  const factory Player({
    required String id,
    required String name,
    @Default(0) int totalScore,
    @Default(0) int gamesPlayed,
    @Default(0) int gamesWon,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}

extension PlayerX on Player {
  double get winRate => gamesPlayed > 0 ? gamesWon / gamesPlayed : 0.0;

  double get averageScore => gamesPlayed > 0 ? totalScore / gamesPlayed : 0.0;

  Player updateAfterGame({required int gameScore, required bool isWinner}) {
    return copyWith(
      totalScore: totalScore + gameScore,
      gamesPlayed: gamesPlayed + 1,
      gamesWon: isWinner ? gamesWon + 1 : gamesWon,
    );
  }
}
