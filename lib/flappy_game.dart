import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class FlappyGame extends FlameGame with TapDetector {
  double birdY = 300;
  double velocity = 0;

  final double gravity = 900;
  final double jumpForce = -300;

  //pipe
  double pipeX = 400;
  double pipeGap = 180;
  double pipeHeight = 200;

  int score = 0;
  bool gameover = false;

  @override
  void update(double dt) {
    super.update(dt);
    if (gameover) return;

    //bird physics
    velocity += gravity * dt;
    birdY += velocity * dt;

    //pipe movement
    pipeX -= 200 * dt;
    if (pipeX < -80) {
      pipeX = size.x;
      pipeHeight = Random().nextDouble() * 300 + 50;
      score++;
    }

    //collision detection
    if (birdY < 0 || birdY > size.y - 40) {
      gameover = true;
    }

    if (pipeX < 80 && pipeX + 80 > 80) {
      if (birdY < pipeHeight || birdY + 40 > pipeHeight + pipeGap) {
        gameover = true;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    //background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color.fromARGB(255, 45, 65, 100),
    );

    //Winnie the Pooh head
    // kepala utama
    canvas.drawCircle(
      Offset(60, birdY + 20),
      20,
      Paint()..color = const Color.fromARGB(255, 230, 180, 100),
    );
    
    // telinga kiri
    canvas.drawCircle(
      Offset(42, birdY + 5),
      8,
      Paint()..color = const Color.fromARGB(255, 230, 180, 100),
    );
    
    // telinga kanan
    canvas.drawCircle(
      Offset(78, birdY + 5),
      8,
      Paint()..color = const Color.fromARGB(255, 230, 180, 100),
    );
    
    // mata kiri
    canvas.drawCircle(
      Offset(52, birdY + 15),
      3,
      Paint()..color = Colors.black,
    );
    
    // mata kanan
    canvas.drawCircle(
      Offset(68, birdY + 15),
      3,
      Paint()..color = Colors.black,
    );
    
    // hidung (snout)
    canvas.drawOval(
      Rect.fromLTWH(54, birdY + 22, 12, 10),
      Paint()..color = const Color.fromARGB(255, 180, 140, 80),
    );
    
    // lubang hidung kiri
    canvas.drawCircle(
      Offset(58, birdY + 26),
      2,
      Paint()..color = Colors.black,
    );
    
    // lubang hidung kanan
    canvas.drawCircle(
      Offset(62, birdY + 26),
      2,
      Paint()..color = Colors.black,
    );

    //pipe atas
    canvas.drawRect(
      Rect.fromLTWH(pipeX, 0, 60, pipeHeight),
      Paint()..color = Colors.yellow,
    );
    //pinggiran pipe atas
    canvas.drawRect(
      Rect.fromLTWH(pipeX - 5, pipeHeight - 20, 70, 20),
      Paint()..color = Colors.yellow,
    );

    //pipe bawah
    canvas.drawRect(
      Rect.fromLTWH(pipeX, pipeHeight + pipeGap, 60, size.y),
      Paint()..color = Colors.yellow,
    );
    //pinggiran pipe bawah
    canvas.drawRect(
      Rect.fromLTWH(pipeX - 5, pipeHeight + pipeGap, 70, 20),
      Paint()..color = Colors.yellow,
    );

    //score
    drawText(canvas, 'Score: $score', 10, 10);

    if (gameover) {
      drawText(canvas, 'Game Over', size.x / 2 - 80, size.y / 2);
      drawText(canvas, 'Tap to Restart', size.x / 2 - 100, size.y / 2 + 40);
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    if (gameover) {
      resetGame();
    } else {
      velocity = jumpForce;
    }
  }

  void resetGame() {
    gameover = false;
    birdY = 300;
    velocity = 0;
    pipeX = 400;
    pipeHeight = 200;
    score = 0;
  }

  //Score
  void drawText(Canvas canvas, String text, double x, double y) {
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    tp.paint(canvas, Offset(x, y));
  }
}