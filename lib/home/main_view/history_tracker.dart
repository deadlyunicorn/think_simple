import "package:flutter/material.dart";

class HistoryTracker extends StatefulWidget {
  const HistoryTracker({
    required this.child,
    super.key,
  });

  final Widget Function(TextEditingController textEditingController) child;

  @override
  State<HistoryTracker> createState() => _HistoryTrackerState();
}

class _HistoryTrackerState extends State<HistoryTracker> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      //TODO Implement here the comparing function
    });
  }

  @override
  Widget build(BuildContext context) => widget.child(
        textEditingController,
      );
}
