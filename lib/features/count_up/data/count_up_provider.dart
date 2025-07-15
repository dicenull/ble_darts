import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/count_up_game.dart';
import '../../../shared/models/dart_throw.dart';
import '../../bluetooth/data/bluetooth_provider.dart';

part 'count_up_provider.g.dart';

@riverpod
class CountUpGameNotifier extends _$CountUpGameNotifier {
  @override
  CountUpGame build() {
    _subscribeToBluetoothData();
    return const CountUpGame();
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
      // エラーログ（本番環境では適切なログシステムを使用）
      print('Error processing dart throw: $e');
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

  void startGame() {
    state = state.startGame();
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
}

@riverpod
class GameStatistics extends _$GameStatistics {
  @override
  GameStatisticsData build() {
    final game = ref.watch(countUpGameNotifierProvider);
    return GameStatisticsData(
      totalScore: game.totalScore,
      averageScore: game.averageScore,
      roundScores: game.roundScores,
      gameDuration: game.gameDuration,
      isCompleted: game.isGameFinished,
    );
  }
}

class GameStatisticsData {
  final int totalScore;
  final double averageScore;
  final List<int> roundScores;
  final Duration? gameDuration;
  final bool isCompleted;

  GameStatisticsData({
    required this.totalScore,
    required this.averageScore,
    required this.roundScores,
    required this.gameDuration,
    required this.isCompleted,
  });

  int get highestRoundScore => roundScores.isNotEmpty ? roundScores.reduce((a, b) => a > b ? a : b) : 0;
  
  int get lowestRoundScore => roundScores.isNotEmpty ? roundScores.reduce((a, b) => a < b ? a : b) : 0;
  
  double get averageRoundScore => roundScores.isNotEmpty 
    ? roundScores.reduce((a, b) => a + b) / roundScores.length 
    : 0.0;
}