// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ble_darts/main.dart';

void main() {
  testWidgets('BLE Dartsアプリのスモークテスト', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MyApp(),
      ),
    );

    // Wait for the app to initialize
    await tester.pumpAndSettle();

    // Verify that our app loads with the correct title.
    expect(find.text('BLE Darts (Mobile)'), findsOneWidget);
    
    // Verify that bluetooth connection info is shown.
    expect(find.text('モバイル環境でのBluetooth接続'), findsOneWidget);
    
    // Verify that device scan button is present.
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
