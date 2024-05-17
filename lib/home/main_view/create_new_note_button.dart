import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:think_simple/core/database/database_items.dart";
import "package:think_simple/core/database/isar_notifier.dart";
import "package:think_simple/core/widgets/animated_icon_change_rotation.dart";
import "package:think_simple/home/main_view/history_notifier.dart";
import "package:think_simple/home/main_view/history_tracker.dart";

class CreateNewNoteButton extends StatelessWidget {
  const CreateNewNoteButton({
    required this.leftBarIsOpen,
    required this.setLeftBarIsOpen,
    required this.textEditingController,
    super.key,
  });

  final bool leftBarIsOpen;
  final Function(bool) setLeftBarIsOpen;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return AnimatedIconChangeScale(
      displayFirst: leftBarIsOpen,
      firstIcon: FloatingActionButton(
        mini: true,
        child: const Icon(Icons.add),
        onPressed: () async {
          final IsarNotifier isarNotifier = context.read<IsarNotifier>();
          final HistoryNotifier historyController =
              context.read<HistoryNotifier>();
          await HistoryTracker.saveSnapshot(
            isarNotifier: isarNotifier,
            historyController: historyController,
            note: Note(
              textContent: textEditingController.text,
              modifiedDate: DateTime.now(),
              wasAutoSaved: true,
              pageId: isarNotifier.currentNote.pageId,
            ),
          );
          if (context.mounted) {
            await context.read<IsarNotifier>().createNewPage();
          }

          if (context.mounted) {
            context.read<HistoryNotifier>().handleNewPageSelect(
              historyStack: <Note>[],
            );
          }
        },
      ),
      secondIcon: const SizedBox.shrink(),
    );
  }
}
