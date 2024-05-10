import "package:flutter/material.dart";
import "package:think_simple/core/extensions/string_difference_comparison.dart";
import "package:think_simple/home/main_view/history_notifier.dart";

class HistoryTracker extends StatefulWidget {
  const HistoryTracker({
    required this.child,
    required this.historyController,
    super.key,
  });

  final Widget Function(
    TextEditingController textEditingController,
  ) child;

  final HistoryNotifier historyController;

  @override
  State<HistoryTracker> createState() => _HistoryTrackerState();
}

class _HistoryTrackerState extends State<HistoryTracker> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.historyController.addListener(() {
      //TODO Unfinished ( haven't given it a look. It is in a working state 11-05-2024 )
      final String? currentTextOnHistoryStack =
          widget.historyController.currentTextContent;
      if (currentTextOnHistoryStack != textEditingController.text &&
          currentTextOnHistoryStack != null) {
        textEditingController.text = currentTextOnHistoryStack;
      }
    });
    textEditingController.addListener(() {
      final String textOnTrigger = textEditingController.text;

      // if (currentIndex != 0 && textOnTrigger != currentTextContent) {
      //   setState(() {
      //     currentIndex = 0;
      //     historyStack.removeRange(0, currentIndex);
      //   });
      // }

      if (textOnTrigger.isNoticablyDifferentThan(
        widget.historyController.currentTextContent ?? "",
      )) {
        widget.historyController.addToHistoryStack(textEditingController.text);
      }

      Future<void>.delayed(const Duration(seconds: 3)).then((_) {
        if (textOnTrigger == textEditingController.text) {
          widget.historyController.addToHistoryStack(textOnTrigger);
        }
      });

      // });

      // historyController.onRedo.addListener(() {
      //   setState(() {
      //     if (currentIndex > 0) {
      //       currentIndex--;
      //     }
      //   });
      //   Future.delayed(Durations.short3).then((_) {
      //     if (textEditingController.text != currentTextContent) {
      //       setState(() {
      //         historyStack[currentIndex] = textEditingController.text;
      //       });
      //     }
      //   });
      // });
      // historyController.onUndo.addListener(() {
      //   setState(() {
      //     if (currentIndex + 1 < historyStack.length) {
      //       currentIndex++;
      //     }
      //   });
      //   Future.delayed(Durations.short3).then((_) {
      //     if (textEditingController.text != currentTextContent) {
      //       setState(() {
      //         historyStack[currentIndex] = textEditingController.text;
      //       });
      //     }
      //   });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("Index: $currentIndex, item: $currentTextContent");
    // print(historyStack);
    return widget.child(textEditingController);
  }
}
