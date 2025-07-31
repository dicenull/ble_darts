import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/multiplayer_count_up_provider.dart';
import '../../domain/multiplayer_count_up_game.dart';

class PlayerSetupWidget extends ConsumerStatefulWidget {
  const PlayerSetupWidget({super.key});

  @override
  ConsumerState<PlayerSetupWidget> createState() => _PlayerSetupWidgetState();
}

class _PlayerSetupWidgetState extends ConsumerState<PlayerSetupWidget> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(multiplayerCountUpGameNotifierProvider);
    final gameNotifier = ref.read(multiplayerCountUpGameNotifierProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            // プレイヤー追加フォーム
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'プレイヤー名',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '名前を入力してください';
                        }
                        if (game.players.any((p) => p.player.name == value.trim())) {
                          return 'この名前は既に使用されています';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _addPlayer(gameNotifier),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _addPlayer(gameNotifier),
                    child: const Text('+'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // プレイヤーリスト
            if (game.players.isNotEmpty) ...[
              ...game.players.asMap().entries.map((entry) {
                final index = entry.key;
                final playerData = entry.value;
                return Card(
                  color: playerData.isActive 
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      playerData.player.name,
                      style: TextStyle(
                        fontWeight: playerData.isActive 
                            ? FontWeight.bold 
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => gameNotifier.removePlayer(playerData.player.id),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),
            ],
            
            // ゲーム開始ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: game.hasPlayers ? () => gameNotifier.startGame() : null,
                child: const Text('START'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addPlayer(MultiplayerCountUpGameNotifier gameNotifier) {
    if (_formKey.currentState!.validate()) {
      gameNotifier.addPlayer(_nameController.text);
      _nameController.clear();
    }
  }
}