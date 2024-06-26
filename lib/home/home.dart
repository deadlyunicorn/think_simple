import "dart:async";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:think_simple/core/database/isar_notifier.dart";
import "package:think_simple/home/left_side_bar/left_side_bar.dart";
import "package:think_simple/home/main_view/history_notifier.dart";
import "package:think_simple/home/main_view/history_tracker.dart";
import "package:think_simple/home/main_view/main_view.dart";

//TODO: Manual Snapshots.

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HistoryTracker(
        isarNotifier: context.read<IsarNotifier>(),
        historyController: context.watch<HistoryNotifier>(),
        child: (
          TextEditingController textEditingController,
        ) =>
            HomeView(
          textEditingController: textEditingController,
        ),
      ),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({
    required this.textEditingController,
    super.key,
  });

  final TextEditingController textEditingController;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool leftBarIsVisible = false;
  bool _leftBarIsOpen = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: <Widget>[
          AnimatedContainer(
            onEnd: () {
              if (!leftBarIsVisible) {
                setState(() {
                  _leftBarIsOpen = false;
                });
              }
            },
            duration: const Duration(milliseconds: 80),
            width:
                leftBarIsVisible ? MediaQuery.sizeOf(context).width * 0.36 : 0,
            child: _leftBarIsOpen
                ? LeftSideBar(
                    textEditingController: widget.textEditingController,
                    setLeftBarIsOpen: setLeftBarIsOpen,
                    availablePages:
                        context.watch<IsarNotifier>().availablePages,
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: MainView(
              textEditingController: widget.textEditingController,
              leftBarIsOpen: leftBarIsVisible,
              setLeftBarIsOpen: setLeftBarIsOpen,
            ),
          ),
        ],
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

    // if (newState) {
    unawaited(
      context.read<IsarNotifier>().createSnapshot(
            textContent: widget.textEditingController.text,
            pageId: context.read<HistoryNotifier>().currentPageId,
            wasAutoSaved: true,
          ),
    );
    // }
  }
}
