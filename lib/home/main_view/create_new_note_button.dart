import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:think_simple/core/database/database_items.dart";
import "package:think_simple/core/database/isar_notifier.dart";
import "package:think_simple/core/errors/exceptions.dart";
import "package:think_simple/core/widgets/animated_icon_change_rotation.dart";
import "package:think_simple/home/main_view/history_notifier.dart";

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
          final Note newPage =
              await context.read<IsarNotifier>().createNewPage();

          if (context.mounted) {
            try {
              await context.read<HistoryNotifier>().handlePageSelect(
                isarNotifier: isarNotifier,
                newPageId: newPage.id,
                previousTextContent: textEditingController.text,
                newHistoryStack: <Note>[newPage],
              );
            } on PageChangedException {
              textEditingController.text = newPage.textContent;
            }
          }
        },
      ),
      secondIcon: const SizedBox.shrink(),
    );
  }
}
