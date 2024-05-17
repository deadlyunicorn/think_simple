import "dart:async";

import "package:flutter/material.dart";
import "package:think_simple/core/database/database_items.dart";
import "package:think_simple/core/database/isar_notifier.dart";
import "package:think_simple/core/extensions/string_difference_comparison.dart";
import "package:think_simple/home/main_view/history_notifier.dart";

class HistoryTracker extends StatefulWidget {
  //TODO history tracker gets the notes with the same pageId

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

  static Future<void> saveSnapshot({
    required Note note,
    required HistoryNotifier historyController,
    required IsarNotifier isarNotifier,
  }) async {
    if (historyController.historyStack.firstOrNull?.textContent !=
        note.textContent) {
      historyController.addToHistoryStack(
        Note(
          textContent: note.textContent,
          modifiedDate: DateTime.now(),
          wasAutoSaved: true,
          pageId: note.pageId,
        ),
      );
      await isarNotifier.createSnapshot(
        textContent: note.textContent,
        wasAutoSaved: true,
      );
    }
  }

  @override
  State<HistoryTracker> createState() => _HistoryTrackerState();
}

class _HistoryTrackerState extends State<HistoryTracker> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textEditingController.text = widget.isarNotifier.currentNote.textContent;

    // widget.isarNotifier.addListener(() async {
    //   // textEditingController.text = widget.isarNotifier.currentNote.textContent;

    //   print("Added new note");
    // });

    widget.historyController.addListener(() {
      //!! Only triggers if canUndo or canRedo changes
      //!! NOT when there is a new history entry.
      //TODO Unfinished ( haven't given it a look. It is in a working state 11-05-2024 )
      final String? currentTextOnHistoryStack =
          widget.historyController.currentTextContent;
      if (currentTextOnHistoryStack == null) {
        textEditingController.text = "";
      } else if (currentTextOnHistoryStack != textEditingController.text) {
        textEditingController.text = currentTextOnHistoryStack;
      }
    });

    //TODO disable normal CTRL + Z? and trigger our own Undos.
    textEditingController.addListener(() async {
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
        await HistoryTracker.saveSnapshot(
          isarNotifier: widget.isarNotifier,
          historyController: widget.historyController,
          note: widget.isarNotifier.currentNote.copyWith(
            textContent: textEditingController.text,
          ),
        );
      }

      await Future<void>.delayed(const Duration(seconds: 3)).then(
        (_) async {
          if (textOnTrigger == textEditingController.text) {
            await HistoryTracker.saveSnapshot(
              isarNotifier: widget.isarNotifier,
              historyController: widget.historyController,
              note: widget.isarNotifier.currentNote.copyWith(
                textContent: textOnTrigger,
              ),
            );
          }
        },
      );

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

//TODO !!! UNFIN