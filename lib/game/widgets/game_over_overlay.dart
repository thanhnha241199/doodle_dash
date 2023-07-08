// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../doodle_dash.dart';
import 'widgets.dart';

// Overlay that pops up when the game ends
class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Game Over',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.red,
                    fontSize: 80,
                    fontFamily: 'DragonHunter'),
                textAlign: TextAlign.center,
              ),
              const WhiteSpace(height: 50),
              ScoreDisplay(game: game, isLight: true),
              const WhiteSpace(height: 50),
              ElevatedButton(
                onPressed: () => (game as DoodleDash).resetGame(),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(200, 75)),
                    textStyle: MaterialStateProperty.all(
                        Theme.of(context).textTheme.titleLarge)),
                child: const Text('Play Again'),
              ),
            ],
          ),
        ),
      ),
    ).animate().scale(duration: 1000.ms);
  }
}
