import 'package:flutter_test/flutter_test.dart';
import 'package:ble_darts/features/count_up/domain/count_up_game.dart';
import 'package:ble_darts/shared/models/dart_throw.dart';

void main() {
  group('CountUpGame', () {
    test('デフォルトのゲーム状態を作成できる', () {
      // Arrange & Act
      const game = CountUpGame();

      // Assert
      expect(game.state, equals(GameState.waiting));
      expect(game.currentRound, equals(1));
      expect(game.currentThrow, equals(1));
      expect(game.totalScore, equals(0));
      expect(game.rounds, isEmpty);
      expect(game.startTime, isNull);
      expect(game.endTime, isNull);
    });

    test('ゲームを正しく開始できる', () {
      // Arrange
      const game = CountUpGame();

      // Act
      final startedGame = game.startGame();

      // Assert
      expect(startedGame.state, equals(GameState.playing));
      expect(startedGame.currentRound, equals(1));
      expect(startedGame.currentThrow, equals(1));
      expect(startedGame.totalScore, equals(0));
      expect(startedGame.rounds.length, equals(8));
      expect(startedGame.startTime, isNotNull);
      expect(startedGame.endTime, isNull);
      expect(startedGame.isGameActive, isTrue);
      expect(startedGame.isGameFinished, isFalse);
    });

    test('第1ラウンドでスローを正しく追加できる', () {
      // Arrange
      const game = CountUpGame();
      final startedGame = game.startGame();
      final dartThrow = DartThrowX.fromDartsLiveData('S20');

      // Act
      final gameWithThrow = startedGame.addThrow(dartThrow);

      // Assert
      expect(gameWithThrow.totalScore, equals(20));
      expect(gameWithThrow.currentRound, equals(1));
      expect(gameWithThrow.currentThrow, equals(2));
      expect(gameWithThrow.rounds[0].length, equals(1));
      expect(gameWithThrow.rounds[0][0].score, equals(20));
    });

    test('3回のスロー後に次のラウンドに進むことができる', () {
      // Arrange
      const game = CountUpGame();
      var currentGame = game.startGame();

      // Act
      for (int i = 0; i < 3; i++) {
        final dartThrow = DartThrowX.fromDartsLiveData('S20');
        currentGame = currentGame.addThrow(dartThrow);
      }

      // Assert
      expect(currentGame.currentRound, equals(2));
      expect(currentGame.currentThrow, equals(1));
      expect(currentGame.totalScore, equals(60));
      expect(currentGame.rounds[0].length, equals(3));
    });

    test('8ラウンド（24スロー）後にゲームが終了する', () {
      // Arrange
      const game = CountUpGame();
      var currentGame = game.startGame();

      // Act
      for (int round = 0; round < 8; round++) {
        for (int throwInRound = 0; throwInRound < 3; throwInRound++) {
          final dartThrow = DartThrowX.fromDartsLiveData('S20');
          currentGame = currentGame.addThrow(dartThrow);
        }
      }

      // Assert
      expect(currentGame.state, equals(GameState.finished));
      expect(currentGame.isGameFinished, isTrue);
      expect(currentGame.isGameActive, isFalse);
      expect(currentGame.totalScore, equals(480)); // 20 * 24
      expect(currentGame.endTime, isNotNull);
    });

    test('ゲームがアクティブでないときはスローを追加しない', () {
      // Arrange
      const game = CountUpGame();
      final dartThrow = DartThrowX.fromDartsLiveData('S20');

      // Act
      final gameWithThrow = game.addThrow(dartThrow);

      // Assert
      expect(gameWithThrow.totalScore, equals(0));
      expect(gameWithThrow.currentRound, equals(1));
      expect(gameWithThrow.currentThrow, equals(1));
    });

    test('ラウンドスコアを正しく計算できる', () {
      const game = CountUpGame();
      var currentGame = game.startGame();

      // Round 1: S20, S15, S10 = 45
      currentGame = currentGame.addThrow(DartThrowX.fromDartsLiveData('S20'));
      currentGame = currentGame.addThrow(DartThrowX.fromDartsLiveData('S15'));
      currentGame = currentGame.addThrow(DartThrowX.fromDartsLiveData('S10'));

      // Round 2: T20, D20, S20 = 120
      currentGame = currentGame.addThrow(DartThrowX.fromDartsLiveData('T20'));
      currentGame = currentGame.addThrow(DartThrowX.fromDartsLiveData('D20'));
      currentGame = currentGame.addThrow(DartThrowX.fromDartsLiveData('S20'));

      final roundScores = currentGame.roundScores;
      expect(roundScores.length, equals(8));
      expect(roundScores[0], equals(45));
      expect(roundScores[1], equals(120));
      expect(roundScores[2], equals(0)); // empty round
    });

    test('平均スコアを正しく計算できる', () {
      const game = CountUpGame();
      var currentGame = game.startGame();

      // Round 1: 60 points
      for (int i = 0; i < 3; i++) {
        currentGame = currentGame.addThrow(DartThrowX.fromDartsLiveData('S20'));
      }

      // Round 2: 120 points
      for (int i = 0; i < 3; i++) {
        currentGame = currentGame.addThrow(DartThrowX.fromDartsLiveData('D20'));
      }

      expect(currentGame.averageScore, equals(90.0)); // (60 + 120) / 2
    });

    test('空のゲームでは平均スコア0を返す', () {
      const game = CountUpGame();
      expect(game.averageScore, equals(0.0));
    });

    test('ゲームを正しくリセットできる', () {
      const game = CountUpGame();
      var startedGame = game.startGame();
      startedGame = startedGame.addThrow(DartThrowX.fromDartsLiveData('S20'));

      final resetGame = startedGame.resetGame();

      expect(resetGame.state, equals(GameState.waiting));
      expect(resetGame.currentRound, equals(1));
      expect(resetGame.currentThrow, equals(1));
      expect(resetGame.totalScore, equals(0));
      expect(resetGame.rounds, isEmpty);
      expect(resetGame.startTime, isNull);
      expect(resetGame.endTime, isNull);
    });

    test('ゲーム時間を正しく計算できる', () {
      const game = CountUpGame();
      final startedGame = game.startGame();

      expect(startedGame.gameDuration, isNotNull);
      expect(startedGame.gameDuration!.inMilliseconds, greaterThanOrEqualTo(0));
    });

    test('未開始のゲームでは時間をnullで返す', () {
      const game = CountUpGame();
      expect(game.gameDuration, isNull);
    });

    test('現在のラウンドのスローを正しく取得できる', () {
      const game = CountUpGame();
      var currentGame = game.startGame();

      final dartThrow = DartThrowX.fromDartsLiveData('S20');
      currentGame = currentGame.addThrow(dartThrow);

      final currentRoundThrows = currentGame.currentRoundThrows;
      expect(currentRoundThrows.length, equals(1));
      expect(currentRoundThrows[0].score, equals(20));
    });

    test('高スコアゲームを正しく処理できる', () {
      const game = CountUpGame();
      var currentGame = game.startGame();

      // All triple 20s (perfect game)
      for (int round = 0; round < 8; round++) {
        for (int throwInRound = 0; throwInRound < 3; throwInRound++) {
          currentGame = currentGame.addThrow(
            DartThrowX.fromDartsLiveData('T20'),
          );
        }
      }

      expect(currentGame.totalScore, equals(1440)); // 60 * 24
      expect(currentGame.averageScore, equals(180.0)); // 60 * 3 per round
      expect(currentGame.isGameFinished, isTrue);
    });
  });
}
