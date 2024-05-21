import "dart:math";

import "package:flutter/material.dart";
import "package:think_simple/core/database/database_items.dart";
import "package:think_simple/core/database/isar_notifier.dart";
import "package:think_simple/core/errors/exceptions.dart";

class HistoryNotifier extends ChangeNotifier {
  List<Note> _autoSavedHistoryStack;
  List<Note> get autoSavedHistoryStack => _autoSavedHistoryStack;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  int _currentPageId;
  int get currentPageId => _currentPageId;

  Note get currentNote => _autoSavedHistoryStack[_currentIndex];

  HistoryNotifier({
    required List<Note> autoSavedHistoryStack,
    //? The non auto saved history stack is accessed at the pressed of a button
    //? inside its own route.
    required int pageId,
  })  : _autoSavedHistoryStack = autoSavedHistoryStack,
        _currentPageId = pageId;

  bool get canUndo =>
      _currentIndex + 1 < _autoSavedHistoryStack.length &&
      _autoSavedHistoryStack.isNotEmpty;

  bool get canRedo => _currentIndex > 0;

  void undo() {
    if (_currentIndex + 1 < _autoSavedHistoryStack.length) {
      _currentIndex++;
    }
    notifyListeners();
  }

  void redo() {
    if (_currentIndex > 0) {
      _currentIndex--;
    }
    notifyListeners();
  }

  Future<List<Note>> addToHistoryStack({
    required IsarNotifier isarNotifier,
    required int pageId,
    required String textContent,
  }) async {
    final List<Note> snapshots = await isarNotifier.getSnapshots(
      pageId: pageId,
      autoSavedSnapshots: true,
    );

    if (snapshots.firstOrNull?.textContent != textContent) {
      final Note snapshot = await isarNotifier.createSnapshot(
        textContent: textContent,
        pageId: pageId,
        wasAutoSaved: true,
      );
      _currentIndex = 0;
      if (_autoSavedHistoryStack.length == 10) {
        _autoSavedHistoryStack.removeLast();
      }
      _autoSavedHistoryStack.insert(
        0,
        snapshot,
      );
      notifyListeners();
    }

    return _autoSavedHistoryStack;
  }

  Future<void> handlePageSelect({
    required String previousTextContent,
    required int newPageId,
    required List<Note> newHistoryStack,
    required IsarNotifier isarNotifier,
  }) async {
    //! DANGEROUS block of code

    final int noteIndexOnTrigger = currentIndex;
    _currentIndex = 0;

    final List<Note> currentSnapshots = noteIndexOnTrigger == 0
        ? await addToHistoryStack(
            pageId: currentPageId,
            textContent: previousTextContent,
            isarNotifier: isarNotifier,
          )
        : List<Note>.from(autoSavedHistoryStack);

    currentSnapshots.removeRange(
      noteIndexOnTrigger != 0 ? 0 : 1,
      max(noteIndexOnTrigger, 1),
    );
    if (currentSnapshots != autoSavedHistoryStack) {
      await isarNotifier.setAutoSavedSnapshots(
        pageId: currentPageId,
        newAutoSavedSnapshotList: currentSnapshots,
      );
    }

    _autoSavedHistoryStack = newHistoryStack;
    _currentPageId = newPageId;

    notifyListeners();
    throw PageChangedException();
  }
}
