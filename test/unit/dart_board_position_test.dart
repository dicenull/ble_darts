import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// DartBoardPainterの定数を再利用
class DartBoardConstants {
  static const List<int> numbers = [
    20,
    1,
    18,
    4,
    13,
    6,
    10,
    15,
    2,
    17,
    3,
    19,
    7,
    16,
    8,
    11,
    14,
    9,
    12,
    5,
  ];

  static const double outerDoubleRadius = .75;
  static const double innerDoubleRadius = .70;
  static const double outerSingleRadius = .70;
  static const double innerSingleRadius = .38;
  static const double outerTripleRadius = .38;
  static const double innerTripleRadius = .33;
  static const double innerInnerSingleRadius = .33;
  static const double outerBullRadius = .11;
  static const double innerBullRadius = .044;
}

String? calculatePositionFromOffset(Offset offset, Size size) {
  final center = Offset(size.width / 2, size.height / 2);
  final radius = math.min(size.width, size.height) / 2;

  final dx = offset.dx - center.dx;
  final dy = offset.dy - center.dy;
  final distance = math.sqrt(dx * dx + dy * dy);
  final angle = math.atan2(dy, dx);

  final normalizedDistance = distance / radius;

  if (normalizedDistance > DartBoardConstants.outerDoubleRadius + 0.05) {
    return null;
  }

  // ブル領域
  if (normalizedDistance <= DartBoardConstants.innerBullRadius) {
    return 'S-BULL';
  } else if (normalizedDistance <= DartBoardConstants.outerBullRadius) {
    return 'D-BULL';
  }

  // 角度を正規化
  double normalizedAngle = angle + math.pi / 2;
  if (normalizedAngle < 0) normalizedAngle += 2 * math.pi;
  if (normalizedAngle >= 2 * math.pi) normalizedAngle -= 2 * math.pi;

  final segmentAngle = 2 * math.pi / 20;
  final segmentIndex = (normalizedAngle / segmentAngle).round() % 20;
  final number = DartBoardConstants.numbers[segmentIndex];

  // 領域判定
  String prefix;
  if (normalizedDistance > DartBoardConstants.innerDoubleRadius &&
      normalizedDistance <= DartBoardConstants.outerDoubleRadius) {
    prefix = 'D';
  } else if (normalizedDistance > DartBoardConstants.innerSingleRadius &&
      normalizedDistance <= DartBoardConstants.innerDoubleRadius) {
    prefix = 'S';
  } else if (normalizedDistance > DartBoardConstants.innerTripleRadius &&
      normalizedDistance <= DartBoardConstants.outerTripleRadius) {
    prefix = 'T';
  } else if (normalizedDistance > DartBoardConstants.outerBullRadius &&
      normalizedDistance <= DartBoardConstants.innerTripleRadius) {
    prefix = 'S';
  } else {
    return null;
  }

  return '$prefix$number';
}

void main() {
  group('DartBoard Position Calculation Logic Tests', () {
    const size = Size(400, 400);
    const center = Offset(200, 200);

    test('should detect S-BULL at center', () {
      final position = calculatePositionFromOffset(center, size);
      expect(position, 'S-BULL');
    });

    test('should detect D-BULL in outer bull area', () {
      final position = calculatePositionFromOffset(
        Offset(center.dx + 20, center.dy),
        size,
      ); // 少し右にずらす
      expect(position, 'D-BULL');
    });

    test('should detect S20 at top single area', () {
      final radius = 200;
      final singleAreaRadius = radius * 0.5; // 内側シングル領域
      final position = calculatePositionFromOffset(
        Offset(center.dx, center.dy - singleAreaRadius),
        size,
      );
      // デバッグ: print('S20 test - position: $position, offset: ${Offset(center.dx, center.dy - singleAreaRadius)}');
      expect(position, 'S20');
    });

    test('should detect D20 at top double area', () {
      final radius = 200;
      final doubleAreaRadius = radius * 0.725; // ダブル領域の中央
      final position = calculatePositionFromOffset(
        Offset(center.dx, center.dy - doubleAreaRadius),
        size,
      );
      // デバッグ: print('D20 test - position: $position, offset: ${Offset(center.dx, center.dy - doubleAreaRadius)}');
      expect(position, 'D20');
    });

    test('should detect T20 at top triple area', () {
      final radius = 200;
      final tripleAreaRadius = radius * 0.355; // トリプル領域の中央
      final position = calculatePositionFromOffset(
        Offset(center.dx, center.dy - tripleAreaRadius),
        size,
      );
      // デバッグ: print('T20 test - position: $position, offset: ${Offset(center.dx, center.dy - tripleAreaRadius)}');
      expect(position, 'T20');
    });

    test('should test various positions around the board', () {
      final radius = 200;

      // 6番（右側）のシングル領域をテスト
      final sixSingleRadius = radius * 0.5;
      final sixPosition = calculatePositionFromOffset(
        Offset(center.dx + sixSingleRadius, center.dy),
        size,
      );
      expect(sixPosition, 'S6');

      // 3番（下側）のダブル領域をテスト
      final threeDblRadius = radius * 0.725;
      final threePosition = calculatePositionFromOffset(
        Offset(center.dx, center.dy + threeDblRadius),
        size,
      );
      expect(threePosition, 'D3');

      // 11番（左側）のトリプル領域をテスト
      final elevenTplRadius = radius * 0.355;
      final elevenPosition = calculatePositionFromOffset(
        Offset(center.dx - elevenTplRadius, center.dy),
        size,
      );
      expect(elevenPosition, 'T11');
    });
  });
}
