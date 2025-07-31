import 'package:flutter_test/flutter_test.dart';
import 'package:ble_darts/features/count_up/domain/multiplayer_count_up_game.dart';
import 'package:ble_darts/features/count_up/domain/player.dart';
import 'package:ble_darts/features/count_up/domain/count_up_game.dart';
import 'package:ble_darts/shared/models/dart_throw.dart';

void main() {
  group('MultiplayerCountUpGame', () {
    late Player player1;
    late Player player2;
    late Player player3;

    setUp(() {
      player1 = const Player(id: 'player1', name: 'Player 1');
      player2 = const Player(id: 'player2', name: 'Player 2');
      player3 = const Player(id: 'player3', name: 'Player 3');
    });

    test('デフォルト状態で初期化される', () {
      // Arrange & Act
      const game = MultiplayerCountUpGame();

      // Assert
      expect(game.players, isEmpty);
      expect(game.currentPlayerIndex, equals(0));
      expect(game.state, equals(MultiplayerGameState.setup));
      expect(game.isGameActive, isFalse);
      expect(game.isGameFinished, isFalse);
      expect(game.hasPlayers, isFalse);
      expect(game.currentPlayer, isNull);
    });

    test('シングルプレイヤーゲームを作成できる', () {
      // Arrange & Act
      final game = const MultiplayerCountUpGame().addPlayer(player1);

      // Assert
      expect(game.players.length, equals(1));
      expect(game.players[0].player, equals(player1));
      expect(game.currentPlayerIndex, equals(0));
      expect(game.hasPlayers, isTrue);
      expect(game.currentPlayer?.player, equals(player1));
    });

    test('マルチプレイヤーゲームを作成できる', () {
      // Arrange & Act
      var game = const MultiplayerCountUpGame();
      game = game.addPlayer(player1);
      game = game.addPlayer(player2);
      game = game.addPlayer(player3);

      // Assert
      expect(game.players.length, equals(3));
      expect(
        game.players.map((p) => p.player),
        containsAll([player1, player2, player3]),
      );
      expect(game.currentPlayerIndex, equals(0));
      expect(game.currentPlayer?.player, equals(player1));
    });

    test('ゲームを正しく開始できる', () {
      // Arrange
      var game = const MultiplayerCountUpGame();
      game = game.addPlayer(player1);
      game = game.addPlayer(player2);

      // Act
      final startedGame = game.startGame();

      // Assert
      expect(startedGame.state, equals(MultiplayerGameState.playing));
      expect(startedGame.isGameActive, isTrue);
      expect(startedGame.isGameFinished, isFalse);
      expect(startedGame.currentPlayerIndex, equals(0));
      expect(startedGame.startTime, isNotNull);

      // 各プレイヤーのゲームが開始されているか確認
      for (final playerData in startedGame.players) {
        expect(playerData.game.state, equals(GameState.playing));
        expect(playerData.game.isGameActive, isTrue);
      }
    });

    test('空のプレイヤーリストではゲームを開始できない', () {
      // Arrange
      const game = MultiplayerCountUpGame();

      // Act
      final startedGame = game.startGame();

      // Assert
      expect(startedGame.state, equals(MultiplayerGameState.setup));
      expect(startedGame.isGameActive, isFalse);
    });

    test('スローを現在のプレイヤーのゲームに追加できる', () {
      // Arrange
      var game = const MultiplayerCountUpGame();
      game = game.addPlayer(player1);
      game = game.addPlayer(player2);
      game = game.startGame();
      final dartThrow = DartThrowX.fromDartsLiveData('S20');

      // Act
      final gameWithThrow = game.addThrow(dartThrow);

      // Assert
      expect(gameWithThrow.players[0].game.totalScore, equals(20));
      expect(gameWithThrow.players[0].game.currentThrow, equals(2));
      expect(
        gameWithThrow.players[1].game.totalScore,
        equals(0),
      ); // 他のプレイヤーは変更されない
    });

    test('3投後に次のプレイヤーのラウンドに進む', () {
      // Arrange
      var game = const MultiplayerCountUpGame();
      game = game.addPlayer(player1);
      game = game.addPlayer(player2);
      game = game.startGame();

      // Act - Player 1が3投
      game = game.addThrow(DartThrowX.fromDartsLiveData('S20'));
      expect(game.currentPlayerIndex, equals(0)); // まだPlayer 1

      game = game.addThrow(DartThrowX.fromDartsLiveData('S20'));
      expect(game.currentPlayerIndex, equals(0)); // まだPlayer 1

      game = game.addThrow(DartThrowX.fromDartsLiveData('S20'));

      // Assert - 次のプレイヤーに自動的にスイッチまたはPlayer 1の次のラウンドに
      expect(game.players[0].game.currentThrow, equals(1)); // Player 1は次のラウンドに
      expect(game.players[0].game.currentRound, equals(2));
    });

    test('全プレイヤーがゲームを完了したら全体ゲームが終了する', () {
      // Arrange
      var game = const MultiplayerCountUpGame();
      game = game.addPlayer(player1);
      game = game.addPlayer(player2);
      game = game.startGame();

      // Act - Player 1のゲームを完了 (8ラウンド = 24投)
      for (int round = 0; round < 8; round++) {
        for (int throwInRound = 0; throwInRound < 3; throwInRound++) {
          game = game.addThrow(DartThrowX.fromDartsLiveData('S20'));
        }
      }

      // Player 2のゲームを完了
      for (int round = 0; round < 8; round++) {
        for (int throwInRound = 0; throwInRound < 3; throwInRound++) {
          game = game.addThrow(DartThrowX.fromDartsLiveData('S10'));
        }
      }

      // Assert
      expect(game.isGameFinished, isTrue);
      expect(game.state, equals(MultiplayerGameState.finished));
      expect(game.endTime, isNotNull);
    });

    test('スコア順でソートされたプレイヤーリストを取得できる', () {
      // Arrange
      var game = const MultiplayerCountUpGame();
      game = game.addPlayer(player1);
      game = game.addPlayer(player2);
      game = game.addPlayer(player3);
      game = game.startGame();

      // 各プレイヤーに異なるスコアを設定
      // Player 1: 60点
      for (int i = 0; i < 3; i++) {
        game = game.addThrow(DartThrowX.fromDartsLiveData('S20'));
      }

      // Player 2: 30点
      for (int i = 0; i < 3; i++) {
        game = game.addThrow(DartThrowX.fromDartsLiveData('S10'));
      }

      // Player 3: 90点
      for (int i = 0; i < 3; i++) {
        game = game.addThrow(DartThrowX.fromDartsLiveData('S30'));
      }

      // Act
      final sortedPlayers = game.sortedByScore;

      // Assert
      expect(sortedPlayers.length, equals(3));
      expect(sortedPlayers[0].player, equals(player3)); // 1位: 90点
      expect(sortedPlayers[0].game.totalScore, equals(90));
      expect(sortedPlayers[1].player, equals(player1)); // 2位: 60点
      expect(sortedPlayers[1].game.totalScore, equals(60));
      expect(sortedPlayers[2].player, equals(player2)); // 3位: 30点
      expect(sortedPlayers[2].game.totalScore, equals(30));
    });

    test('ゲームを正しくリセットできる', () {
      // Arrange
      var game = const MultiplayerCountUpGame();
      game = game.addPlayer(player1);
      game = game.addPlayer(player2);
      game = game.startGame();
      game = game.addThrow(DartThrowX.fromDartsLiveData('S20'));

      // Act
      final resetGame = game.resetGame();

      // Assert
      expect(resetGame.state, equals(MultiplayerGameState.setup));
      expect(resetGame.isGameActive, isFalse);
      expect(resetGame.isGameFinished, isFalse);
      expect(resetGame.currentPlayerIndex, equals(0));
      expect(resetGame.startTime, isNull);
      expect(resetGame.endTime, isNull);

      // 各プレイヤーのゲームがリセットされているか確認
      for (final playerData in resetGame.players) {
        expect(playerData.game.state, equals(GameState.waiting));
        expect(playerData.game.totalScore, equals(0));
        expect(playerData.game.currentRound, equals(1));
        expect(playerData.game.currentThrow, equals(1));
      }
    });

    test('プレイヤーを追加できる', () {
      // Arrange
      const game = MultiplayerCountUpGame();

      // Act
      final gameWithPlayer = game.addPlayer(player1);

      // Assert
      expect(gameWithPlayer.players.length, equals(1));
      expect(gameWithPlayer.players[0].player, equals(player1));
    });

    test('セットアップ状態以外ではプレイヤーを追加できない', () {
      // Arrange
      var game = const MultiplayerCountUpGame();
      game = game.addPlayer(player1);
      game = game.startGame(); // playing状態に変更

      // Act
      final gameWithAttemptedAdd = game.addPlayer(player2);

      // Assert
      expect(gameWithAttemptedAdd.players.length, equals(1)); // 追加されない
    });

    test('プレイヤーを削除できる', () {
      // Arrange
      var game = const MultiplayerCountUpGame();
      game = game.addPlayer(player1);
      game = game.addPlayer(player2);
      game = game.addPlayer(player3);

      // Act
      final gameWithoutPlayer = game.removePlayer(player2.id);

      // Assert
      expect(gameWithoutPlayer.players.length, equals(2));
      expect(
        gameWithoutPlayer.players.map((p) => p.player),
        isNot(contains(player2)),
      );
      expect(
        gameWithoutPlayer.players.map((p) => p.player),
        containsAll([player1, player3]),
      );
    });

    test('現在のプレイヤー削除時にインデックスを調整する', () {
      // Arrange
      var game = const MultiplayerCountUpGame();
      game = game.addPlayer(player1);
      game = game.addPlayer(player2);
      game = game.addPlayer(player3);

      // currentPlayerIndexを1に設定（Player 2）
      game = game.copyWith(currentPlayerIndex: 1);

      // Act
      final gameWithoutCurrentPlayer = game.removePlayer(player2.id);

      // Assert - インデックスが適切に調整される
      expect(
        gameWithoutCurrentPlayer.currentPlayerIndex,
        lessThan(gameWithoutCurrentPlayer.players.length),
      );
    });

    test('ゲーム時間を正しく計算できる', () {
      // Arrange
      var game = const MultiplayerCountUpGame();
      game = game.addPlayer(player1);
      final startedGame = game.startGame();

      // Act
      final duration = startedGame.gameDuration;

      // Assert
      expect(duration, isNotNull);
      expect(duration!.inMilliseconds, greaterThanOrEqualTo(0));
    });

    test('未開始のゲームでは時間をnullで返す', () {
      // Arrange
      const game = MultiplayerCountUpGame();

      // Act
      final duration = game.gameDuration;

      // Assert
      expect(duration, isNull);
    });

    test('現在のプレイヤーがアクティブ状態になる', () {
      // Arrange
      var game = const MultiplayerCountUpGame();
      game = game.addPlayer(player1);
      game = game.addPlayer(player2);
      game = game.startGame();

      // Act & Assert
      expect(game.players[0].isActive, isTrue); // 現在のプレイヤー
      expect(game.players[1].isActive, isFalse); // 他のプレイヤー
    });
  });

  group('PlayerGameData', () {
    test('PlayerGameDataを作成できる', () {
      // Arrange
      const player = Player(id: 'test-id', name: 'Test Player');
      const game = CountUpGame();

      // Act
      const playerData = PlayerGameData(player: player, game: game);

      // Assert
      expect(playerData.player, equals(player));
      expect(playerData.game, equals(game));
      expect(playerData.isActive, isFalse); // デフォルト値
    });

    test('アクティブ状態を設定できる', () {
      // Arrange
      const player = Player(id: 'test-id', name: 'Test Player');
      const game = CountUpGame();

      // Act
      const playerData = PlayerGameData(
        player: player,
        game: game,
        isActive: true,
      );

      // Assert
      expect(playerData.isActive, isTrue);
    });

    test('copyWithで更新できる', () {
      // Arrange
      const player = Player(id: 'test-id', name: 'Test Player');
      var game = const CountUpGame().startGame();
      game = game.addThrow(DartThrowX.fromDartsLiveData('S20'));

      const originalData = PlayerGameData(player: player, game: CountUpGame());

      // Act
      final updatedData = originalData.copyWith(game: game, isActive: true);

      // Assert
      expect(updatedData.player, equals(player)); // 変更なし
      expect(updatedData.game.totalScore, equals(20)); // 更新された
      expect(updatedData.isActive, isTrue); // 更新された
    });
  });
}
