import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:provider/provider.dart";
import "package:think_simple/core/database/database_items.dart";
import "package:think_simple/core/database/isar_notifier.dart";

//TODO holding on an entry gets progressivelly more and more red
//TODO and finally there is a confirmation dialog asking to delete the entry.

class LeftSideBar extends StatelessWidget {
  const LeftSideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //? Re build when a new page is added or an existing has changed content
    //? So that we get correct previous.
    return FutureBuilder<List<CompletePage>>(
      future: getAvailablePagesLastNote(context),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<CompletePage>> snapshot,
      ) {
        final List<CompletePage> pages = snapshot.data ?? <CompletePage>[];
        print(pages.length);

        return Container(
          height: double.infinity,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.02),
          child: pages.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(
                    //TODO: IMPROVE
                    vertical: 32.0,
                  ),
                  itemBuilder: (context, index) => SizedBox(
                      height: 96,
                      child: Text(pages[index].currentNote.textContent)),
                  itemCount: pages.length,
                )
              : Center(
                  child: TextButton(
                    child: Text("No pages found"),
                    onPressed: () async {
                      final isar =
                          await context.read<IsarNotifier>().isarFuture;
                      final newNote = Note(
                          textContent: "hello world",
                          modifiedDate: DateTime.now());
                      await isar.writeTxn(() async {
                        final noteId = await isar.notes.put(newNote);

                        await isar.databasePages.put(DatabasePage(
                            autoSnapshots: [noteId], manualSnapshots: []));
                      });
                    },
                  ),
                ),
        );

        //TODO add a stack circular button that creates a new page.
      },
    );
  }

  Future<List<CompletePage>> getAvailablePagesLastNote(
    BuildContext context,
  ) async {
    final Isar isar = await context.watch<IsarNotifier>().isarFuture;

    final List<CompletePage> completePages = <CompletePage>[];
    final List<DatabasePage> databasePages =
        await isar.databasePages.where().findAll();
    final List<Note?> tempNotes = await Future.wait(
      databasePages.map(
        (DatabasePage databasePage) =>
            databasePage.autoSnapshots.lastOrNull != null
                ? isar.notes
                    .filter()
                    .idEqualTo(databasePage.autoSnapshots.last)
                    .findFirst()
                : Future.value(null),
      ),
    );

    print("temps: ${tempNotes.map((e) => e?.textContent)}");

    for (int i = 0; i < databasePages.length; i++) {
      if (tempNotes[i] != null) {
        completePages.add(
          CompletePage(
            currentPage: databasePages[i],
            currentNote: tempNotes[i]!,
          ),
        );
      }
    }

    print(completePages.length);

    return completePages;
  }
}
