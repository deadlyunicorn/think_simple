import "package:flutter/material.dart";

class MainView extends StatelessWidget {
  const MainView({
    required this.leftBarIsOpen,
    required this.setLeftBarIsOpen,
    super.key,
  });

  final bool leftBarIsOpen;
  final void Function(bool) setLeftBarIsOpen;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () {
                    setLeftBarIsOpen(!leftBarIsOpen);
                  },
                  icon: AnimatedRotation(
                    turns: 1,
                    duration: Duration(seconds: 1),
                    child: Icon(Icons.menu),
                  )),
            ),
            Text("helloWorld"),
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
    );
  }
}
