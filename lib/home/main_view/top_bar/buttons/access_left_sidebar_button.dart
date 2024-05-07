import "package:flutter/material.dart";
import "package:think_simple/core/widgets/animated_icon_change_rotation.dart";

class AccessLeftSidebarButton extends StatelessWidget {
  const AccessLeftSidebarButton({
    required this.setLeftBarIsOpen,
    required this.leftBarIsOpen,
    super.key,
  });

  final void Function(bool) setLeftBarIsOpen;
  final bool leftBarIsOpen;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        setLeftBarIsOpen(!leftBarIsOpen);
      },
      icon: AnimatedIconChangeScale(
        firstIcon: const Icon(
          Icons.menu,
          key: ValueKey<String>("menu"),
        ),
        secondIcon: const Icon(
          Icons.arrow_back,
          key: ValueKey<String>("close"),
        ),
        //? display first icon when leftBar is not Open
        displayFirst: !leftBarIsOpen,
      ),
    );
  }
}
