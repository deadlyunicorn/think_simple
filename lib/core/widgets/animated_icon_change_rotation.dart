import "package:flutter/material.dart";

class AnimatedIconChangeScale extends StatelessWidget {
  const AnimatedIconChangeScale({
    required this.displayFirst,
    required this.firstIcon,
    required this.secondIcon,
    super.key,
  });

  final bool displayFirst;
  final Icon firstIcon;
  final Icon secondIcon;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (Widget child, Animation<double> animation) =>
          ScaleTransition(
        scale: animation,
        child: child,
      ),
      duration: const Duration(milliseconds: 80),
      //!!! NOTE: this won't work if the passed Icon()s
      //!!! ----- don't have a key ( e.g. ValueKey )
      child: displayFirst ? firstIcon : secondIcon,
    );
  }
}
