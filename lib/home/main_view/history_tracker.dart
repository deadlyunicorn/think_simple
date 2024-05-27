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
  bool timeoutIsRunning = false;

  @override
  void initState() {
    super.initState();

    textEditingController.text =
        widget.isarNotifier.availablePages.firstOrNull!.textContent;

    widget.historyController.addListener(
      () {
        if (textEditingController.text !=
            widget.historyController.currentNote.textContent) {
          final TextSelection selectionBeforeChange =
              textEditingController.selection;

          textEditingController.text =
              widget.historyController.currentNote.textContent;

          if (textEditingController.text.isNotEmpty) {
            //? prevents setting the position of the cursor
            //? to the end of the string.
            //? when adding from a place other than the end
            textEditingController.selection = selectionBeforeChange;
          }
        }
      },
    );

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

      if (!timeoutIsRunning) {
        timeoutIsRunning = true;
        await runTimerForAutosave(
          pageIdOnTrigger: pageIdOnTrigger,
          textOnTrigger: textOnTrigger,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("Index: $currentIndex, item: $currentTextContent");
    // print(historyStack);
    return widget.child(textEditingController);
  }

  Future<void> runTimerForAutosave({
    required String textOnTrigger,
    required int pageIdOnTrigger,
  }) async {
    return await Future<void>.delayed(const Duration(seconds: 3)).then(
      (_) async {
        final String currentText = textEditingController.text;
        final int currentPageId = widget.historyController.currentPageId;

        if (textOnTrigger == currentText && currentPageId == pageIdOnTrigger) {
          await widget.historyController.addToHistoryStack(
            isarNotifier: widget.isarNotifier,
            pageId: pageIdOnTrigger,
            textContent: textOnTrigger,
          );
          timeoutIsRunning = false;
        } else {
          await runTimerForAutosave(
            textOnTrigger: currentText,
            pageIdOnTrigger: currentPageId,
          );
        }
      },
    );
  }
}
