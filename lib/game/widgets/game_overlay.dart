// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io' show Platform;
import 'package:doodle_dash/game/managers/audio_manager.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../doodle_dash.dart';
import 'widgets.dart';

class GameOverlay extends StatefulWidget {
  const GameOverlay(this.game, {super.key});

  final Game game;

  @override
  State<GameOverlay> createState() => GameOverlayState();
}

class GameOverlayState extends State<GameOverlay> {
  bool isPaused = false;
  final bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  bool get isPlaying => (widget.game as DoodleDash).gameManager.isPlaying;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          if (isPlaying)
            Positioned(
                top: 30, left: 30, child: ScoreDisplay(game: widget.game)),
          if (isPlaying)
            Positioned(
              top: 30,
              right: 30,
              child: ElevatedButton(
                child: isPaused
                    ? const Icon(Icons.play_arrow, size: 48)
                    : const Icon(Icons.pause, size: 48),
                onPressed: () {
                  (widget.game as DoodleDash).togglePauseState();
                  isPaused = !isPaused;
                  setState(() {});
                },
              ),
            ),
          if (isPlaying)
            if (isMobile)
              Positioned(
                bottom: 30,
                child: Row(
                  children: [
                    SizedBox(width: 30),
                    GestureDetector(
                      onTapDown: (details) =>
                          (widget.game as DoodleDash).player.moveLeft(),
                      onTapUp: (details) =>
                          (widget.game as DoodleDash).player.resetDirection(),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(100),
                        shadowColor: Theme.of(context).colorScheme.background,
                        child: const Icon(Icons.arrow_left, size: 64),
                      ),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTapDown: (details) =>
                          (widget.game as DoodleDash).player.moveRight(),
                      onTapUp: (details) =>
                          (widget.game as DoodleDash).player.resetDirection(),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(100),
                        shadowColor: Theme.of(context).colorScheme.background,
                        child: const Icon(Icons.arrow_right, size: 64),
                      ),
                    ),
                  ],
                ),
              ),
          if (isPaused)
            Positioned(
                top: MediaQuery.of(context).size.height / 2 - 72.0,
                right: MediaQuery.of(context).size.width / 2 - 72.0,
                child: const Icon(Icons.pause_circle,
                    size: 144.0, color: Colors.black12)),
        ],
      ),
    );
  }
}
