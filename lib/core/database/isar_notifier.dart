import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:think_simple/core/database/database_items.dart";

class IsarNotifier extends ChangeNotifier {
  final Future<Isar> isarFuture;

  late Note _currentNote;
  List<Note> _availablePages = <Note>[];

  Future<void> runWriteOperation({
    required Future<void> Function() writeOperation,
  }) async {
    await writeOperation();
    notifyListeners();
  }

  Note get currentNote => _currentNote;
  List<Note> get availablePages => _availablePages;

  Future<Note> createNewPage() async {
    final Isar isar = await isarFuture;

    final Note newNote = await isar.writeTxn(() async {
      final Note initialNote = Note(
        textContent: "",
        modifiedDate: DateTime.now(),
        wasAutoSaved: true,
        pageId: DateTime.now().microsecondsSinceEpoch,
      );
      final Id noteId = await isar.notes.put(
        initialNote,
      );

      return initialNote.copyWith(id: noteId);
    });
    _availablePages = await getAvailablePages();
    await setCurrentNote(
      newNote: newNote,
      wasAutoSaved: true,
    );
    print(newNote.textContent);
    print(_currentNote.textContent);
    notifyListeners();
    return newNote;
  }

  Future<void> deletePage(Note noteOfPage) async {
    final Isar isar = await isarFuture;

    await isar.writeTxn(
      () async {
        //TODO !!! add a method on IsarNotifer
        //? that also deletes all the related Notes.
        await isar.notes.filter().pageIdEqualTo(noteOfPage.pageId).deleteAll();
      },
    );

    _availablePages = await getAvailablePages();
    if (_availablePages.isEmpty) {
      await setCurrentNote(
        newNote: await createNewPage(),
        wasAutoSaved: true,
      );
    }
  }

  Future<void> initialize() async {
    final Isar isar = (await isarFuture);
    _currentNote = await isar.notes
        .where()
        .sortByModifiedDateDesc()
        .findFirst()
        .then((Note? note) async {
      if (note == null) {
        return await createNewPage();
      } else {
        return note;
      }
    });
    _availablePages = await getAvailablePages();
  }

  Future<void> setCurrentNote({
    required Note newNote,
    required bool wasAutoSaved,
  }) async {
    await createSnapshot(
      textContent: _currentNote.textContent,
      wasAutoSaved: wasAutoSaved,
    );
    _currentNote = newNote;
    notifyListeners();
  }

  Future<List<Note>> getAvailablePages() async {
    return await (await isarFuture)
        .notes
        .where()
        .sortByModifiedDateDesc()
        .distinctByPageId()
        .findAll();
  }

  Future<Note> createSnapshot({
    required String textContent,
    required bool wasAutoSaved,
  }) async {
    if (_currentNote.textContent == textContent) return currentNote;
    final Isar isar = await isarFuture;
    final DateTime modificationDate = DateTime.now();
    final Note newNote = Note(
      textContent: textContent,
      modifiedDate: modificationDate,
      wasAutoSaved: wasAutoSaved,
      pageId: _currentNote.pageId,
    );
    final Id id = await isar.writeTxn(() async {
      return await isar.notes.put(
        newNote,
      );
    });

    await setCurrentNote(
      newNote: newNote.copyWith(id: id),
      wasAutoSaved: wasAutoSaved,
    );

    if (wasAutoSaved) {
      final List<Note> snapshots = await isar.notes
          .filter()
          .pageIdEqualTo(_currentNote.pageId)
          .wasAutoSavedEqualTo(true)
          .sortByModifiedDateDesc()
          .findAll();
      if (snapshots.length > 10) {
        final List<Note> snapshotsToDelete = snapshots..removeRange(0, 10);
        await isar.writeTxn(
          () async {
            await isar.notes.deleteAll(
              snapshotsToDelete.map((Note note) => note.id).toList(),
            );
          },
        );
      }
    }

    _availablePages = await getAvailablePages();

    notifyListeners();

    return Note(
      textContent: textContent,
      modifiedDate: modificationDate,
      wasAutoSaved: wasAutoSaved,
      pageId: _currentNote.pageId,
      id: id,
    );
  }

  IsarNotifier({required this.isarFuture});

  Future<List<Note>> getSnapshots({
    required int pageId,
  }) async {
    final Isar isar = await isarFuture;
    return await isar.notes
        .filter()
        .pageIdEqualTo(pageId)
        .sortByModifiedDateDesc()
        .findAll();
  }
}
