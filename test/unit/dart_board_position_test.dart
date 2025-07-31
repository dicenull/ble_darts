import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ble_darts/shared/models/dart_board_model.dart';

void main() {
  group('DartBoard Position Calculation Logic Tests', () {
    const size = Size(400, 400);
    const center = Offset(200, 200);

    test('should detect D-BULL at center', () {
      final position = DartBoardPosition.calculateFromOffset(center, size);
      expect(position, 'D-BULL');
    });

    test('should detect S-BULL in outer bull area', () {
      final position = DartBoardPosition.calculateFromOffset(
        Offset(center.dx + 20, center.dy),
        size,
      ); // 少し右にずらす
      expect(position, 'S-BULL');
    });

    test('should detect S20 at top single area', () {
      final radius = 200;
      final singleAreaRadius = radius * 0.5; // 内側シングル領域
      final position = DartBoardPosition.calculateFromOffset(
        Offset(center.dx, center.dy - singleAreaRadius),
        size,
      );
      expect(position, 'S20');
    });

    test('should detect D20 at top double area', () {
      final radius = 200;
      final doubleAreaRadius = radius * 0.725; // ダブル領域の中央
      final position = DartBoardPosition.calculateFromOffset(
        Offset(center.dx, center.dy - doubleAreaRadius),
        size,
      );
      expect(position, 'D20');
    });

    test('should detect T20 at top triple area', () {
      final radius = 200;
      final tripleAreaRadius = radius * 0.355; // トリプル領域の中央
      final position = DartBoardPosition.calculateFromOffset(
        Offset(center.dx, center.dy - tripleAreaRadius),
        size,
      );
      expect(position, 'T20');
    });

    test('should test various positions around the board', () {
      final radius = 200;

      // 6番（右側）のシングル領域をテスト
      final sixSingleRadius = radius * 0.5;
      final sixPosition = DartBoardPosition.calculateFromOffset(
        Offset(center.dx + sixSingleRadius, center.dy),
        size,
      );
      expect(sixPosition, 'S6');

      // 3番（下側）のダブル領域をテスト
      final threeDblRadius = radius * 0.725;
      final threePosition = DartBoardPosition.calculateFromOffset(
        Offset(center.dx, center.dy + threeDblRadius),
        size,
      );
      expect(threePosition, 'D3');

      // 11番（左側）のトリプル領域をテスト
      final elevenTplRadius = radius * 0.355;
      final elevenPosition = DartBoardPosition.calculateFromOffset(
        Offset(center.dx - elevenTplRadius, center.dy),
        size,
      );
      expect(elevenPosition, 'T11');
    });
  });
}
