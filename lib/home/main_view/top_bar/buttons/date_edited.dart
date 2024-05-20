import "package:flutter/material.dart";
import "package:think_simple/core/extensions/date_format.dart";

class DateEdited extends StatelessWidget {
  const DateEdited({
    required this.dateEdited,
    super.key,
  });

  final DateTime dateEdited;

  @override
  Widget build(BuildContext context) {
    return Text(
      dateEdited.formatted.replaceFirst(" ", "\n"),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.64),
          ),
      textAlign: TextAlign.center,
    );
  }
}
