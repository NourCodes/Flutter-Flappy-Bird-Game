import 'package:flappy_game/screen_start.dart';
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

  int score = 0;
  int best = 0;
  double birdWidth = 0.12; // 2 is the width of the screen
  double birdHeight = 0.12; //2 is the height of the screen
  //barrier variables
  static List<double> barrierX = [1, 1 + 1.5]; // X-coordinates of the barriers
  static double barrierWidth = 0.5; // width of barriers
  List<List<double>> barrierHeight = [
    // height of barriers
    //2 is the height of the screen
    // [ topHeight , bottom Height]
    [0.6, 0.3],
    [0.3, 0.6],
  ];

  // method to make the bird jump
  void jump() {
    // updating the UI
    setState(() {
      // storing the current position as the initial position
      initialPos = birdY;
      // resetting time to 0 to initiate a new jump
      time = 0;
      // incrementing the score when the bird jumps
      score += 1;
    });
  }

  // method to start the game
  void startGame() {
    gameStarted = true;
    // using a timer to update the game state periodically
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      // time += 0.05; // incrementing time

      // calculating height based on time using a quadratic equation
      height = gravity * time * time + velocity * time;
      // updating the UI
      setState(() {
        // updating the vertical position of the bird
        birdY = initialPos - height;
      });

      // checking if the bird is dead
      if (birdIsDead()) {
        gameStarted = false; //setting gameStarted to false
        timer.cancel(); // cancelling the timer
        _dialog(); // displaying a dialog to indicate game over
        setState(() {
          getBestScore(); // updating the best score
        });
      }
      //keep map moving by moving the barriers
      moveMap();
      //keep time going
      time += 0.05;
    });
  }

  // method to display a dialog when the game is over

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
    Navigator.of(context).pop(); // dismissing the dialog
    setState(() {
      birdY = 0; // resetting bird position
      gameStarted = false;
      time = 0; // resetting time
      initialPos = birdY; // storing initial bird position
      barrierX = [1, 1 + 1.5]; // resetting barrier positions
      score = 0; // resetting the score
    });
  }

  void getBestScore() {
    if (score > best) {
      best = score; // updating the best score if the current score is higher
    }
  }

  // method to check if the bird is dead
  bool birdIsDead() {
    // Check if bird hits the bottom or top of the screen
    if (birdY > 1 || birdY < -1) {
      return true; // bird is dead if it hits the top or bottom of the screen
    }
    // Check if the bird overlaps with any part of any barrier
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true; // bird is dead if it overlaps with a barrier
      }
    }
    return false; // bird is not dead
  }

  // method to move the barriers
  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      //keep barriers moving
      setState(() {
        barrierX[i] -= 0.005; // moving the barriers to the left
      });
      // Looping the barriers if they go off the screen
      if (barrierX[i] < -1.5) {
        barrierX[i] += 2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // checking if the game has started
        if (gameStarted) {
          jump();
        } else {
          startGame(); // starting the game if not already started
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Stack(
                    children: [
                      Bird(
                        birdY: birdY, // vertical position of the bird
                        birdWidth: birdWidth, // width of the bird
                        birdHeight: birdHeight, // height of the bird
                      ),
                      Screen(gameStarted: gameStarted),

                      // first top barrier
                      Barrier(
                        barrierHeight: barrierHeight[0][0],
                        barrierWidth: barrierWidth,
                        barrierX: barrierX[0], // x-coordinate of the barrier
                        bottomBarrier: false,
                      ),
                      // first bottom barrier
                      Barrier(
                        barrierHeight: barrierHeight[0][1],
                        barrierWidth: barrierWidth,
                        barrierX: barrierX[0], // x-coordinate of the barrier
                        bottomBarrier: true,
                      ),
                      // second top barrier
                      Barrier(
                        barrierHeight: barrierHeight[1][0],
                        barrierWidth: barrierWidth,
                        barrierX: barrierX[1], // x-coordinate of the barrier
                        bottomBarrier: false,
                      ),
                      // second bottom barrier
                      Barrier(
                        barrierHeight: barrierHeight[1][1],
                        barrierWidth: barrierWidth,
                        barrierX: barrierX[1], // x-coordinate of the barrier
                        bottomBarrier: true,
                      ),
                    ],
                  ),
                ),
              ),
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
