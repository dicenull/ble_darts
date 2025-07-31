import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ble_darts/features/count_up/presentation/player_setup_screen.dart';
import 'package:ble_darts/features/count_up/data/multiplayer_count_up_provider.dart';
import 'package:ble_darts/features/count_up/domain/multiplayer_count_up_game.dart';

void main() {
  group('PlayerSetupScreen', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget() {
      return ProviderScope(
        parent: container,
        child: const MaterialApp(home: PlayerSetupScreen()),
      );
    }

    testWidgets('PlayerSetupScreenが正しく表示される', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - 基本的な画面要素が表示される
      expect(find.byType(PlayerSetupScreen), findsOneWidget);
    });

    testWidgets('初期状態で正しく動作する', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Assert - 初期状態でゲームがセットアップ状態
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.state, equals(MultiplayerGameState.setup));
    });

    testWidgets('プレイヤー関連の基本操作が可能', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // プロバイダーを通じて直接プレイヤーを追加
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Test Player');
      await tester.pumpAndSettle();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.players.length, equals(1));
      expect(game.players[0].player.name, equals('Test Player'));
    });

    testWidgets('ゲーム開始が正しく動作する', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // プレイヤーを追加してゲーム開始
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Test Player');
      notifier.startGame();
      await tester.pumpAndSettle();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.state, equals(MultiplayerGameState.playing));
      expect(game.isGameActive, isTrue);
    });

    testWidgets('複数プレイヤーの管理が可能', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // 複数プレイヤーを追加
      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Player 1');
      notifier.addPlayer('Player 2');
      notifier.addPlayer('Player 3');
      await tester.pumpAndSettle();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.players.length, equals(3));
      expect(
        game.players.map((p) => p.player.name),
        containsAll(['Player 1', 'Player 2', 'Player 3']),
      );
    });

    testWidgets('プレイヤー削除が正しく動作する', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Player 1');
      notifier.addPlayer('Player 2');

      var game = container.read(multiplayerCountUpGameNotifierProvider);
      final player1Id = game.players[0].player.id;

      // Act
      notifier.removePlayer(player1Id);
      await tester.pumpAndSettle();

      // Assert
      game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.players.length, equals(1));
      expect(game.players[0].player.name, equals('Player 2'));
    });

    testWidgets('ゲームのリセット機能が動作する', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final notifier = container.read(
        multiplayerCountUpGameNotifierProvider.notifier,
      );
      notifier.addPlayer('Test Player');
      notifier.startGame();

      // Act
      notifier.resetGame();
      await tester.pumpAndSettle();

      // Assert
      final game = container.read(multiplayerCountUpGameNotifierProvider);
      expect(game.state, equals(MultiplayerGameState.setup));
      expect(game.isGameActive, isFalse);
    });
  });
}
