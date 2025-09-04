import 'package:flutter/material.dart';

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