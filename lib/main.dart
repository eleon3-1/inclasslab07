import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' show pi;



void main() => runApp(const SmileyApp());

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smiley Painter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DrawingPlayground(),
    );
  }
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {

  String petName = 'The Man';
  int happiness = 50;
  int hunger = 50;
  Timer? _hungerTimer;
  Timer? _highMoodTimer;

  bool _gameOver = false;
  bool _hasWon = false;
  bool _isPaused = false;
  final TextEditingController _nameController =
    TextEditingController(text: 'The Man');

    @override
void initState() {
  super.initState();
  _startHungerTimer();
  _updateOutcome();
}

void _startHungerTimer() {
  _hungerTimer?.cancel();

  _hungerTimer = Timer.periodic(
    const Duration(seconds: 30),
    (timer) {
      if (!mounted || _gameOver || _hasWon) {
        timer.cancel();
        return;
      }

      setState(() {
        if (hunger + 5 > 100) {
          hunger = 100;
          happiness = _clampMeter(happiness - 20);
        } else {
          hunger += 5;
        }
      });

      _updateOutcome();
    },
  );
}

void _updateOutcome() {
  if (_gameOver || _hasWon || _isPaused) return; return;

  if (hunger == 100 && happiness <= 10) {
    _hungerTimer?.cancel();
    _highMoodTimer?.cancel();
    _highMoodTimer = null;

    setState(() {
      _gameOver = true;
    });
    return;
  }

  if (happiness <= 80) {
    _highMoodTimer?.cancel();
    _highMoodTimer = null;
    return;
  }

  _highMoodTimer ??= Timer(const Duration(minutes: 3), () {
    _highMoodTimer = null;

    if (!mounted || _gameOver || _hasWon || happiness <= 80) {
      return;
    }

    _hungerTimer?.cancel();

    setState(() {
      _hasWon = true;
    });
  });
}

@override
void dispose() {
  _hungerTimer?.cancel();
  _highMoodTimer?.cancel();
  _nameController.dispose();
  super.dispose();
}


  int _clampMeter(int value) {
  return value.clamp(0, 100).toInt();
}

void _feedPet() {
  if (_gameOver || _hasWon) return;

  final nextHunger = _clampMeter(hunger - 10);
  final happinessChange = nextHunger < 30 ? -20 : 10;

  setState(() {
    hunger = nextHunger;
    happiness = _clampMeter(happiness + happinessChange);
  });

  _updateOutcome();
}

void _playPet() {
  if (_gameOver || _hasWon) return;

  setState(() {
    happiness = _clampMeter(happiness + 15);
    hunger = _clampMeter(hunger + 10);
  });

  _updateOutcome();
}

void _resetPet() {
  _hungerTimer?.cancel();
  _highMoodTimer?.cancel();
  _highMoodTimer = null;

  setState(() {
    happiness = 50;
    hunger = 50;
    _gameOver = false;
    _hasWon = false;
    _isPaused = false;  
  });

  _startHungerTimer();
}

void _togglePause() {
  if (_gameOver || _hasWon) return;

  _hungerTimer?.cancel();
  _highMoodTimer?.cancel();
  _highMoodTimer = null;

  setState(() {
    _isPaused = !_isPaused;
  });

  if (!_isPaused) {
    _startHungerTimer();
    _updateOutcome();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomPainter Smiley Lab')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final reduceMotion = MediaQuery.of(context).disableAnimations;
              
              final canvasSide =
                constraints.maxWidth.clamp(0.0, 300.0).toDouble();

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Pet name',
                      border: OutlineInputBorder(),
      ),
    ),
    const SizedBox(height: 8),
    ElevatedButton(
      onPressed: () {
        final newName = _nameController.text.trim();



    if (newName.isEmpty) return;

    setState(() {
      petName = newName;
    });
    FocusScope.of(context).unfocus();
  },
  child: const Text('Confirm name'),
),
const SizedBox(height: 16),
Text('Pet: $petName'),

if (_gameOver) const Text('Game over'),
if (_hasWon) const Text('You won!'),

Text('Happiness: $happiness / 100'),
TweenAnimationBuilder<double>(
  tween: Tween<double>(begin: 0, end: happiness / 100),
  duration: reduceMotion
      ? Duration.zero
      : const Duration(milliseconds: 400),
  builder: (context, value, child) {
    return LinearProgressIndicator(value: value);
  },
),
const SizedBox(height: 8),
Text('Hunger: $hunger / 100'),
TweenAnimationBuilder<double>(
  tween: Tween<double>(begin: 0, end: hunger / 100),
  duration: reduceMotion
      ? Duration.zero
      : const Duration(milliseconds: 400),
  builder: (context, value, child) {
    return LinearProgressIndicator(value: value);
  },
),

if (_isPaused) const Text('Paused'),

Wrap(
  spacing: 12,
  runSpacing: 8,
  children: [
    ElevatedButton(
      onPressed:
          (_gameOver || _hasWon || _isPaused) ? null : _feedPet,
      child: const Text('Feed'),
    ),
    ElevatedButton(
      onPressed:
          (_gameOver || _hasWon || _isPaused) ? null : _playPet,
      child: const Text('Play'),
    ),
    ElevatedButton(
      onPressed: (_gameOver || _hasWon) ? null : _togglePause,
      child: Text(_isPaused ? 'Resume' : 'Pause'),
    ),
    ElevatedButton(
      onPressed: _resetPet,
      child: const Text('Reset'),
    ),
  ],
),

const SizedBox(height: 16),


              const SizedBox(height: 16),
              const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  Center(
                    child: AnimatedScale(
                      scale: happiness > 70
                          ? 1.05
                          : happiness >= 30
                              ? 1.0
                              : 0.95,
                      duration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 200),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          happiness > 70
                              ? Colors.green
                              : happiness >= 30
                                  ? Colors.yellow
                                  : Colors.red,
                          BlendMode.modulate,
                        ),
                        child: Image.asset(
                          'assets/corgihappy.png',
                          width: canvasSide,
                          height: canvasSide,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    happiness > 70
                        ? 'Mood: Happy'
                        : happiness >= 30
                            ? 'Mood: Neutral'
                            : 'Mood: Unhappy',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
              