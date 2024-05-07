import "package:flutter/material.dart";
import "package:think_simple/home/main_view/date_edited.dart";
import "package:think_simple/home/main_view/top_bar/buttons/access_left_sidebar_button.dart";
import "package:think_simple/home/main_view/top_bar/buttons/history_buttons.dart";

class TopBar extends StatelessWidget {
  const TopBar({
    required this.topBarIsVisible,
    required this.setLeftBarIsOpen,
    required this.leftBarIsOpen,
    required this.setTopBarIsOpen,
    required this.topBarIsOpen,
    super.key,
  });

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
      duration: const Duration(milliseconds: 300),
      child: !topBarIsOpen
          ? const SizedBox.shrink()
          : Container(
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.8),
              ),
              //TODO Search for mask filter blur
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    AccessLeftSidebarButton(
                      setLeftBarIsOpen: setLeftBarIsOpen,
                      leftBarIsOpen: leftBarIsOpen,
                    ),
                    Column(
                      children: <Widget>[
                        const HistoryButtons(),
                        DateEdited(
                          dateEdited: DateTime.now(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
