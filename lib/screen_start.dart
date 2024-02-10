import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final bool gameStarted;
  const Screen({Key? key, required this.gameStarted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return // displaying 'TAP TO PLAY' text if game has not started
        Container(
      alignment: const Alignment(0, -0.25),
      child: gameStarted
          ? const Text("")
          : const Text(
              'TAP TO PLAY',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
    );
  }
}
