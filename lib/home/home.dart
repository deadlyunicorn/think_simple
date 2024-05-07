import "package:flutter/material.dart";
import "package:think_simple/home/left_side_bar/left_side_bar.dart";
import "package:think_simple/home/main_view/main_view.dart";

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
      body: Row(
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
            child:
                _leftBarIsOpen ? const LeftSideBar() : const SizedBox.shrink(),
          ),
          Expanded(
            child: MainView(
              leftBarIsOpen: leftBarIsVisible,
              setLeftBarIsOpen: setLeftBarIsOpen,
            ),
          ),
        ],
      ),
    );
  }

  void setLeftBarIsOpen(bool open) {
    setState(() {
      leftBarIsVisible = open;
      if (open) {
        _leftBarIsOpen = true;
      }
    });
  }
}
