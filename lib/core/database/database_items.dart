import "package:isar/isar.dart";

part "database_items.g.dart";

@collection
class Note {
  Id id; // you can also use id = null to auto increment

  final String textContent;
  final DateTime modifiedDate;

  Note({required this.textContent, required this.modifiedDate, Id? id})
      : id = id ?? Isar.autoIncrement;

  Note copyWith({
    Id? id,
    String? textContent,
    DateTime? modifiedDate,
  }) {
    return Note(
      textContent: textContent ?? this.textContent,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      id: id ?? this.id,
    );
  }
}

@collection
class DatabasePage {
  // The id of the page.
  Id id = Isar.autoIncrement;

  //* This should keep track of the last 30 snapshots.
  //? Snapshots store the ids of the Notes belonging to the page.
  //? must be sorted by date.

  List<int> _autoSnapshots;
  List<int> get autoSnapshots => _autoSnapshots;
  void setAutoSnapshots(List<int> newState) {
    lastModified = DateTime.now();
    _autoSnapshots = newState;
  }

  //* This should keep track of snapshots taken by the user ( not-limited ).
  List<int> manualSnapshots;

  DateTime lastModified = DateTime(1970);

  DatabasePage({
    required List<int> autoSnapshots,
    required this.manualSnapshots,
  }) : _autoSnapshots = autoSnapshots;

  //TODO selecting an older auto snapshot should not delete the other ones until you press "RESTORE TO THIS POINT"
  //? It should work as a preview. Definitely don't delete the manual snapshots.
}

class CompletePage {
  CompletePage({
    required this.currentPage,
    required this.currentNote,
  });

  //? snapshots are stored here
  DatabasePage currentPage;

  //? our current state
  Note currentNote;
}
