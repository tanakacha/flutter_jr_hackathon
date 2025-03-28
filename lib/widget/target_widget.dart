import 'package:flutter/material.dart';

class TargetWidget extends StatelessWidget {
  final double x;
  final double y;

  const TargetWidget({
    super.key,
    required this.x,
    required this.y,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: x,
      top: y,
      child: const Icon(
        Icons.adjust,
        size: 50,
        color: Colors.red,
      ),
    );
  }
}
