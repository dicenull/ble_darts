import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../shared/models/dart_throw.dart';
import '../../bluetooth/data/bluetooth_provider.dart';
import '../domain/multiplayer_count_up_game.dart';
import '../domain/player.dart';

part 'multiplayer_count_up_provider.g.dart';

@riverpod
class MultiplayerCountUpGameNotifier extends _$MultiplayerCountUpGameNotifier {
  static const _uuid = Uuid();

  @override
  MultiplayerCountUpGame build() {
    _subscribeToBluetoothData();
    return const MultiplayerCountUpGame();
  }

  void _subscribeToBluetoothData() {
    final bluetoothNotifier = ref.read(bluetoothNotifierProvider.notifier);
    bluetoothNotifier.dataStream.listen((data) {
      _processDartThrow(data);
    });
  }

  void _processDartThrow(String rawData) {
    try {
      final dartPosition = _extractDartPosition(rawData);
      if (dartPosition != null && state.isGameActive) {
        final dartThrow = DartThrowX.fromDartsLiveData(dartPosition);
        addThrow(dartThrow);
      }
    } catch (e) {
      rethrow;
    }
  }

  String? _extractDartPosition(String rawData) {
    final timestampRegex = RegExp(r'\d{2}:\d{2}:\d{2}: (.+)');
    final match = timestampRegex.firstMatch(rawData);

    if (match != null) {
      final position = match.group(1)?.trim();
      if (position != null && position.isNotEmpty && position != 'Web接続完了') {
        return position;
      }
    }
    return null;
  }

  void addPlayer(String name) {
    if (name.trim().isEmpty || state.state != MultiplayerGameState.setup) return;
    
    final player = Player(
      id: _uuid.v4(),
      name: name.trim(),
    );
    
    state = state.addPlayer(player);
  }

  void removePlayer(String playerId) {
    state = state.removePlayer(playerId);
  }

  void startGame() {
    if (state.hasPlayers) {
      state = state.startGame();
    }
  }

  void addThrow(DartThrow dartThrow) {
    if (state.isGameActive) {
      state = state.addThrow(dartThrow);
    }
  }

  void addManualThrow(String position) {
    if (state.isGameActive) {
      final dartThrow = DartThrowX.fromDartsLiveData(position);
      addThrow(dartThrow);
    }
  }

  void resetGame() {
    state = state.resetGame();
  }

  void switchToSinglePlayer() {
    state = const MultiplayerCountUpGame();
  }
}

@riverpod
class MultiplayerGameStatistics extends _$MultiplayerGameStatistics {
  @override
  MultiplayerGameStatisticsData build() {
    final game = ref.watch(multiplayerCountUpGameNotifierProvider);
    return MultiplayerGameStatisticsData(
      players: game.players,
      isCompleted: game.isGameFinished,
      gameDuration: game.gameDuration,
      winner: game.isGameFinished ? game.sortedByScore.firstOrNull : null,
    );
  }
}

class MultiplayerGameStatisticsData {
  final List<PlayerGameData> players;
  final bool isCompleted;
  final Duration? gameDuration;
  final PlayerGameData? winner;

  MultiplayerGameStatisticsData({
    required this.players,
    required this.isCompleted,
    required this.gameDuration,
    required this.winner,
  });

  List<PlayerGameData> get sortedPlayers => 
      [...players]..sort((a, b) => b.game.totalScore.compareTo(a.game.totalScore));

  int get totalThrows => players.fold(0, (sum, player) => 
      sum + player.game.rounds.fold(0, (roundSum, round) => roundSum + round.length));

  double get averageScore => players.isNotEmpty
      ? players.fold(0, (sum, player) => sum + player.game.totalScore) / players.length
      : 0.0;
}