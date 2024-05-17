import "dart:async";

import "package:flutter/material.dart";
import "package:think_simple/core/database/isar_notifier.dart";
import "package:think_simple/core/extensions/string_difference_comparison.dart";
import "package:think_simple/home/main_view/history_notifier.dart";

class HistoryTracker extends StatefulWidget {
  const HistoryTracker({
    required this.child,
    required this.historyController,
    required this.isarNotifier,
    super.key,
  });

  final Widget Function(
    TextEditingController textEditingController,
  ) child;

  final HistoryNotifier historyController;
  final IsarNotifier isarNotifier;

  @override
  State<HistoryTracker> createState() => _HistoryTrackerState();
}

class _HistoryTrackerState extends State<HistoryTracker> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textEditingController.text =
        widget.isarNotifier.availablePages.firstOrNull!.textContent;

    widget.historyController.addListener(
      () {
        textEditingController.text =
            widget.historyController.currentNote.textContent;
      },
    );

    //TODO disable normal CTRL + Z? and trigger our own Undos.
    textEditingController.addListener(() async {
      final String textOnTrigger = textEditingController.text;
      final int pageIdOnTrigger = widget.historyController.currentPageId;

      if (textOnTrigger.isNoticablyDifferentThan(
        widget.historyController.currentNote.textContent,
      )) {
        await widget.historyController.addToHistoryStack(
          isarNotifier: widget.isarNotifier,
          pageId: pageIdOnTrigger,
          textContent: textOnTrigger,
        );
      }

      await Future<void>.delayed(const Duration(seconds: 3)).then(
        (_) async {
          //TODO: Fix this. This fires multiple times when typing. ( if you undo slowly and then undo more and more you will get automatically continous insertions )
          if (textOnTrigger == textEditingController.text &&
              widget.historyController.currentPageId == pageIdOnTrigger) {
            await widget.historyController.addToHistoryStack(
              isarNotifier: widget.isarNotifier,
              pageId: pageIdOnTrigger,
              textContent: textOnTrigger,
            );
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("Index: $currentIndex, item: $currentTextContent");
    // print(historyStack);
    return widget.child(textEditingController);
  }
}
