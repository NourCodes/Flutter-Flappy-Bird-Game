import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flappy_game/barrier.dart';
import 'package:flappy_game/bird.dart';
import 'package:flappy_game/score_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double time = 0;
  double height = 0;
  double gravity = -4.9;
  double velocity = 2.8;
  static double birdY = 0; // initializing the vertical position of the bird
  double initialPos = birdY; // storing the initial position of the bird
  bool gameStarted = false; // initializing a variable to track game state
  static double xOne =
      0.9; // initializing the x-coordinate of the first barrier
  double xTwo =
      xOne + 1.5; // initializing the x-coordinate of the second barrier
  int score = 0;
  int best = 0;

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

      // calculating height based on time using a quadratic equation
      height = gravity * time * time + velocity * time;
      // updating the UI
      setState(() {
        // updating the vertical position of the bird
        birdY = initialPos - height;
      });
      setState(() {
        // adjusting the x-coordinates of the barriers for animation
        if (xOne < -2) {
          xOne += 3.5;
        } else {
          xOne -= 0.05;
        }
        if (xTwo < -2) {
          xTwo += 3.5;
        } else {
          xTwo -= 0.05;
        }
      });
      if (birdIsDead()) {
        gameStarted = false; //setting gameStarted to false
        timer.cancel(); // cancelling the timer
        _dialog();
      }
    });
  }

  void _dialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: const Center(
            child: Text(
              "GAME OVER!",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade500,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(5),
                child: const Text(
                  "PLAY AGAIN",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  // method to reset the game
  void resetGame() {
    Navigator.of(context).pop();
    setState(() {
      birdY = 0;
      gameStarted = false;
      time = 0;
      initialPos = birdY;
      xOne = 0.9;
      xTwo = xOne + 1.5;
    });
  }

  // method to check if the bird is dead
  bool birdIsDead() {
    // checking if bird reaches the bottom of the screen or above the screen
    if (birdY > 1 || birdY < -1) {
      return true;
    } // checking if the bird hits a barrier
    return false;
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
              child: Stack(
                children: [
                  // AnimatedContainer for the bird
                  AnimatedContainer(
                    color: Colors.blue,
                    duration: const Duration(
                        milliseconds: 0 // setting the duration for animation
                        ),
                    alignment: Alignment(0, birdY),
                    child: const Bird(),
                  ),

                  // displaying 'TAP TO PLAY' text if game has not started
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
                  ),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(xOne, 1.1),
                    child: const Barrier(size: 200.0),
                  ),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(xOne, -1.1),
                    child: const Barrier(size: 150.0),
                  ),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(xTwo, 1.1),
                    child: const Barrier(size: 150.0),
                  ),

                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(xTwo, -1.1),
                    child: const Barrier(size: 250.0),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.green,
              height: 15,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Score(
                  score: score,
                  best: best,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
