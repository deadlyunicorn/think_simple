import "package:flutter/material.dart";

class HistoryButtons extends StatefulWidget {
  const HistoryButtons({
    required this.historyController,
    super.key,
  });

  final UndoHistoryController historyController;

  @override
  State<HistoryButtons> createState() => _HistoryButtonsState();
}

class _HistoryButtonsState extends State<HistoryButtons> {
  @override
  void initState() {
    super.initState();

    widget.historyController.addListener(() {
      setState(() {
        canUndo = widget.historyController.value.canUndo;
        canRedo = widget.historyController.value.canRedo;
      });
    });
  }

  bool canUndo = false;
  bool canRedo = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: canUndo
              ? () {
                  widget.historyController.undo();
                }
              : null,
          icon: const Icon(
            Icons.undo,
          ),
        ),
        IconButton(
          onPressed: canRedo
              ? () {
                  widget.historyController.redo();
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
