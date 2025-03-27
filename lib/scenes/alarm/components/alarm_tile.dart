import 'package:flutter/material.dart';

class AlarmTile extends StatelessWidget {
  const AlarmTile(
      {super.key,
      required this.title,
      required this.onPressed,
      this.onDismissed});

  final String title;
  final void Function() onPressed;
  final void Function()? onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      child: RawMaterialButton(onPressed: onPressed),
    );
  }
}
