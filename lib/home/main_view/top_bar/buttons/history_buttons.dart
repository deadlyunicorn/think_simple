import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:think_simple/home/main_view/history_notifier.dart";

class HistoryButtons extends StatelessWidget {
  const HistoryButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final HistoryNotifier historyController = context.watch<HistoryNotifier>();

    return Row(
      children: <Widget>[
        IconButton(
          onPressed: historyController.canUndo
              ? () {
                  historyController.undo();
                }
              : null,
          icon: const Icon(
            Icons.undo,
          ),
        ),
        IconButton(
          onPressed: historyController.canRedo
              ? () {
                  historyController.redo();
                }
              : null,
          icon: const Icon(
            Icons.redo,
          ),
        ),
      ],
    );
  }
}
