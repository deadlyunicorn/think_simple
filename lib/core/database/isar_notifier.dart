import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:think_simple/core/database/database_items.dart";

class IsarNotifier extends ChangeNotifier {
  final Future<Isar> isarFuture;
  IsarNotifier({required this.isarFuture});

  List<Note> _availablePages = <Note>[];

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
    notifyListeners();
    return newNote;
  }

  Future<void> deletePage({
    required int pageId,
  }) async {
    final Isar isar = await isarFuture;

    await isar.writeTxn(
      () async {
        //? that also deletes all the related Notes.
        await isar.notes.filter().pageIdEqualTo(pageId).deleteAll();
      },
    );

    _availablePages = await getAvailablePages();
    notifyListeners();
  }

  Future<Note> createSnapshot({
    required String textContent,
    required int pageId,
    required bool wasAutoSaved,
  }) async {
    final Isar isar = await isarFuture;

    final List<Note> snapshots = await isar.notes
        .filter()
        .pageIdEqualTo(pageId)
        .wasAutoSavedEqualTo(wasAutoSaved)
        .sortByModifiedDateDesc()
        .findAll();
    if (snapshots.firstOrNull?.textContent == textContent) {
      return snapshots.first;
    }

    final DateTime modificationDate = DateTime.now();
    final Note noteToSnapshot = Note(
      textContent: textContent,
      modifiedDate: modificationDate,
      wasAutoSaved: wasAutoSaved,
      pageId: pageId,
    );
    final Id id = await isar.writeTxn(() async {
      return await isar.notes.put(
        noteToSnapshot,
      );
    });

    if (wasAutoSaved && snapshots.length > 10) {
      final List<Note> snapshotsToDelete = snapshots..removeRange(0, 9);
      await isar.writeTxn(
        () async {
          await isar.notes.deleteAll(
            snapshotsToDelete.map((Note note) => note.id).toList(),
          );
        },
      );
    }

    _availablePages = await getAvailablePages();

    notifyListeners();

    return Note(
      textContent: textContent,
      modifiedDate: modificationDate,
      wasAutoSaved: wasAutoSaved,
      pageId: pageId,
      id: id,
    );
  }

  Future<List<Note>> getSnapshots({
    required int pageId,
    required bool autoSavedSnapshots,
  }) async {
    final Isar isar = await isarFuture;
    return await isar.notes
        .filter()
        .pageIdEqualTo(pageId)
        .wasAutoSavedEqualTo(autoSavedSnapshots)
        .sortByModifiedDateDesc()
        .findAll();
  }

  Future<void> setAutoSavedSnapshots({
    required int pageId,
    required List<Note> newAutoSavedSnapshotList,
  }) async {
    final Isar isar = await isarFuture;

    await isar.writeTxn(
      () async {
        await isar.notes.filter().pageIdEqualTo(pageId).deleteAll();
        await isar.notes.putAll(newAutoSavedSnapshotList);
      },
    );
    _availablePages = await getAvailablePages();
    notifyListeners();
  }

  Future<void> deleteSnapshot({
    required int noteId,
  }) async {
    final Isar isar = await isarFuture;
    await isar.writeTxn(() async {
      await isar.notes.delete(noteId);
    });
    notifyListeners();
  }

  Future<List<Note>> getAvailablePages() async {
    List<Note> availablePages = await (await isarFuture)
        .notes
        .where()
        .sortByModifiedDateDesc()
        .distinctByPageId()
        .findAll();
    if (availablePages.isEmpty) {
      availablePages = <Note>[await createNewPage()];
    }

    _availablePages = availablePages;
    return availablePages;
  }

  Future<void> initialize() async {
    _availablePages = await getAvailablePages();
  }
}
