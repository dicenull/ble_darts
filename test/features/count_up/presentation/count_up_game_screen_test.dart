import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ble_darts/features/count_up/presentation/count_up_game_screen.dart';
import 'package:ble_darts/features/count_up/data/multiplayer_count_up_provider.dart';
import 'package:ble_darts/features/count_up/domain/multiplayer_count_up_game.dart';

void main() {
  group('CountUpGameScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget({bool withPlayers = false}) {
      return ProviderScope(
        parent: container,
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              if (withPlayers) {
                // プレイヤーを事前設定
                final notifier = container.read(
                  multiplayerCountUpGameNotifierProvider.notifier,
                );
                notifier.addPlayer('Test Player');
                notifier.startGame();
              }
              return const CountUpGameScreen();
            },
          ),
        ),
      );
    }

    testWidgets('CountUpGameScreenが正しく表示される', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(CountUpGameScreen), findsOneWidget);
    });

    testWidgets('ゲームが開始されていない場合の状態を処理する', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - ゲームが未開始の状態を適切に処理
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.state, equals(MultiplayerGameState.setup));
    });

    testWidgets('シングルプレイヤーゲーム状態が正しく表示される', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget(withPlayers: true));
      await tester.pumpAndSettle();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.state, equals(MultiplayerGameState.playing));
      expect(game.players.length, equals(1));
      expect(game.players[0].player.name, equals('Test Player'));
    });

    testWidgets('マルチプレイヤーゲーム状態が正しく管理される', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Player 1');
      notifier.addPlayer('Player 2');
      notifier.startGame();
      await tester.pumpAndSettle();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.state, equals(MultiplayerGameState.playing));
      expect(game.players.length, equals(2));
    });

    testWidgets('スローの追加が正しく動作する', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(withPlayers: true));
      await tester.pumpAndSettle();

      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );

      // Act
      notifier.addManualThrow('S20');
      await tester.pumpAndSettle();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.players[0].game.totalScore, equals(20));
      expect(game.players[0].game.currentThrow, equals(2));
    });

    testWidgets('ゲームリセット機能が動作する', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(withPlayers: true));
      await tester.pumpAndSettle();

      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addManualThrow('S20');
      await tester.pumpAndSettle();

      // Act
      notifier.resetGame();
      await tester.pumpAndSettle();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.state, equals(MultiplayerGameState.setup));
      expect(game.players[0].game.totalScore, equals(0));
    });

    testWidgets('ゲーム完了状態が正しく管理される', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(withPlayers: true));
      await tester.pumpAndSettle();

      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );

      // Act - ゲームを完了させる（8ラウンド × 3投 = 24投）
      for (int round = 0; round < 8; round++) {
        for (int throwInRound = 0; throwInRound < 3; throwInRound++) {
          notifier.addManualThrow('S20');
        }
      }
      await tester.pumpAndSettle();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.isGameFinished, isTrue);
      expect(game.state, equals(MultiplayerGameState.finished));
      expect(game.players[0].game.totalScore, equals(480));
    });

    testWidgets('統計情報が正しく更新される', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget(withPlayers: true));
      await tester.pumpAndSettle();

      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );

      // Act
      notifier.addManualThrow('T20'); // 60点
      notifier.addManualThrow('D20'); // 40点
      notifier.addManualThrow('S20'); // 20点
      await tester.pumpAndSettle();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.players[0].game.totalScore, equals(120));
      expect(game.players[0].game.currentRound, equals(2));
    });

    testWidgets('複数プレイヤーでの順番管理が動作する', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Player 1');
      notifier.addPlayer('Player 2');
      notifier.startGame();
      await tester.pumpAndSettle();

      // Act - Player 1が3投してPlayer 2のターンに移る
      notifier.addManualThrow('S20');
      notifier.addManualThrow('S20');
      notifier.addManualThrow('S20');
      await tester.pumpAndSettle();

      // Assert - プレイヤーの順番やゲームの進行状態
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.players[0].game.totalScore, equals(60)); // Player 1
      expect(game.players[1].game.totalScore, equals(0)); // Player 2はまだ投げていない
    });
  });
}
