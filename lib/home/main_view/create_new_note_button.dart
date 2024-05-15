import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:provider/provider.dart";
import "package:think_simple/core/database/database_items.dart";
import "package:think_simple/core/database/isar_notifier.dart";
import "package:think_simple/core/widgets/animated_icon_change_rotation.dart";
import "package:think_simple/home/selected_note_notifier.dart";

class CreateNewNoteButton extends StatelessWidget {
  const CreateNewNoteButton({
    required this.leftBarIsOpen,
    required this.setLeftBarIsOpen,
    super.key,
  });

  final bool leftBarIsOpen;
  final Function(bool) setLeftBarIsOpen;

  @override
  Widget build(BuildContext context) {
    return AnimatedIconChangeScale(
      displayFirst: leftBarIsOpen,
      firstIcon: FloatingActionButton(
        mini: true,
        child: const Icon(Icons.add),
        onPressed: () async {
          final Isar isar = await context.read<IsarNotifier>().isarFuture;
          final Note newNote = Note(
            textContent: "",
            modifiedDate: DateTime.now(),
          );

          if (context.mounted) {
            await context.read<IsarNotifier>().runWriteOperation(
              writeOperation: () async {
                await isar.writeTxn(
                  () async {
                    final Id noteId = await isar.notes.put(newNote);
                    await isar.databasePages.put(
                      DatabasePage(
                        autoSnapshots: <int>[noteId],
                        manualSnapshots: <int>[],
                      ),
                    );
                    if (context.mounted) {
                      context.read<SelectedNoteNotifer>().updateNote(
                            newNote.copyWith(id: noteId),
                          );
                    }
                  },
                );
              },
            );
          }
          setLeftBarIsOpen(false);
        },
      ),
      secondIcon: const SizedBox.shrink(),
    );
  }
}
