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