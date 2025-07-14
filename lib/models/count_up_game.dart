import 'dart_throw.dart';

enum GameState {
  waiting,
  playing,
  finished,
}

class CountUpGame {
  static const int maxRounds = 8;
  static const int throwsPerRound = 3;

  GameState _state = GameState.waiting;
  int _currentRound = 1;
  int _currentThrow = 1;
  int _totalScore = 0;
  List<List<DartThrow>> _rounds = [];
  DateTime? _startTime;
  DateTime? _endTime;

  CountUpGame() {
    _initializeRounds();
  }

  void _initializeRounds() {
    _rounds = List.generate(maxRounds, (index) => <DartThrow>[]);
  }

  GameState get state => _state;
  int get currentRound => _currentRound;
  int get currentThrow => _currentThrow;
  int get totalScore => _totalScore;
  List<List<DartThrow>> get rounds => List.unmodifiable(_rounds);
  DateTime? get startTime => _startTime;
  DateTime? get endTime => _endTime;

  bool get isGameActive => _state == GameState.playing;
  bool get isGameFinished => _state == GameState.finished;

  List<DartThrow> get currentRoundThrows => _rounds[_currentRound - 1];

  List<int> get roundScores {
    return _rounds.map((round) {
      return round.fold<int>(0, (sum, dart) => sum + dart.score);
    }).toList();
  }

  double get averageScore {
    if (_rounds.isEmpty) return 0.0;
    final completedRounds = _rounds.where((round) => round.isNotEmpty).length;
    return completedRounds > 0 ? _totalScore / completedRounds : 0.0;
  }

  void startGame() {
    _state = GameState.playing;
    _startTime = DateTime.now();
    _currentRound = 1;
    _currentThrow = 1;
    _totalScore = 0;
    _initializeRounds();
  }

  void addThrow(DartThrow dartThrow) {
    if (!isGameActive) return;

    _rounds[_currentRound - 1].add(dartThrow);
    _totalScore += dartThrow.score;

    if (_currentThrow < throwsPerRound) {
      _currentThrow++;
    } else {
      _currentThrow = 1;
      if (_currentRound < maxRounds) {
        _currentRound++;
      } else {
        _finishGame();
      }
    }
  }

  void _finishGame() {
    _state = GameState.finished;
    _endTime = DateTime.now();
  }

  void resetGame() {
    _state = GameState.waiting;
    _currentRound = 1;
    _currentThrow = 1;
    _totalScore = 0;
    _startTime = null;
    _endTime = null;
    _initializeRounds();
  }

  Duration? get gameDuration {
    if (_startTime == null) return null;
    final endTime = _endTime ?? DateTime.now();
    return endTime.difference(_startTime!);
  }

  Map<String, dynamic> toJson() {
    return {
      'state': _state.toString(),
      'currentRound': _currentRound,
      'currentThrow': _currentThrow,
      'totalScore': _totalScore,
      'startTime': _startTime?.toIso8601String(),
      'endTime': _endTime?.toIso8601String(),
      'rounds': _rounds.map((round) => 
        round.map((dart) => {
          'position': dart.position,
          'score': dart.score,
          'timestamp': dart.timestamp.toIso8601String(),
        }).toList()
      ).toList(),
    };
  }
}