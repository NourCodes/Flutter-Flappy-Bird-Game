import 'package:flutter/cupertino.dart';

class Bird extends StatelessWidget {
  const Bird({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "images/bird.png",
      height: 60,
      width: 60,
    );
  }
}
