import 'package:flutter/cupertino.dart';

class Bird extends StatelessWidget {
  final double birdY;
  final double birdWidth;
  final double birdHeight; //2 is the height of the screen
  const Bird(
      {Key? key,
      required this.birdY,
      required this.birdWidth,
      required this.birdHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(
        0,
        (2 * birdY + birdHeight) / (2 - birdHeight),
      ),
      child: Image.asset(
        "images/bird.png",
        height: MediaQuery.of(context).size.height * 3 / 4 * birdHeight / 2,
        width: MediaQuery.of(context).size.height * birdWidth / 2,
        fit: BoxFit.fill,
      ),
    );
  }
}
