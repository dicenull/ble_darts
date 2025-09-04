import 'package:ble_darts/features/count_up/presentation/count_up_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/multiplayer_count_up_provider.dart';

class PlayerSetupScreen extends HookConsumerWidget {
  const PlayerSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    void addPlayer(MultiplayerCountUpGameNotifier gameNotifier) {
      if (formKey.currentState!.validate()) {
        gameNotifier.addPlayer(nameController.text);
        nameController.clear();
      }
    }

    void startGame(
      BuildContext context,
      MultiplayerCountUpGameNotifier gameNotifier,
    ) {
      gameNotifier.startGame();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CountUpGameScreen()),
      );
    }

    // デフォルトでPlayer 1を追加
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final gameNotifier = ref.read(
          multiplayerCountUpGameNotifierProvider.notifier,
        );
        gameNotifier.addPlayer('Player 1');
      });
      return null;
    }, []);
    final game = ref.watch(multiplayerCountUpGameNotifierProvider);
    final gameNotifier = ref.read(
      multiplayerCountUpGameNotifierProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('カウントアップ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // プレイヤー追加フォーム
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            hintText: 'プレイヤー名',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '名前を入力してください';
                            }
                            if (game.players.any(
                              (p) => p.player.name == value.trim(),
                            )) {
                              return 'この名前は既に使用されています';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => addPlayer(gameNotifier),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => addPlayer(gameNotifier),
                        child: const Text('+'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // プレイヤーリスト
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (game.players.isNotEmpty) ...[
                        Expanded(
                          child: ListView.builder(
                            itemCount: game.players.length,
                            itemBuilder: (context, index) {
                              final playerData = game.players[index];
                              return Card(
                                color: index == 0
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer
                                    : null,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text('${index + 1}'),
                                  ),
                                  title: Text(
                                    playerData.player.name,
                                    style: TextStyle(
                                      fontWeight: index == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  trailing: game.players.length > 1
                                      ? IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () =>
                                              gameNotifier.removePlayer(
                                                playerData.player.id,
                                              ),
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ゲーム開始ボタン
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: game.players.isNotEmpty
                    ? () => startGame(context, gameNotifier)
                    : null,
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('START'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
