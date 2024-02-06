import 'package:flappy_game/bird.dart';
import 'package:flappy_game/score_container.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double time = 0;
  double height = 0;
  static double birdY = 0; // initializing the vertical position of the bird
  double initialPos = birdY; // storing the initial position of the bird
  bool gameStarted = false; // initializing a variable to track game state

  // method to make the bird jump
  void jump() {
    // updating the UI
    setState(() {
      // storing the current position as the initial position
      initialPos = birdY;
      // resetting time to 0 to initiate a new jump
      time = 0;
    });
  }

  // method to start the game
  void startGame() {
    gameStarted = true;
    // using a timer to update the game state periodically
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      time += 0.05; // incrementing time

      // calculating height based on time
      height = -4.9 * time * time + 2.8 * time;
      // updating the UI
      setState(() {
        // updating the vertical position of the bird
        birdY = initialPos - height;
      });
      // checking if bird reaches the bottom of the screen
      if (birdY > 1) {
        gameStarted = false; // setting gameStarted to false
        timer.cancel(); // cancelling the timer
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // checking if the game has started
          if (gameStarted) {
            jump();
          } else {
            startGame(); // starting the game if not already started
          }
        },
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: AnimatedContainer(
                color: Colors.blue,
                duration: const Duration(
                    milliseconds: 0), // setting the duration for animation
                alignment:
                    Alignment(0, birdY), // setting the alignment for the bird
                child: const Bird(),
              ),
            ),
            Container(
              color: Colors.green,
              height: 15,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: const Score(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
