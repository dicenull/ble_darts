import 'dart:async';

import '../data.dart';
import '../models/count_up_game.dart';
import '../models/dart_throw.dart';

class GameService {
  late CountUpGame _currentGame;
  final StreamController<CountUpGame> _gameStateController =
      StreamController<CountUpGame>.broadcast();
  StreamSubscription<String>? _bluetoothSubscription;

  GameService() {
    _currentGame = CountUpGame();
  }

  CountUpGame get currentGame => _currentGame;
  Stream<CountUpGame> get gameStateStream => _gameStateController.stream;

  void startNewGame() {
    _currentGame.startGame();
    _gameStateController.add(_currentGame);
  }

  void resetGame() {
    _currentGame.resetGame();
    _gameStateController.add(_currentGame);
  }

  void connectToBluetoothStream(Stream<String> bluetoothStream) {
    _bluetoothSubscription?.cancel();
    _bluetoothSubscription = bluetoothStream.listen((data) {
      _processDartThrow(data);
    });
  }

  void _processDartThrow(String rawData) {
    try {
      final dartPosition = _extractDartPosition(rawData);
      if (dartPosition != null && _currentGame.isGameActive) {
        final dartThrow = DartThrow.fromDartsLiveData(dartPosition);
        _currentGame.addThrow(dartThrow);
        _gameStateController.add(_currentGame);
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

  void addManualThrow(String position) {
    if (_currentGame.isGameActive) {
      final dartThrow = DartThrow.fromDartsLiveData(position);
      _currentGame.addThrow(dartThrow);
      _gameStateController.add(_currentGame);
    }
  }

  List<String> getAvailablePositions() {
    return dat.values.where((position) => position != 'CHANGE').toList();
  }

  GameStatistics getGameStatistics() {
    return GameStatistics(
      totalScore: _currentGame.totalScore,
      averageScore: _currentGame.averageScore,
      roundScores: _currentGame.roundScores,
      gameDuration: _currentGame.gameDuration,
      isCompleted: _currentGame.isGameFinished,
    );
  }

  void dispose() {
    _bluetoothSubscription?.cancel();
    _gameStateController.close();
  }
}

class GameStatistics {
  final int totalScore;
  final double averageScore;
  final List<int> roundScores;
  final Duration? gameDuration;
  final bool isCompleted;

  GameStatistics({
    required this.totalScore,
    required this.averageScore,
    required this.roundScores,
    required this.gameDuration,
    required this.isCompleted,
  });

  int get highestRoundScore =>
      roundScores.isNotEmpty ? roundScores.reduce((a, b) => a > b ? a : b) : 0;

  int get lowestRoundScore =>
      roundScores.isNotEmpty ? roundScores.reduce((a, b) => a < b ? a : b) : 0;

  double get averageRoundScore => roundScores.isNotEmpty
      ? roundScores.reduce((a, b) => a + b) / roundScores.length
      : 0.0;
}
