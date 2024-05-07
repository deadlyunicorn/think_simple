import "package:flutter/material.dart";

class HistoryButtons extends StatelessWidget {
  const HistoryButtons({
    super.key,
  });

  final bool canUndo = false;
  final bool canRedo = false;

  //TODO Keep redo history until you overwrite.

  //TODO make it like max history: 30 and make it like FIFO (First in First out)

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          onPressed: canUndo ? () {} : null,
          icon: const Icon(
            Icons.undo,
          ),
        ),
        IconButton(
          onPressed: canRedo ? () {} : null,
          icon: const Icon(
            Icons.redo,
          ),
        ),
      ],
    );
  }
}
