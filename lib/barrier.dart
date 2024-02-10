import 'package:flutter/material.dart';

class Barrier extends StatelessWidget {
  final double barrierHeight;
  final double barrierWidth; //2 is the screen width
  final double barrierX;
  final bool bottomBarrier;
  const Barrier(
      {Key? key,
      required this.barrierHeight,
      required this.barrierWidth,
      required this.barrierX,
      required this.bottomBarrier})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
          bottomBarrier ? -1 : 1),
      child: Container(
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(
            color: Colors.green.shade800,
            width: 6,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
