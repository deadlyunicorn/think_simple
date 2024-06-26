import "package:flutter/material.dart";

class AnimatedIconChangeScale extends StatelessWidget {
  const AnimatedIconChangeScale({
    required this.displayFirst,
    required this.firstIcon,
    required this.secondIcon,
    super.key,
    this.duration = const Duration(milliseconds: 360),
  });

  final bool displayFirst;
  final Widget firstIcon;
  final Widget secondIcon;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (Widget child, Animation<double> animation) =>
          ScaleTransition(
        scale: animation,
        child: child,
      ),
      duration: duration,
      //!!! NOTE: this won't work if the passed Icon()s
      //!!! ----- don't have a key ( e.g. ValueKey )
      child: displayFirst ? firstIcon : secondIcon,
    );
  }
}
