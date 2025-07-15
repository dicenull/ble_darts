import 'package:flutter/material.dart';
import '../../domain/bluetooth_device.dart';

class BluetoothDeviceListWidget extends StatelessWidget {
  final List<BluetoothDeviceInfo> devices;
  final BluetoothDeviceInfo? connectedDevice;
  final Function(BluetoothDeviceInfo) onDeviceConnect;
  final bool isWeb;

  const BluetoothDeviceListWidget({
    super.key,
    required this.devices,
    required this.connectedDevice,
    required this.onDeviceConnect,
    required this.isWeb,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        final isConnected = _isDeviceConnected(device);

        return ListTile(
          leading: const Icon(Icons.bluetooth),
          title: Text(device.name),
          subtitle: Text(device.address),
          trailing: isConnected
              ? const Icon(Icons.check_circle, color: Colors.green)
              : ElevatedButton(
                  onPressed: () => onDeviceConnect(device),
                  child: const Text('接続'),
                ),
        );
      },
    );
  }

  bool _isDeviceConnected(BluetoothDeviceInfo device) {
    if (connectedDevice == null) return false;
    return connectedDevice!.id == device.id;
  }
}

class DataDisplayWidget extends StatefulWidget {
  final List<String> receivedData;
  final VoidCallback onClear;

  const DataDisplayWidget({
    super.key,
    required this.receivedData,
    required this.onClear,
  });

  @override
  State<DataDisplayWidget> createState() => _DataDisplayWidgetState();
}

class _DataDisplayWidgetState extends State<DataDisplayWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(DataDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.receivedData.length > oldWidget.receivedData.length) {
      _autoScroll();
    }
  }

  void _autoScroll() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(7),
                topRight: Radius.circular(7),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '受信データ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: widget.onClear,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(60, 30),
                  ),
                  child: const Text('クリア'),
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.receivedData.isEmpty
                ? const Center(
                    child: Text(
                      'データを受信していません',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: widget.receivedData.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: Text(
                          widget.receivedData[index],
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

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