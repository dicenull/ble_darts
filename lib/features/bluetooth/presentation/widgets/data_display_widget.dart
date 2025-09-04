import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DataDisplayWidget extends HookWidget {
  final List<String> receivedData;
  final VoidCallback onClear;

  const DataDisplayWidget({
    super.key,
    required this.receivedData,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    // Auto scroll when new data arrives
    useEffect(() {
      if (receivedData.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
      return null;
    }, [receivedData.length]);
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
                  onPressed: onClear,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(60, 30),
                  ),
                  child: const Text('クリア'),
                ),
              ],
            ),
          ),
          Expanded(
            child: receivedData.isEmpty
                ? const Center(
                    child: Text(
                      'データを受信していません',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: receivedData.length,
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
                          receivedData[index],
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
}