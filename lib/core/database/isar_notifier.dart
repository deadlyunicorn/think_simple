import "package:flutter/material.dart";
import "package:isar/isar.dart";

class IsarNotifier extends ChangeNotifier {
  final Future<Isar> isarFuture;
  int _currentNoteId = -1;

  Future<void> runWriteOperation({
    required Future<void> Function() writeOperation,
  }) async {
    await writeOperation();
    notifyListeners();
  }

  int get currentNoteId => _currentNoteId;
  void setCurrentNoteId(int newId) {
    _currentNoteId = newId;
    notifyListeners();
  }

  IsarNotifier({required this.isarFuture});
}
