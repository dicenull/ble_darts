import 'package:flutter/material.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final bool isConnected;
  final String? deviceName;
  final VoidCallback onDisconnect;

  const ConnectionStatusWidget({
    super.key,
    required this.isConnected,
    required this.deviceName,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    if (!isConnected) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('接続中: ${deviceName ?? 'Unknown'}'),
          ElevatedButton(onPressed: onDisconnect, child: const Text('切断')),
        ],
      ),
    );
  }
}