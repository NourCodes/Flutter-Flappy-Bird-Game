import 'package:flutter/material.dart';

class Barrier extends StatelessWidget {
  final double size;

  const Barrier({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(
          color: Colors.green.shade800,
          width: 6,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
