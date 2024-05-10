import "package:flutter/material.dart";

class HistoryNotifier extends ChangeNotifier {
  final List<String> historyStack = <String>[""];
  int currentIndex = 0;

  String? get currentTextContent =>
      currentIndex < historyStack.length ? historyStack[currentIndex] : null;

  bool get canUndo =>
      currentIndex + 1 < historyStack.length && historyStack.isNotEmpty;

  bool get canRedo => currentIndex > 0;

  void undo() {
    if (currentIndex + 1 < historyStack.length) {
      currentIndex++;
    }
    //   });
    //     if (textEditingController.text != currentTextContent) {
    //       setState(() {
    //         historyStack[currentIndex] = textEditingController.text;
    //       });
    //     }
    notifyListeners();
  }

  void redo() {
    if (currentIndex > 0) {
      currentIndex--;
    }
    notifyListeners();
    //  if (textEditingController.text != currentTextContent) {
    //       setState(() {
    //         historyStack[currentIndex] = textEditingController.text;
    //       });
    //     }
  }

  void addToHistoryStack(String newEntry) {
    if (newEntry != currentTextContent) {
      currentIndex = 0;
      if (historyStack.length == 10) {
        historyStack.removeLast();
      }
      historyStack.insert(0, newEntry);
    }

    notifyListeners();
  }
}

// @override
// void dispose() {
//   print("running");
//   final String textOnTrigger = textEditingController.text;

//   if (textOnTrigger != historyStack.firstOrNull) {
//     addToHistoryStack(textOnTrigger);
//   }

//   print(historyStack);
//   super.dispose();
// }


