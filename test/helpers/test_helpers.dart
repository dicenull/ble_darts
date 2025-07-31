import 'package:ble_darts/features/count_up/domain/count_up_game.dart';
import 'package:ble_darts/features/count_up/domain/multiplayer_count_up_game.dart';
import 'package:ble_darts/features/count_up/domain/player.dart';
import 'package:ble_darts/shared/models/dart_throw.dart';

/// マルチプレイヤーゲーム用のテストヘルパーユーティリティ
class TestHelpers {
  /// テスト用のプレイヤーを作成
  static Player createTestPlayer({
    String? id,
    String? name,
    int totalScore = 0,
    int gamesPlayed = 0,
    int gamesWon = 0,
  }) {
    return Player(
      id: id ?? 'test-player-${DateTime.now().millisecondsSinceEpoch}',
      name: name ?? 'Test Player',
      totalScore: totalScore,
      gamesPlayed: gamesPlayed,
      gamesWon: gamesWon,
    );
  }

  /// 複数のテスト用プレイヤーを作成
  static List<Player> createTestPlayers(int count) {
    return List.generate(
      count,
      (index) => createTestPlayer(
        id: 'player-${index + 1}',
        name: 'Player ${index + 1}',
      ),
    );
  }

  /// 指定されたプレイヤーでマルチプレイヤーゲームを作成し開始
  static MultiplayerCountUpGame createStartedGame(List<Player> players) {
    var game = const MultiplayerCountUpGame();
    for (final player in players) {
      game = game.addPlayer(player);
    }
    return game.startGame();
  }

  /// シングルプレイヤーのテストゲームを作成
  static MultiplayerCountUpGame createSinglePlayerGame({String? playerName}) {
    final player = createTestPlayer(name: playerName ?? 'Single Player');
    return createStartedGame([player]);
  }

  /// マルチプレイヤーのテストゲームを作成
  static MultiplayerCountUpGame createMultiPlayerGame({int playerCount = 2}) {
    final players = createTestPlayers(playerCount);
    return createStartedGame(players);
  }

  /// 特定のプレイヤーに指定回数のスローを追加
  static MultiplayerCountUpGame addThrowsToPlayer(
    MultiplayerCountUpGame game,
    String playerId,
    List<String> positions,
  ) {
    var updatedGame = game;

    // 指定プレイヤーが現在のプレイヤーになるまでスイッチ
    while (updatedGame.currentPlayer?.player.id != playerId) {
      // 簡単にするため、currentPlayerIndexを直接操作
      final playerIndex = updatedGame.players.indexWhere(
        (p) => p.player.id == playerId,
      );
      if (playerIndex != -1) {
        updatedGame = updatedGame.copyWith(currentPlayerIndex: playerIndex);
        break;
      }
    }

    // スローを追加
    for (final position in positions) {
      final dartThrow = DartThrowX.fromDartsLiveData(position);
      updatedGame = updatedGame.addThrow(dartThrow);
    }

    return updatedGame;
  }

  /// プレイヤーの1ラウンドを完了
  static MultiplayerCountUpGame completeRoundForPlayer(
    MultiplayerCountUpGame game,
    String playerId,
    List<String> throws,
  ) {
    assert(throws.length == 3, 'ラウンドには3投が必要です');
    return addThrowsToPlayer(game, playerId, throws);
  }

  /// プレイヤーのゲーム全体を完了
  static MultiplayerCountUpGame completeGameForPlayer(
    MultiplayerCountUpGame game,
    String playerId, {
    String position = 'S20', // デフォルトは20点
  }) {
    var updatedGame = game;

    // 8ラウンド × 3投 = 24投
    for (int round = 0; round < 8; round++) {
      updatedGame = completeRoundForPlayer(updatedGame, playerId, [
        position,
        position,
        position,
      ]);
    }

    return updatedGame;
  }

  /// 全プレイヤーのゲームを完了
  static MultiplayerCountUpGame completeAllPlayersGames(
    MultiplayerCountUpGame game, {
    Map<String, String>? playerPositions, // プレイヤーID -> ポジション
  }) {
    var updatedGame = game;

    for (final playerData in game.players) {
      final position = playerPositions?[playerData.player.id] ?? 'S20';
      updatedGame = completeGameForPlayer(
        updatedGame,
        playerData.player.id,
        position: position,
      );
    }

    return updatedGame;
  }

  /// 特定のスコア構成でラウンドを作成
  static List<String> createRoundWithScore(int targetScore) {
    // 簡単な例: 可能な限り20を使用
    final throws = <String>[];
    var remainingScore = targetScore;

    for (int i = 0; i < 3 && remainingScore > 0; i++) {
      if (remainingScore >= 60) {
        throws.add('T20'); // 60点
        remainingScore -= 60;
      } else if (remainingScore >= 40) {
        throws.add('D20'); // 40点
        remainingScore -= 40;
      } else if (remainingScore >= 20) {
        throws.add('S20'); // 20点
        remainingScore -= 20;
      } else if (remainingScore >= 50) {
        throws.add('S-BULL'); // 50点
        remainingScore -= 50;
      } else {
        throws.add('S$remainingScore'); // 残りのスコア
        remainingScore = 0;
      }
    }

    // 3投に満たない場合は0点で埋める
    while (throws.length < 3) {
      throws.add('CHANGE'); // 0点
    }

    return throws;
  }

  /// ランダムなスコアでゲームを部分的に進行
  static MultiplayerCountUpGame simulatePartialGame(
    MultiplayerCountUpGame game,
    int roundsToComplete,
  ) {
    var updatedGame = game;
    final positions = ['S20', 'D20', 'T20', 'S15', 'S10', 'S-BULL'];

    for (int round = 0; round < roundsToComplete; round++) {
      for (final playerData in game.players) {
        // 各プレイヤーが3投
        for (int throwCount = 0; throwCount < 3; throwCount++) {
          final position = positions[round % positions.length];
          updatedGame = addThrowsToPlayer(updatedGame, playerData.player.id, [
            position,
          ]);
        }
      }
    }

    return updatedGame;
  }

  /// テスト用のスコア統計を検証するヘルパー
  static bool validateGameStatistics(MultiplayerCountUpGame game) {
    for (final playerData in game.players) {
      final calculatedScore = playerData.game.rounds
          .expand((round) => round)
          .fold(0, (sum, dartThrow) => sum + dartThrow.score);

      if (calculatedScore != playerData.game.totalScore) {
        return false;
      }
    }
    return true;
  }

  /// プレイヤーの統計情報を文字列として出力
  static String formatPlayerStats(PlayerGameData playerData) {
    return '${playerData.player.name}: '
        '${playerData.game.totalScore}点 '
        '(R${playerData.game.currentRound}/${playerData.game.currentThrow}) '
        '${playerData.game.state == GameState.finished ? "完了" : "進行中"}';
  }

  /// ゲーム全体の統計情報を文字列として出力
  static String formatGameStats(MultiplayerCountUpGame game) {
    final stats = StringBuffer();
    stats.writeln('=== ゲーム統計 ===');
    stats.writeln('プレイヤー数: ${game.players.length}');
    stats.writeln(
      'ゲーム状態: ${game.isGameActive ? "開始済み" : "未開始"} / ${game.isGameFinished ? "完了" : "進行中"}',
    );

    if (game.currentPlayer != null) {
      stats.writeln('現在のプレイヤー: ${game.currentPlayer!.player.name}');
    }

    final sortedPlayers = game.sortedByScore;
    if (sortedPlayers.isNotEmpty) {
      stats.writeln('勝者: ${sortedPlayers.first.player.name}');
    }

    stats.writeln('\n=== プレイヤー詳細 ===');
    for (final playerData in game.players) {
      stats.writeln(formatPlayerStats(playerData));
    }

    if (game.isGameFinished) {
      stats.writeln('\n=== ランキング ===');
      final ranking = game.sortedByScore;
      for (int i = 0; i < ranking.length; i++) {
        stats.writeln(
          '${i + 1}位: ${ranking[i].player.name} (${ranking[i].game.totalScore}点)',
        );
      }
    }

    return stats.toString();
  }

  /// 特定のBluetoothデータフォーマットを生成
  static String createBluetoothData(String position) {
    final now = DateTime.now();
    final timeString =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    return '$timeString: $position';
  }

  /// モックのDartThrowリストを作成
  static List<DartThrow> createMockDartThrows(List<String> positions) {
    return positions
        .map((position) => DartThrowX.fromDartsLiveData(position))
        .toList();
  }

  /// 完璧なゲーム（全てT20）を作成
  static MultiplayerCountUpGame createPerfectGame(List<Player> players) {
    var game = createStartedGame(players);

    for (final playerData in players) {
      game = completeGameForPlayer(game, playerData.id, position: 'T20');
    }

    return game;
  }

  /// 最低スコアゲーム（全てS1）を作成
  static MultiplayerCountUpGame createMinimumScoreGame(List<Player> players) {
    var game = createStartedGame(players);

    for (final playerData in players) {
      game = completeGameForPlayer(game, playerData.id, position: 'S1');
    }

    return game;
  }

  /// ゲーム状態のテストアサーション
  static void assertGameState({
    required MultiplayerCountUpGame game,
    required MultiplayerGameState expectedState,
    int? expectedPlayerCount,
    int? expectedCurrentPlayerIndex,
  }) {
    assert(
      game.state == expectedState,
      'ゲーム状態が期待値と異なります: ${game.state} != $expectedState',
    );

    if (expectedPlayerCount != null) {
      assert(
        game.players.length == expectedPlayerCount,
        'プレイヤー数が期待値と異なります: ${game.players.length} != $expectedPlayerCount',
      );
    }

    if (expectedCurrentPlayerIndex != null) {
      assert(
        game.currentPlayerIndex == expectedCurrentPlayerIndex,
        '現在のプレイヤーインデックスが期待値と異なります: ${game.currentPlayerIndex} != $expectedCurrentPlayerIndex',
      );
    }
  }

  /// プレイヤーデータのテストアサーション
  static void assertPlayerData({
    required PlayerGameData playerData,
    int? expectedScore,
    int? expectedRound,
    int? expectedThrow,
    bool? expectedIsFinished,
  }) {
    if (expectedScore != null) {
      assert(
        playerData.game.totalScore == expectedScore,
        'スコアが期待値と異なります: ${playerData.game.totalScore} != $expectedScore',
      );
    }

    if (expectedRound != null) {
      assert(
        playerData.game.currentRound == expectedRound,
        'ラウンドが期待値と異なります: ${playerData.game.currentRound} != $expectedRound',
      );
    }

    if (expectedThrow != null) {
      assert(
        playerData.game.currentThrow == expectedThrow,
        '投げ数が期待値と異なります: ${playerData.game.currentThrow} != $expectedThrow',
      );
    }

    if (expectedIsFinished != null) {
      final actualIsFinished = playerData.game.state == GameState.finished;
      assert(
        actualIsFinished == expectedIsFinished,
        'ゲーム完了状態が期待値と異なります: $actualIsFinished != $expectedIsFinished',
      );
    }
  }
}

/// テスト用のマッチャー拡張
extension TestMatchers on MultiplayerCountUpGame {
  /// ゲームが指定された状態であるかチェック
  bool isInState(MultiplayerGameState state) => this.state == state;

  /// プレイヤー数をチェック
  bool hasPlayerCount(int count) => players.length == count;

  /// 指定されたプレイヤーが現在のプレイヤーかチェック
  bool isCurrentPlayer(String playerId) => currentPlayer?.player.id == playerId;

  /// 全てのプレイヤーがゲームを完了しているかチェック
  bool areAllPlayersFinished() =>
      players.every((p) => p.game.state == GameState.finished);
}
