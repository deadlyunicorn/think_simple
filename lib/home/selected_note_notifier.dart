import "package:flutter/material.dart";
import "package:think_simple/core/database/database_items.dart";

class SelectedNoteNotifer extends ChangeNotifier {
  Note _selectedNote;
  Note get selectedNote => _selectedNote;

  void updateNote(Note newNote) {
    _selectedNote = newNote;
    notifyListeners();
  }

  SelectedNoteNotifer({
    required Note selectedNote,
  }) : _selectedNote = selectedNote;
}
