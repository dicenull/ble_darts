import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../shared/models/dart_throw.dart';

part 'count_up_game.freezed.dart';
part 'count_up_game.g.dart';

enum GameState { waiting, playing, finished }

@freezed
class CountUpGame with _$CountUpGame {
  const factory CountUpGame({
    @Default(GameState.waiting) GameState state,
    @Default(1) int currentRound,
    @Default(1) int currentThrow,
    @Default(0) int totalScore,
    @Default([]) List<List<DartThrow>> rounds,
    DateTime? startTime,
    DateTime? endTime,
  }) = _CountUpGame;

  factory CountUpGame.fromJson(Map<String, dynamic> json) =>
      _$CountUpGameFromJson(json);
}

extension CountUpGameX on CountUpGame {
  static const int maxRounds = 8;
  static const int throwsPerRound = 3;

  bool get isGameActive => state == GameState.playing;
  bool get isGameFinished => state == GameState.finished;

  List<DartThrow> get currentRoundThrows =>
      rounds.length >= currentRound ? rounds[currentRound - 1] : [];

  List<int> get roundScores {
    return rounds.map((round) {
      return round.fold<int>(0, (sum, dart) => sum + dart.score);
    }).toList();
  }

  double get averageScore {
    if (rounds.isEmpty) return 0.0;
    final completedRounds = rounds.where((round) => round.isNotEmpty).length;
    return completedRounds > 0 ? totalScore / completedRounds : 0.0;
  }

  Duration? get gameDuration {
    if (startTime == null) return null;
    final endTime = this.endTime ?? DateTime.now();
    return endTime.difference(startTime!);
  }

  CountUpGame startGame() {
    final initialRounds = List.generate(maxRounds, (index) => <DartThrow>[]);
    return copyWith(
      state: GameState.playing,
      startTime: DateTime.now(),
      currentRound: 1,
      currentThrow: 1,
      totalScore: 0,
      rounds: initialRounds,
      endTime: null,
    );
  }

  CountUpGame addThrow(DartThrow dartThrow) {
    if (!isGameActive) return this;

    final updatedRounds = [...rounds];
    if (updatedRounds.length < currentRound) {
      updatedRounds.add([]);
    }

    updatedRounds[currentRound - 1] = [
      ...updatedRounds[currentRound - 1],
      dartThrow,
    ];
    final newTotalScore = totalScore + dartThrow.score;

    if (currentThrow < throwsPerRound) {
      return copyWith(
        rounds: updatedRounds,
        totalScore: newTotalScore,
        currentThrow: currentThrow + 1,
      );
    } else {
      if (currentRound < maxRounds) {
        return copyWith(
          rounds: updatedRounds,
          totalScore: newTotalScore,
          currentRound: currentRound + 1,
          currentThrow: 1,
        );
      } else {
        return copyWith(
          rounds: updatedRounds,
          totalScore: newTotalScore,
          state: GameState.finished,
          endTime: DateTime.now(),
        );
      }
    }
  }

  CountUpGame resetGame() {
    return const CountUpGame();
  }
}
