import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:provider/provider.dart";
import "package:think_simple/core/database/database_items.dart";
import "package:think_simple/core/database/isar_notifier.dart";
import "package:think_simple/core/extensions/date_format.dart";
import "package:think_simple/core/widgets/column_with_spacings.dart";
import "package:think_simple/core/widgets/custom_alert_dialog.dart";
import "package:think_simple/home/selected_note_notifier.dart";

//TODO holding on an entry gets progressivelly more and more red
//TODO and finally there is a confirmation dialog asking to delete the entry.

class LeftSideBar extends StatelessWidget {
  const LeftSideBar({
    required this.pages,
    required this.setLeftBarIsOpen,
    super.key,
  });

  final List<CompletePage> pages;
  final void Function(bool) setLeftBarIsOpen;

  @override
  Widget build(BuildContext context) {
    //? Re build when a new page is added or an existing has changed content
    //? So that we get correct previous.

    return Container(
      height: double.infinity,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.02),
      child: pages.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 32.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                final Note currentNote = pages[index].currentNote;
                return ListTile(
                  onLongPress: () {
                    final SelectedNoteNotifer selectedNoteNotefier =
                        context.read<SelectedNoteNotifer>();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomAlertDialog(
                        confirmButtonAction: () async {
                          final IsarNotifier isarNotifier =
                              context.read<IsarNotifier>();
                          final Isar isar = await isarNotifier.isarFuture;

                          await isarNotifier.runWriteOperation(
                            writeOperation: () async {
                              await isar.writeTxn(
                                () async {
                                  //TODO !!! add a method on IsarNotifer
                                  //? that also deletes all the related Notes.
                                  if (await isar.databasePages.delete(
                                    pages[index].currentPage.id,
                                  )) {
                                    if (context.mounted) {
                                      selectedNoteNotefier.updateNote(null);
                                    }
                                  }
                                },
                              );
                            },
                          );

                          if (context.mounted) {
                            Navigator.of(context).popUntil(
                              (Route<void> route) => route.isFirst,
                            );
                          }
                        },
                        title: "Delete note",
                        child: const Text(
                          "You are about to delete the selected note.",
                        ),
                      ),
                    );
                  },
                  onTap: () {
                    context.read<SelectedNoteNotifer>().updateNote(currentNote);
                    setLeftBarIsOpen(false);
                  },
                  title: ColumnWithSpacings(
                    spacing: 8,
                    children: <Widget>[
                      Text(
                        currentNote.textContent.isNotEmpty
                            ? currentNote.textContent
                            : "Empty Note.",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                        // ,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          currentNote.modifiedDate.formatted,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: pages.length,
            )
          : const Center(
              child: Text("No notes found"),
            ),
    );
  }
}
