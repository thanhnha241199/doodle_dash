// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../doodle_dash.dart';
import '../managers/managers.dart';

// Overlay that appears for the main menu
class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay(this.game, {super.key});

  final Game game;

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  Character character = Character.dash;

  @override
  Widget build(BuildContext context) {
    DoodleDash game = widget.game as DoodleDash;

    return LayoutBuilder(builder: (context, constraints) {
      final characterWidth = constraints.maxWidth / 5;

      final TextStyle titleStyle = (constraints.maxWidth > 830)
          ? Theme.of(context).textTheme.displayLarge!
          : Theme.of(context).textTheme.displaySmall!;

      // 760 is the smallest height the browser can have until the
      // layout is too large to fit.
      final bool screenHeightIsSmall = constraints.maxHeight < 760;

      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Doodle Dash',
                  style: titleStyle.copyWith(
                      fontFamily: 'DragonHunter', color: Colors.white),
                  textAlign: TextAlign.center,
                ).animate().scale(),
                const WhiteSpace(),
                Align(
                  alignment: Alignment.center,
                  child: Text('Select your character:',
                          style: Theme.of(context).textTheme.headlineSmall!)
                      .animate()
                      .scale(),
                ),
                if (!screenHeightIsSmall) const WhiteSpace(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CharacterButton(
                      character: Character.dash,
                      selected: character == Character.dash,
                      onSelectChar: () {
                        character = Character.dash;
                        AudioManager.instance.playSfx('tap.wav');
                        setState(() {});
                      },
                      characterWidth: characterWidth,
                    ).animate().moveY(),
                    CharacterButton(
                      character: Character.sparky,
                      selected: character == Character.sparky,
                      onSelectChar: () {
                        character = Character.sparky;
                        AudioManager.instance.playSfx('tap.wav');
                        setState(() {});
                      },
                      characterWidth: characterWidth,
                    ).animate().moveY(),
                  ],
                ),
                if (!screenHeightIsSmall) const WhiteSpace(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Difficulty:',
                        style: Theme.of(context).textTheme.bodyLarge!),
                    LevelPicker(
                      level: game.levelManager.selectedLevel.toDouble(),
                      label: game.levelManager.selectedLevel.toString(),
                      onChanged: ((value) {
                        setState(() {
                          game.levelManager.selectLevel(value.toInt());
                        });
                        AudioManager.instance.playSfx('tap.wav');
                      }),
                    ),
                  ],
                ).animate().moveX(),
                if (!screenHeightIsSmall) const WhiteSpace(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      game.gameManager.selectCharacter(character);
                      game.startGame();
                    },
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(200, 60)),
                      textStyle: MaterialStateProperty.all(
                          Theme.of(context).textTheme.titleLarge),
                    ),
                    child: const Text('Start'),
                  ),
                ).animate().scale(),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class LevelPicker extends StatelessWidget {
  const LevelPicker({
    super.key,
    required this.level,
    required this.label,
    required this.onChanged,
  });

  final double level;
  final String label;
  final void Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Slider(
        value: level,
        max: 5,
        min: 1,
        divisions: 4,
        label: label,
        onChanged: onChanged,
      ),
    );
  }
}

class CharacterButton extends StatelessWidget {
  const CharacterButton({
    super.key,
    required this.character,
    this.selected = false,
    required this.onSelectChar,
    required this.characterWidth,
  });

  final Character character;
  final bool selected;
  final void Function() onSelectChar;
  final double characterWidth;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: (selected)
          ? ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(31, 64, 195, 255)))
          : null,
      onPressed: onSelectChar,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset('assets/images/game/${character.name}_center.png',
                height: characterWidth, width: characterWidth),
            const WhiteSpace(height: 18),
            Text(character.name, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    ).animate().rotate();
  }
}

class WhiteSpace extends StatelessWidget {
  const WhiteSpace({super.key, this.height = 100});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
