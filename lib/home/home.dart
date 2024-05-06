import "package:decla_time/home/left_side_bar/left_side_bar.dart";
import "package:decla_time/home/main_view/main_view.dart";
import "package:flutter/material.dart";

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool leftBarIsOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            width: leftBarIsOpen ? MediaQuery.sizeOf(context).width * 0.36 : 0,
            child: const LeftSideBar(),
          ),
          Expanded(
            child: MainView(
              leftBarIsOpen: leftBarIsOpen,
              setLeftBarIsOpen: setLeftBarIsOpen,
            ),
          ),
        ],
      ),
    );
  }

  void setLeftBarIsOpen(bool newState) {
    setState(() {
      leftBarIsOpen = newState;
    });
  }
}
