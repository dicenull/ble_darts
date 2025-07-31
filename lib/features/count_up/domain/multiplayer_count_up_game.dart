import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../shared/models/dart_throw.dart';
import 'count_up_game.dart';
import 'player.dart';

part 'multiplayer_count_up_game.freezed.dart';
part 'multiplayer_count_up_game.g.dart';

enum MultiplayerGameState { setup, playing, finished }

@freezed
class PlayerGameData with _$PlayerGameData {
  const factory PlayerGameData({
    required Player player,
    required CountUpGame game,
    @Default(false) bool isActive,
  }) = _PlayerGameData;

  factory PlayerGameData.fromJson(Map<String, dynamic> json) =>
      _$PlayerGameDataFromJson(json);
}

@freezed
class MultiplayerCountUpGame with _$MultiplayerCountUpGame {
  const factory MultiplayerCountUpGame({
    @Default(MultiplayerGameState.setup) MultiplayerGameState state,
    @Default([]) List<PlayerGameData> players,
    @Default(0) int currentPlayerIndex,
    DateTime? startTime,
    DateTime? endTime,
  }) = _MultiplayerCountUpGame;

  factory MultiplayerCountUpGame.fromJson(Map<String, dynamic> json) =>
      _$MultiplayerCountUpGameFromJson(json);
}

extension MultiplayerCountUpGameX on MultiplayerCountUpGame {
  bool get isGameActive => state == MultiplayerGameState.playing;
  bool get isGameFinished => state == MultiplayerGameState.finished;
  bool get hasPlayers => players.isNotEmpty;

  PlayerGameData? get currentPlayer =>
      players.isNotEmpty && currentPlayerIndex < players.length
      ? players[currentPlayerIndex]
      : null;

  List<PlayerGameData> get sortedByScore =>
      [...players]
        ..sort((a, b) => b.game.totalScore.compareTo(a.game.totalScore));

  Duration? get gameDuration {
    if (startTime == null) return null;
    final endTime = this.endTime ?? DateTime.now();
    return endTime.difference(startTime!);
  }

  MultiplayerCountUpGame addPlayer(Player player) {
    if (state != MultiplayerGameState.setup) return this;

    final newPlayerData = PlayerGameData(
      player: player,
      game: const CountUpGame(),
      isActive: players.isEmpty,
    );

    return copyWith(players: [...players, newPlayerData]);
  }

  MultiplayerCountUpGame removePlayer(String playerId) {
    if (state != MultiplayerGameState.setup) return this;

    final updatedPlayers = players
        .where((p) => p.player.id != playerId)
        .toList();
    final newCurrentIndex = currentPlayerIndex >= updatedPlayers.length
        ? 0
        : currentPlayerIndex;

    return copyWith(
      players: updatedPlayers,
      currentPlayerIndex: newCurrentIndex,
    );
  }

  MultiplayerCountUpGame startGame() {
    if (players.isEmpty) return this;

    final updatedPlayers = players
        .map(
          (playerData) => playerData.copyWith(
            game: playerData.game.startGame(),
            isActive: players.indexOf(playerData) == 0,
          ),
        )
        .toList();

    return copyWith(
      state: MultiplayerGameState.playing,
      players: updatedPlayers,
      currentPlayerIndex: 0,
      startTime: DateTime.now(),
      endTime: null,
    );
  }

  MultiplayerCountUpGame addThrow(DartThrow dartThrow) {
    if (!isGameActive || players.isEmpty) return this;

    final currentPlayerData = players[currentPlayerIndex];
    final updatedGame = currentPlayerData.game.addThrow(dartThrow);

    final updatedPlayers = [...players];
    updatedPlayers[currentPlayerIndex] = currentPlayerData.copyWith(
      game: updatedGame,
    );

    // ゲーム終了チェックと次のプレイヤーへの切り替え
    if (updatedGame.isGameFinished || updatedGame.currentThrow == 1) {
      final nextPlayerIndex = _getNextPlayerIndex();
      final nextPlayersState = updatedPlayers
          .map(
            (p) => p.copyWith(
              isActive: updatedPlayers.indexOf(p) == nextPlayerIndex,
            ),
          )
          .toList();

      // 全プレイヤーがゲーム終了したかチェック
      final allFinished = nextPlayersState.every((p) => p.game.isGameFinished);

      return copyWith(
        players: nextPlayersState,
        currentPlayerIndex: nextPlayerIndex,
        state: allFinished ? MultiplayerGameState.finished : state,
        endTime: allFinished ? DateTime.now() : endTime,
      );
    }

    return copyWith(players: updatedPlayers);
  }

  int _getNextPlayerIndex() {
    if (players.isEmpty) return 0;

    // まだ終了していないプレイヤーの中から次のプレイヤーを選択
    for (int i = 1; i <= players.length; i++) {
      final nextIndex = (currentPlayerIndex + i) % players.length;
      if (!players[nextIndex].game.isGameFinished) {
        return nextIndex;
      }
    }

    return currentPlayerIndex;
  }

  MultiplayerCountUpGame resetGame() {
    final resetPlayers = players
        .map(
          (playerData) => playerData.copyWith(
            game: const CountUpGame(),
            isActive: players.indexOf(playerData) == 0,
          ),
        )
        .toList();

    return copyWith(
      state: MultiplayerGameState.setup,
      players: resetPlayers,
      currentPlayerIndex: 0,
      startTime: null,
      endTime: null,
    );
  }
}
