import "package:flutter/material.dart";
import "package:think_simple/home/main_view/top_bar/top_bar.dart";

class MainView extends StatefulWidget {
  const MainView({
    required this.leftBarIsOpen,
    required this.setLeftBarIsOpen,
    required this.textEditingController,
    super.key,
  });

  final bool leftBarIsOpen;
  final void Function(bool) setLeftBarIsOpen;

  final TextEditingController textEditingController;

  static const int topBarAnimationDurationInMilliseconds = 800;
  static const double topBarHeight = 64;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final double offsetBeforeTimeout = scrollController.offset;

      if ((previousScrollOffset - offsetBeforeTimeout) < -10) {
        setTopBarIsVisible(false);
      } else if (previousScrollOffset - offsetBeforeTimeout > 10) {
        setTopBarIsVisible(true);
      }
      setState(() {
        previousScrollOffset = scrollController.offset;
      });
    });
  }

  final ScrollController scrollController = ScrollController();
  final UndoHistoryController historyController = UndoHistoryController();

  double previousScrollOffset = 0;
  bool topBarIsVisible = true;
  bool topBarIsOpen = true;

  void setTopBarIsVisible(bool isVisible) {
    if (isVisible != topBarIsVisible) {
      setState(() {
        topBarIsVisible = isVisible;
        if (isVisible) {
          setTopBarIsOpen(true);
        } else {
          widget.setLeftBarIsOpen(false);
        }
      });
    }
  }

  void setTopBarIsOpen(bool isOpen) {
    if (isOpen != topBarIsOpen) {
      setState(() {
        topBarIsOpen = isOpen;
      });
    }
  }

  //TODO: create a function that checks for how many different characters the text has
  //TODO compared to the previous snapshot. If it has more than 20 characters then create a new snapshot
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: <Widget>[
                  AnimatedContainer(
                    curve: Curves.ease,
                    //? Prevents obscuring text when showing the top bar.
                    duration: const Duration(
                      milliseconds:
                          MainView.topBarAnimationDurationInMilliseconds,
                    ),
                    height: topBarIsVisible &&
                            previousScrollOffset < MainView.topBarHeight
                        ? MainView.topBarHeight
                        : 0,
                  ),
                  TextField(
                    onTap: () {
                      widget.setLeftBarIsOpen(false);
                    },
                    controller: widget.textEditingController,
                    undoController: historyController,
                    minLines: 32,
                    autofocus: true,
                    maxLines: null,
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: TopBar(
            setLeftBarIsOpen: widget.setLeftBarIsOpen,
            leftBarIsOpen: widget.leftBarIsOpen,
            topBarIsVisible: topBarIsVisible,
            topBarIsOpen: topBarIsOpen,
            setTopBarIsOpen: setTopBarIsOpen,
            historyController: historyController,
          ),
        ),
      ],
    );
  }
}
