class DartThrow {
  final String position;
  final int score;
  final DateTime timestamp;

  DartThrow({
    required this.position,
    required this.score,
    required this.timestamp,
  });

  static DartThrow fromDartsLiveData(String dartsLivePosition) {
    return DartThrow(
      position: dartsLivePosition,
      score: _calculateScore(dartsLivePosition),
      timestamp: DateTime.now(),
    );
  }

  static int _calculateScore(String position) {
    if (position == 'S-BULL') return 50;
    if (position == 'D-BULL') return 50;
    if (position == 'CHANGE') return 0;

    final regex = RegExp(r'([SDT])(\d+)');
    final match = regex.firstMatch(position);

    if (match == null) return 0;

    final multiplier = match.group(1);
    final number = int.parse(match.group(2)!);

    switch (multiplier) {
      case 'S':
        return number;
      case 'D':
        return number * 2;
      case 'T':
        return number * 3;
      default:
        return 0;
    }
  }

  @override
  String toString() {
    return 'DartThrow(position: $position, score: $score, timestamp: $timestamp)';
  }
}
