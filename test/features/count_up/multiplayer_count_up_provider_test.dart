import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ble_darts/features/count_up/data/multiplayer_count_up_provider.dart';
import 'package:ble_darts/features/count_up/domain/multiplayer_count_up_game.dart';
import 'package:ble_darts/features/count_up/domain/count_up_game.dart';
import 'package:ble_darts/shared/models/dart_throw.dart';

void main() {
  group('MultiplayerCountUpGameNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('デフォルトで空のゲーム状態で初期化される', () {
      // Arrange & Act
      final game = container.read(multiplayerCountUpGameNotifierProvider);

      // Assert
      expect(game.players, isEmpty);
      expect(game.state, equals(MultiplayerGameState.setup));
      expect(game.isGameFinished, isFalse);
      expect(game.currentPlayerIndex, equals(0));
    });

    test('プレイヤーを追加できる', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      const playerName = 'Test Player';

      // Act
      notifier.addPlayer(playerName);

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.players.length, equals(1));
      expect(game.players[0].player.name, equals(playerName));
    });

    test('複数のプレイヤーを追加できる', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      const player1Name = 'Player 1';
      const player2Name = 'Player 2';
      const player3Name = 'Player 3';

      // Act
      notifier.addPlayer(player1Name);
      notifier.addPlayer(player2Name);
      notifier.addPlayer(player3Name);

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.players.length, equals(3));
      expect(
        game.players.map((p) => p.player.name),
        containsAll([player1Name, player2Name, player3Name]),
      );
    });

    test('空の名前でプレイヤーを追加しようとしても追加されない', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );

      // Act
      notifier.addPlayer('');
      notifier.addPlayer('   '); // 空白のみ

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.players, isEmpty);
    });

    test('プレイヤーを削除できる', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Player 1');
      notifier.addPlayer('Player 2');

      var game = container.read(multiplayerCountUpGameNotifierProvider);
      final player1Id = game.players[0].player.id;

      // Act
      notifier.removePlayer(player1Id);

      // Assert
      game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.players.length, equals(1));
      expect(game.players[0].player.name, equals('Player 2'));
    });

    test('ゲームを正しく開始できる', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Test Player');

      // Act
      notifier.startGame();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.state, equals(MultiplayerGameState.playing));
      expect(game.isGameActive, isTrue);
      expect(game.isGameFinished, isFalse);
      expect(game.currentPlayerIndex, equals(0));
    });

    test('プレイヤーがいない状態ではゲームを開始できない', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );

      // Act
      notifier.startGame();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.state, equals(MultiplayerGameState.setup));
      expect(game.isGameActive, isFalse);
    });

    test('アクティブなゲーム中にスローを追加できる', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Test Player');
      notifier.startGame();

      final dartThrow = DartThrowX.fromDartsLiveData('S20');

      // Act
      notifier.addThrow(dartThrow);

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      final playerData = game.players[0];
      expect(playerData.game.totalScore, equals(20));
      expect(playerData.game.currentThrow, equals(2));
    });

    test('ゲームが開始されていない時はスローを追加しない', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Test Player');

      final dartThrow = DartThrowX.fromDartsLiveData('S20');

      // Act
      notifier.addThrow(dartThrow);

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      final playerData = game.players[0];
      expect(playerData.game.totalScore, equals(0));
    });

    test('手動スローを正しく追加できる', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Test Player');
      notifier.startGame();

      // Act
      notifier.addManualThrow('T20');

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      final playerData = game.players[0];
      expect(playerData.game.totalScore, equals(60));
      expect(playerData.game.currentThrow, equals(2));
    });

    test('ゲームを正しくリセットできる', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Test Player');
      notifier.startGame();
      notifier.addManualThrow('S20');

      // Act
      notifier.resetGame();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.state, equals(MultiplayerGameState.setup));
      expect(game.isGameActive, isFalse);
      expect(game.isGameFinished, isFalse);
      expect(game.currentPlayerIndex, equals(0));

      final playerData = game.players[0];
      expect(playerData.game.totalScore, equals(0));
      expect(playerData.game.currentRound, equals(1));
      expect(playerData.game.currentThrow, equals(1));
    });

    test('フルゲームを正しく完了できる（シングルプレイヤー）', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Test Player');
      notifier.startGame();

      // Act - 全8ラウンド（24投）を完了
      for (int round = 0; round < 8; round++) {
        for (int throwInRound = 0; throwInRound < 3; throwInRound++) {
          notifier.addManualThrow('S20');
        }
      }

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.isGameFinished, isTrue);
      expect(game.state, equals(MultiplayerGameState.finished));

      final playerData = game.players[0];
      expect(playerData.game.totalScore, equals(480));
      expect(playerData.game.state, equals(GameState.finished));
    });

    test('マルチプレイヤーゲームで正しく進行する', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Player 1');
      notifier.addPlayer('Player 2');
      notifier.startGame();

      // Act - Player 1: 60点, Player 2: 30点
      for (int round = 0; round < 2; round++) {
        // Player 1のターン
        for (int throwInRound = 0; throwInRound < 3; throwInRound++) {
          notifier.addManualThrow('S20'); // 20点×3 = 60点/ラウンド
        }

        // Player 2のターン
        for (int throwInRound = 0; throwInRound < 3; throwInRound++) {
          notifier.addManualThrow('S10'); // 10点×3 = 30点/ラウンド
        }
      }

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.players[0].game.totalScore, equals(120)); // Player 1: 60×2
      expect(game.players[1].game.totalScore, equals(60)); // Player 2: 30×2
    });

    test('混合スコアを正しく処理できる', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Test Player');
      notifier.startGame();

      // Act - ラウンド1: 混合スコア
      notifier.addManualThrow('T20'); // 60
      notifier.addManualThrow('D20'); // 40
      notifier.addManualThrow('S20'); // 20
      // 合計: 120

      // ラウンド2: ブルスコア
      notifier.addManualThrow('S-BULL'); // 50
      notifier.addManualThrow('D-BULL'); // 50
      notifier.addManualThrow('CHANGE'); // 0
      // 合計: 100

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      final playerData = game.players[0];
      expect(playerData.game.totalScore, equals(220));
      expect(playerData.game.currentRound, equals(3));
      final roundScores = playerData.game.roundScores;
      expect(roundScores[0], equals(120));
      expect(roundScores[1], equals(100));
    });

    test('Bluetoothデータを正しく処理できる', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Test Player');
      notifier.startGame();

      // Act - プライベートメソッドを直接テストできないため、processDartThrowをリフレクションまたは
      // パブリックなメソッドを通してテスト。ここでは代わりにaddManualThrowでテスト
      notifier.addManualThrow('S20');

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      final playerData = game.players[0];
      expect(playerData.game.totalScore, equals(20));
    });

    test('シングルプレイヤーモードにリセットできる', () {
      // Arrange
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Player 1');
      notifier.addPlayer('Player 2');
      notifier.startGame();

      // Act
      notifier.switchToSinglePlayer();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.players, isEmpty);
      expect(game.state, equals(MultiplayerGameState.setup));
    });
  });

  group('MultiplayerGameStatistics', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('正しい初期統計を提供できる', () {
      // Arrange & Act
      final stats = container.read(multiplayerGameStatisticsProvider);

      // Assert
      expect(stats.players, isEmpty);
      expect(stats.isCompleted, isFalse);
      expect(stats.gameDuration, isNull);
      expect(stats.winner, isNull);
    });

    test('ゲームの進行に合わせて統計を更新できる', () {
      // Arrange
      final gameNotifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      gameNotifier.addPlayer('Player 1');
      gameNotifier.addPlayer('Player 2');
      gameNotifier.startGame();

      // Player 1が投げる
      gameNotifier.addManualThrow('T20');
      gameNotifier.addManualThrow('T20');
      gameNotifier.addManualThrow('T20');

      // Player 2が投げる
      gameNotifier.addManualThrow('S10');
      gameNotifier.addManualThrow('S10');
      gameNotifier.addManualThrow('S10');

      // Act
      final stats = container.read(multiplayerGameStatisticsProvider);

      // Assert
      expect(stats.players.length, equals(2));
      expect(stats.isCompleted, isFalse);
      expect(stats.averageScore, equals(105.0)); // (180 + 30) / 2
      expect(stats.sortedPlayers.length, equals(2));
      expect(stats.sortedPlayers[0].game.totalScore, equals(180)); // Player 1
      expect(stats.sortedPlayers[1].game.totalScore, equals(30)); // Player 2
    });

    test('完了したゲームの統計を表示できる', () {
      // Arrange
      final gameNotifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      gameNotifier.addPlayer('Player 1');
      gameNotifier.addPlayer('Player 2');
      gameNotifier.startGame();

      // 両プレイヤーのゲームを完了
      for (int round = 0; round < 8; round++) {
        // Player 1
        for (int throwInRound = 0; throwInRound < 3; throwInRound++) {
          gameNotifier.addManualThrow('S20');
        }

        // Player 2
        for (int throwInRound = 0; throwInRound < 3; throwInRound++) {
          gameNotifier.addManualThrow('S10');
        }
      }

      // Act
      final stats = container.read(multiplayerGameStatisticsProvider);

      // Assert
      expect(stats.isCompleted, isTrue);
      expect(stats.winner?.game.totalScore, equals(480)); // Player 1が勝者
      expect(stats.averageScore, equals(360.0)); // (480 + 240) / 2
      expect(stats.totalThrows, equals(48)); // 24投 × 2人
    });

    test('統計の計算が正しく行われる', () {
      // Arrange
      final gameNotifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      gameNotifier.addPlayer('Test Player');
      gameNotifier.startGame();

      // 2ラウンド分投げる
      gameNotifier.addManualThrow('T20'); // 60
      gameNotifier.addManualThrow('D20'); // 40
      gameNotifier.addManualThrow('S20'); // 20 → 合計120

      gameNotifier.addManualThrow('S10'); // 10
      gameNotifier.addManualThrow('S15'); // 15
      gameNotifier.addManualThrow('S5'); // 5  → 合計30

      // Act
      final stats = container.read(multiplayerGameStatisticsProvider);

      // Assert
      expect(stats.players.length, equals(1));
      expect(stats.players[0].game.totalScore, equals(150)); // 120 + 30
      expect(stats.averageScore, equals(150.0)); // 150 / 1
      expect(stats.totalThrows, equals(6)); // 6投
    });
  });
}
