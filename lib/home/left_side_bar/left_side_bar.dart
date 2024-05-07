import "package:flutter/material.dart";
import "package:think_simple/core/functions/snackbars.dart";
import "package:think_simple/core/widgets/column_with_spacings.dart";

class LeftSideBar extends StatelessWidget {
  const LeftSideBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16),
        child: ColumnWithSpacings(
          spacing: 16,
          children: <Widget>[
            //TODO Create a textButton Widget that takes us to the full item to edit
            //TODO and has the required padding
            Container(
              width: double.infinity,
              height: 40,
              color: Colors.white,
            ),
            Text("hello \n\n ROFl"),
            Text("hello \n\n ROFl"),
            Text("hello \n\n ROFl"),
            Text("hello \n\n ROFl"),
            Text("hello \n\n ROFl"),
            Text("hello \n\n ROFl"),
            Text("hello \n\n ROFl"),
            Text("hello \n\n ROFl"),
            Text("hello \n\n ROFl"),
            Text("hello \n\n ROFl"),
            Text("hello \n\n ROFl"),
            Text("hello \n\n ROFl"),
            Text("hello \n\n ROFl"),
            TextButton(
                onPressed: () {
                  showNormalSnackbar(context: context, message: "hello");
                  // ScaffoldMessenger.of(context).showSnackBar();
                },
                child: Text("noo"))
          ],
        ),
      ),
    );
  }
}
