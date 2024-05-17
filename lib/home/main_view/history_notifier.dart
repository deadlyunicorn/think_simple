import "package:flutter/material.dart";
import "package:think_simple/core/database/database_items.dart";

class HistoryNotifier extends ChangeNotifier {
  List<Note> _historyStack;
  List<Note> get historyStack => _historyStack;
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  HistoryNotifier({
    required List<Note> historyStack,
  }) : _historyStack = historyStack;

  String? get currentTextContent => _currentIndex < _historyStack.length
      ? _historyStack[_currentIndex].textContent
      : null;

  bool get canUndo =>
      _currentIndex + 1 < _historyStack.length && _historyStack.isNotEmpty;

  bool get canRedo => _currentIndex > 0;

  void undo() {
    if (_currentIndex + 1 < _historyStack.length) {
      _currentIndex++;
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
    if (_currentIndex > 0) {
      _currentIndex--;
    }
    notifyListeners();
    //  if (textEditingController.text != currentTextContent) {
    //       setState(() {
    //         historyStack[currentIndex] = textEditingController.text;
    //       });
    //     }
  }

  void addToHistoryStack(Note newEntry) {
    //TODO: add Isar support ( add note to the current page.)
    if (newEntry.textContent != currentTextContent) {
      _currentIndex = 0;
      if (_historyStack.length == 10) {
        _historyStack.removeLast();
      }
      _historyStack.insert(0, newEntry);
    }

    notifyListeners();
  }

  void handleNewPageSelect({
    required List<Note> historyStack,
  }) {
    _historyStack = historyStack;
    print(historyStack);
    _currentIndex = 0;
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


