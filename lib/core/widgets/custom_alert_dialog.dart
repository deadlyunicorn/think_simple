import "package:flutter/material.dart";
import "package:think_simple/core/constants/constants.dart";

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    required this.confirmButtonAction,
    required this.title,
    required this.child,
    this.mouseCursor,
    super.key,
  });

  final void Function() confirmButtonAction;
  final String title;
  final Widget child;
  final MouseCursor? mouseCursor;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return SingleChildScrollView(
      child: SizedBox(
        height: screenHeight > kMaxWidthSmall ? screenHeight : null,
        child: AlertDialog(
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(title),
          ),
          content: SizedBox(
            width: kMaxWidthSmall,
            child: child,
          ),
          actions: <Widget>[
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      mouseCursor: mouseCursor != null
                          ? WidgetStatePropertyAll<MouseCursor>(
                              mouseCursor!,
                            )
                          : null,
                    ),
                    onPressed: () {
                      confirmButtonAction();
                    },
                    child: const Text("Confirm"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
