import "package:isar/isar.dart";

part "database_items.g.dart";

@collection
class Note {
  final Id id; // you can also use id = null to auto increment

  final String textContent;
  final DateTime modifiedDate;

  final bool wasAutoSaved;
  final int pageId;

  Note({
    required this.textContent,
    required this.modifiedDate,
    required this.wasAutoSaved,
    required this.pageId,
    this.id = Isar.autoIncrement,
  });

  Note copyWith({
    String? textContent,
    DateTime? modifiedDate,
    bool? wasAutoSaved,
    int? pageId,
    int? id,
  }) {
    return Note(
      textContent: textContent ?? this.textContent,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      wasAutoSaved: wasAutoSaved ?? this.wasAutoSaved,
      pageId: pageId ?? this.pageId,
      id: id ?? this.id,
    );
  }
}
