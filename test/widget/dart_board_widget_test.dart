import 'package:ble_darts/features/count_up/presentation/widgets/dart_board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DartBoardWidget Position Calculation Tests', () {
    testWidgets('should detect center bull position', (
      WidgetTester tester,
    ) async {
      String? detectedPosition;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: DartBoardWidget(
                onPositionTapped: (position) {
                  detectedPosition = position;
                },
              ),
            ),
          ),
        ),
      );

      // ウィジェットサイズを取得
      final dartBoardFinder = find.byType(DartBoardWidget);
      expect(dartBoardFinder, findsOneWidget);

      // ダーツボードの中心をタップ
      await tester.tapAt(tester.getCenter(dartBoardFinder));
      await tester.pump();

      expect(detectedPosition, 'BULL');
    });

    testWidgets('should detect outer bull position', (
      WidgetTester tester,
    ) async {
      String? detectedPosition;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DartBoardWidget(
                onPositionTapped: (position) {
                  detectedPosition = position;
                },
              ),
            ),
          ),
        ),
      );

      // 外側ブル領域をタップ（中心から少し離れた位置）
      await tester.tapAt(const Offset(160, 150));
      await tester.pump();

      expect(detectedPosition, 'D-BULL');
    });

    testWidgets('should detect S20 position (top)', (
      WidgetTester tester,
    ) async {
      String? detectedPosition;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DartBoardWidget(
                onPositionTapped: (position) {
                  detectedPosition = position;
                },
              ),
            ),
          ),
        ),
      );

      // 20番のシングル領域をタップ（上部）
      await tester.tapAt(const Offset(150, 80));
      await tester.pump();

      expect(detectedPosition, 'S20');
    });

    testWidgets('should detect D20 position (top double)', (
      WidgetTester tester,
    ) async {
      String? detectedPosition;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DartBoardWidget(
                onPositionTapped: (position) {
                  detectedPosition = position;
                },
              ),
            ),
          ),
        ),
      );

      // 20番のダブル領域をタップ（上部外側）
      await tester.tapAt(const Offset(150, 60));
      await tester.pump();

      expect(detectedPosition, 'D20');
    });

    testWidgets('should detect T20 position (top triple)', (
      WidgetTester tester,
    ) async {
      String? detectedPosition;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DartBoardWidget(
                onPositionTapped: (position) {
                  detectedPosition = position;
                },
              ),
            ),
          ),
        ),
      );

      // 20番のトリプル領域をタップ（上部中間）
      await tester.tapAt(const Offset(150, 95));
      await tester.pump();

      expect(detectedPosition, 'T20');
    });
  });
}
