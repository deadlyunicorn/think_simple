import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:think_simple/core/database/database_items.dart";
import "package:think_simple/core/database/isar_notifier.dart";
import "package:think_simple/core/extensions/date_format.dart";
import "package:think_simple/core/widgets/column_with_spacings.dart";
import "package:think_simple/core/widgets/custom_alert_dialog.dart";
import "package:think_simple/home/main_view/history_notifier.dart";
import "package:think_simple/home/main_view/history_tracker.dart";

//TODO holding on an entry gets progressivelly more and more red
//TODO and finally there is a confirmation dialog asking to delete the entry.

class LeftSideBar extends StatelessWidget {
  const LeftSideBar({
    required this.availablePages,
    required this.setLeftBarIsOpen,
    required this.textEditingController,
    super.key,
  });

  final List<Note> availablePages;
  final void Function(bool) setLeftBarIsOpen;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    //? Re build when a new page is added or an existing has changed content
    //? So that we get correct previous.

    return Container(
      height: double.infinity,
      color: Theme.of(context).colorScheme.primary.withOpacity(0.02),
      child: availablePages.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 32.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                final Note noteFromList = availablePages[index];
                return ListTile(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => CustomAlertDialog(
                        confirmButtonAction: () async {
                          await context.read<IsarNotifier>().deletePage(
                                noteFromList,
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
                  onTap: () async {
                    final IsarNotifier isarNotifer =
                        context.read<IsarNotifier>();
                    await HistoryTracker.saveSnapshot(
                      isarNotifier: isarNotifer,
                      historyController: context.read<HistoryNotifier>(),
                      note: isarNotifer.currentNote.copyWith(
                        textContent: textEditingController.text,
                      ),
                    );
                    await isarNotifer.setCurrentNote(
                      newNote: noteFromList,
                      wasAutoSaved: true,
                    );

                    if (context.mounted) {
                      final List<Note> snapshots = await context
                          .read<IsarNotifier>()
                          .getSnapshots(pageId: noteFromList.pageId);
                      if (context.mounted) {
                        context.read<HistoryNotifier>().handleNewPageSelect(
                              historyStack: snapshots,
                            );
                      }
                    }
                    setLeftBarIsOpen(false);
                  },
                  title: ColumnWithSpacings(
                    spacing: 8,
                    children: <Widget>[
                      Text(
                        noteFromList.textContent.isNotEmpty
                            ? noteFromList.textContent
                            : "Empty Note.",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                        // ,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          noteFromList.modifiedDate.formatted,
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
              itemCount: availablePages.length,
            )
          : const Center(
              child: Text("No notes found"),
            ),
    );
  }
}
