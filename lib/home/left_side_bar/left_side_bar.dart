import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:think_simple/core/database/database_items.dart";
import "package:think_simple/core/database/isar_notifier.dart";
import "package:think_simple/core/errors/exceptions.dart";
import "package:think_simple/core/extensions/date_format.dart";
import "package:think_simple/core/widgets/column_with_spacings.dart";
import "package:think_simple/core/widgets/custom_alert_dialog.dart";
import "package:think_simple/home/main_view/history_notifier.dart";

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
      color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
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
                                pageId: noteFromList.pageId,
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
                    if (noteFromList.pageId ==
                        context.read<HistoryNotifier>().currentPageId) {
                      return;
                    }
                    final IsarNotifier isarNotifer =
                        context.read<IsarNotifier>();

                    final List<Note> snapshots = await isarNotifer.getSnapshots(
                      autoSavedSnapshots: true,
                      pageId: noteFromList.pageId,
                    );
                    if (context.mounted) {
                      try {
                        await context.read<HistoryNotifier>().handlePageSelect(
                              previousTextContent: textEditingController.text,
                              newPageId: noteFromList.pageId,
                              newHistoryStack: snapshots,
                              isarNotifier: isarNotifer,
                            );
                      } on PageChangedException {
                        if (context.mounted) {
                          textEditingController.text = context
                              .read<HistoryNotifier>()
                              .currentNote
                              .textContent;
                        }
                      }
                    }
                    setLeftBarIsOpen(false);
                  },
                  title: ColumnWithSpacings(
                    spacing: 8,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          noteFromList.textContent.isNotEmpty
                              ? noteFromList.textContent
                              : "Empty Note.",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.start,
                          // ,
                        ),
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
