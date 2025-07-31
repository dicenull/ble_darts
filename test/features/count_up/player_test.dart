import 'package:flutter_test/flutter_test.dart';
import 'package:ble_darts/features/count_up/domain/player.dart';

void main() {
  group('Player', () {
    test('デフォルトの値でPlayerを作成できる', () {
      // Arrange & Act
      const player = Player(id: 'test-id', name: 'Test Player');

      // Assert
      expect(player.id, equals('test-id'));
      expect(player.name, equals('Test Player'));
      expect(player.totalScore, equals(0));
      expect(player.gamesPlayed, equals(0));
      expect(player.gamesWon, equals(0));
    });

    test('カスタム統計でPlayerを作成できる', () {
      // Arrange & Act
      const player = Player(
        id: 'test-id',
        name: 'Test Player',
        totalScore: 500,
        gamesPlayed: 10,
        gamesWon: 3,
      );

      // Assert
      expect(player.id, equals('test-id'));
      expect(player.name, equals('Test Player'));
      expect(player.totalScore, equals(500));
      expect(player.gamesPlayed, equals(10));
      expect(player.gamesWon, equals(3));
    });

    test('勝率を正しく計算できる', () {
      // Arrange
      const player = Player(
        id: 'test-id',
        name: 'Test Player',
        gamesPlayed: 10,
        gamesWon: 3,
      );

      // Act
      final winRate = player.winRate;

      // Assert
      expect(winRate, equals(0.3));
    });

    test('ゲームをプレイしていない場合は勝率0を返す', () {
      // Arrange
      const player = Player(
        id: 'test-id',
        name: 'Test Player',
        gamesPlayed: 0,
        gamesWon: 0,
      );

      // Act
      final winRate = player.winRate;

      // Assert
      expect(winRate, equals(0.0));
    });

    test('平均スコアを正しく計算できる', () {
      // Arrange
      const player = Player(
        id: 'test-id',
        name: 'Test Player',
        totalScore: 1500,
        gamesPlayed: 10,
      );

      // Act
      final averageScore = player.averageScore;

      // Assert
      expect(averageScore, equals(150.0));
    });

    test('ゲームをプレイしていない場合は平均スコア0を返す', () {
      // Arrange
      const player = Player(
        id: 'test-id',
        name: 'Test Player',
        totalScore: 0,
        gamesPlayed: 0,
      );

      // Act
      final averageScore = player.averageScore;

      // Assert
      expect(averageScore, equals(0.0));
    });

    test('ゲーム後の統計を更新できる（勝利）', () {
      // Arrange
      const originalPlayer = Player(
        id: 'test-id',
        name: 'Test Player',
        totalScore: 100,
        gamesPlayed: 1,
        gamesWon: 0,
      );

      // Act
      final updatedPlayer = originalPlayer.updateAfterGame(
        gameScore: 200,
        isWinner: true,
      );

      // Assert
      expect(updatedPlayer.id, equals('test-id'));
      expect(updatedPlayer.name, equals('Test Player'));
      expect(updatedPlayer.totalScore, equals(300)); // 100 + 200
      expect(updatedPlayer.gamesPlayed, equals(2)); // 1 + 1
      expect(updatedPlayer.gamesWon, equals(1)); // 0 + 1 (won)
    });

    test('ゲーム後の統計を更新できる（敗北）', () {
      // Arrange
      const originalPlayer = Player(
        id: 'test-id',
        name: 'Test Player',
        totalScore: 100,
        gamesPlayed: 1,
        gamesWon: 1,
      );

      // Act
      final updatedPlayer = originalPlayer.updateAfterGame(
        gameScore: 150,
        isWinner: false,
      );

      // Assert
      expect(updatedPlayer.totalScore, equals(250)); // 100 + 150
      expect(updatedPlayer.gamesPlayed, equals(2)); // 1 + 1
      expect(updatedPlayer.gamesWon, equals(1)); // 1 + 0 (lost)
    });

    test('copyWithで部分的な更新ができる', () {
      // Arrange
      const originalPlayer = Player(
        id: 'test-id',
        name: 'Original Name',
        totalScore: 100,
        gamesPlayed: 5,
        gamesWon: 2,
      );

      // Act
      final updatedPlayer = originalPlayer.copyWith(
        name: 'Updated Name',
        totalScore: 200,
      );

      // Assert
      expect(updatedPlayer.id, equals('test-id')); // 変更されない
      expect(updatedPlayer.name, equals('Updated Name')); // 更新される
      expect(updatedPlayer.totalScore, equals(200)); // 更新される
      expect(updatedPlayer.gamesPlayed, equals(5)); // 変更されない
      expect(updatedPlayer.gamesWon, equals(2)); // 変更されない
    });

    test('同じ内容のPlayerは等価である', () {
      // Arrange
      const player1 = Player(
        id: 'test-id',
        name: 'Test Player',
        totalScore: 100,
        gamesPlayed: 5,
        gamesWon: 2,
      );

      const player2 = Player(
        id: 'test-id',
        name: 'Test Player',
        totalScore: 100,
        gamesPlayed: 5,
        gamesWon: 2,
      );

      // Act & Assert
      expect(player1, equals(player2));
      expect(player1.hashCode, equals(player2.hashCode));
    });

    test('異なる内容のPlayerは等価でない', () {
      // Arrange
      const player1 = Player(id: 'test-id-1', name: 'Test Player');

      const player2 = Player(id: 'test-id-2', name: 'Test Player');

      // Act & Assert
      expect(player1, isNot(equals(player2)));
    });
  });
}
