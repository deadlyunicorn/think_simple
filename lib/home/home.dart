import "package:flutter/material.dart";
import "package:isar/isar.dart";
import "package:provider/provider.dart";
import "package:think_simple/core/database/database_items.dart";
import "package:think_simple/core/database/isar_notifier.dart";
import "package:think_simple/home/left_side_bar/left_side_bar.dart";
import "package:think_simple/home/main_view/history_notifier.dart";
import "package:think_simple/home/main_view/history_tracker.dart";
import "package:think_simple/home/main_view/main_view.dart";
import "package:think_simple/home/selected_note_notifier.dart";

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool leftBarIsVisible = false;
  bool _leftBarIsOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: <Widget>[
            FutureBuilder<List<CompletePage>>(
              future: getAvailablePages(context),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<CompletePage>> snapshot,
              ) {
                return AnimatedContainer(
                  onEnd: () {
                    if (!leftBarIsVisible) {
                      setState(() {
                        _leftBarIsOpen = false;
                      });
                    }
                  },
                  duration: const Duration(milliseconds: 80),
                  width: leftBarIsVisible
                      ? MediaQuery.sizeOf(context).width * 0.36
                      : 0,
                  child: _leftBarIsOpen
                      ? LeftSideBar(
                          setLeftBarIsOpen: setLeftBarIsOpen,
                          pages: snapshot.data ?? <CompletePage>[],
                        )
                      : const SizedBox.shrink(),
                );
              },
            ),
            Expanded(
              child: ChangeNotifierProvider<HistoryNotifier>(
                create: (BuildContext context) => HistoryNotifier(),
                builder: (BuildContext context, Widget? child) =>
                    HistoryTracker(
                  selectedNoteNotifer: context.watch<SelectedNoteNotifer>(),
                  historyController: context.watch<HistoryNotifier>(),
                  child: (
                    TextEditingController textEditingController,
                  ) =>
                      MainView(
                    textEditingController: textEditingController,
                    leftBarIsOpen: leftBarIsVisible,
                    setLeftBarIsOpen: setLeftBarIsOpen,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setLeftBarIsOpen(bool newState) {
    setState(() {
      leftBarIsVisible = newState;
      if (newState) {
        _leftBarIsOpen = true;
      }
    });
  }

  Future<List<CompletePage>> getAvailablePages(
    BuildContext context,
  ) async {
    final Isar isar = await context.watch<IsarNotifier>().isarFuture;

    final List<CompletePage> completePages = <CompletePage>[];
    final List<DatabasePage> databasePages =
        await isar.databasePages.where().sortByLastModifiedDesc().findAll();
    final List<Note?> tempNotes = await Future.wait(
      databasePages.map(
        (DatabasePage databasePage) =>
            databasePage.autoSnapshots.lastOrNull != null
                ? isar.notes
                    .filter()
                    .idEqualTo(databasePage.autoSnapshots.last)
                    .findFirst()
                : Future<Null>.value(null),
      ),
    );

    print("temps: ${tempNotes.map((e) => e?.textContent)}");

    ///TODO Maybe add a "current note field"
    //? So that we can handle undos/redos better.
    //? E.g. user closes the app after undoing.
    //? Make it so that we keep or remove the history after the undos

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
