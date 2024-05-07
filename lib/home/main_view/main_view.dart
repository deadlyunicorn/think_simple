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

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
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
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: <Widget>[
                  AnimatedContainer(
                    //? Prevents obscuring text when showing the top bar.
                    duration: const Duration(milliseconds: 300),
                    height: topBarIsVisible ? 160 : 0,
                  ),
                  TextButton(
                      onPressed: () {
                        setTopBarIsVisible(!topBarIsVisible);
                      },
                      child: Text("toggle top bar")),
                  Container(
                    color: Colors.red,
                    height: 400,
                    width: 40,
                  ),
                  Container(
                    color: Colors.red,
                    height: 400,
                    width: 40,
                  ),
                  Container(
                    color: Colors.red,
                    height: 400,
                    width: 40,
                  ),
                  Container(
                    color: Colors.red,
                    height: 400,
                    width: 40,
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
          ),
        ),
      ],
    );
  }
}
