import "package:flutter/material.dart";
import "package:think_simple/home/main_view/date_edited.dart";
import "package:think_simple/home/main_view/main_view.dart";
import "package:think_simple/home/main_view/top_bar/buttons/access_left_sidebar_button.dart";
import "package:think_simple/home/main_view/top_bar/buttons/history_buttons.dart";

class TopBar extends StatelessWidget {
  const TopBar({
    required this.topBarIsVisible,
    required this.setLeftBarIsOpen,
    required this.leftBarIsOpen,
    required this.setTopBarIsOpen,
    required this.topBarIsOpen,
    required this.historyController,
    super.key,
  });

  final UndoHistoryController historyController;

  final bool leftBarIsOpen;
  final void Function(bool) setLeftBarIsOpen;

  final bool topBarIsVisible;

  final bool topBarIsOpen;
  final void Function(bool) setTopBarIsOpen;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      onEnd: () {
        if (!topBarIsVisible) {
          setTopBarIsOpen(false);
        }
      },
      offset: Offset(0, topBarIsVisible ? 0 : -1),
      duration: const Duration(
        milliseconds: MainView.topBarAnimationDurationInMilliseconds,
      ),
      curve: Curves.ease,
      child: !topBarIsOpen
          ? const SizedBox.shrink()
          : Container(
              height: MainView.topBarHeight,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.8),
              ),
              //TODO Search for mask filter blur
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    AccessLeftSidebarButton(
                      setLeftBarIsOpen: setLeftBarIsOpen,
                      leftBarIsOpen: leftBarIsOpen,
                    ),
                    DateEdited(
                      dateEdited: DateTime.now(),
                    ),
                    HistoryButtons(
                      historyController: historyController,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
