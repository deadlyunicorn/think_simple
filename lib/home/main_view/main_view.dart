import "package:flutter/material.dart";
import "package:think_simple/home/main_view/top_bar/top_bar.dart";

class MainView extends StatefulWidget {
  const MainView({
    required this.leftBarIsOpen,
    required this.setLeftBarIsOpen,
    super.key,
  });

  final bool leftBarIsOpen;
  final void Function(bool) setLeftBarIsOpen;
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
  double previousScrollOffset = 0;
  bool topBarIsVisible = true;
  bool topBarIsOpen = true;

  void setTopBarIsVisible(bool isVisible) {
    //TODO make it so that it hides automatically on scroll, and it appears after 3s
    //TODO make sure it doesn't hide by mistake bcz it hides the side bar as well
    //TODO a possible way to do this is to hide it only if scroll dy is more than x

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

  //? show top bar if not scrolling for like 2 seconds.

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
                  TextButton(
                      onPressed: () {
                        setTopBarIsVisible(!topBarIsVisible);
                      },
                      child: Text("toggle top bar")),
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
          ),
        ),
      ],
    );
  }
}
