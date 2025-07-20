import 'package:flutter_test/flutter_test.dart';
import 'package:ble_darts/shared/models/dart_throw.dart';

void main() {
  group('DartThrow', () {
    test('正しい値でDartThrowを作成できる', () {
      // Arrange
      final timestamp = DateTime.now();

      // Act
      final dartThrow = DartThrow(
        position: 'S20',
        score: 20,
        timestamp: timestamp,
      );

      // Assert
      expect(dartThrow.position, equals('S20'));
      expect(dartThrow.score, equals(20));
      expect(dartThrow.timestamp, equals(timestamp));
    });

    test('シングルのスコアを正しく計算できる', () {
      // Arrange
      const position = 'S20';

      // Act
      final dartThrow = DartThrowX.fromDartsLiveData(position);

      // Assert
      expect(dartThrow.position, equals('S20'));
      expect(dartThrow.score, equals(20));
    });

    test('ダブルのスコアを正しく計算できる', () {
      // Arrange
      const position = 'D20';

      // Act
      final dartThrow = DartThrowX.fromDartsLiveData(position);

      // Assert
      expect(dartThrow.position, equals('D20'));
      expect(dartThrow.score, equals(40));
    });

    test('トリプルのスコアを正しく計算できる', () {
      // Arrange
      const position = 'T20';

      // Act
      final dartThrow = DartThrowX.fromDartsLiveData(position);

      // Assert
      expect(dartThrow.position, equals('T20'));
      expect(dartThrow.score, equals(60));
    });

    test('BULLのスコアを正しく計算できる', () {
      // Arrange
      const position = 'BULL';

      // Act
      final dartThrow = DartThrowX.fromDartsLiveData(position);

      // Assert
      expect(dartThrow.position, equals('BULL'));
      expect(dartThrow.score, equals(50));
    });

    test('D-BULLのスコアを正しく計算できる', () {
      // Arrange
      const position = 'D-BULL';

      // Act
      final dartThrow = DartThrowX.fromDartsLiveData(position);

      // Assert
      expect(dartThrow.position, equals('D-BULL'));
      expect(dartThrow.score, equals(25));
    });

    test('CHANGEのスコアを0として計算できる', () {
      // Arrange
      const position = 'CHANGE';

      // Act
      final dartThrow = DartThrowX.fromDartsLiveData(position);

      // Assert
      expect(dartThrow.position, equals('CHANGE'));
      expect(dartThrow.score, equals(0));
    });

    test('無効なポジションのスコアを0として計算できる', () {
      // Arrange
      const position = 'INVALID';

      // Act
      final dartThrow = DartThrowX.fromDartsLiveData(position);

      // Assert
      expect(dartThrow.position, equals('INVALID'));
      expect(dartThrow.score, equals(0));
    });

    test('すべてのダーツポジションを正しく処理できる', () {
      // Arrange
      const expectedNumbers = [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
      ];

      // Act & Assert
      for (int i in expectedNumbers) {
        final single = DartThrowX.fromDartsLiveData('S$i');
        final double = DartThrowX.fromDartsLiveData('D$i');
        final triple = DartThrowX.fromDartsLiveData('T$i');

        expect(single.score, equals(i));
        expect(double.score, equals(i * 2));
        expect(triple.score, equals(i * 3));
      }
    });
  });
}
