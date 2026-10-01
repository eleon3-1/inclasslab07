import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' show pi;

enum FaceType { classic, sleepy, surprised }

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

  double get mood => happiness / 100; // 0.0 sad → 1.0 happy
  FaceType selectedFace = FaceType.classic;
  String petName = 'The Man';
  int happiness = 50;
  int hunger = 50;
  Timer? _hungerTimer;
  final TextEditingController _nameController =
    TextEditingController(text: 'The Man');

    @override
void initState() {
  super.initState();
  _startHungerTimer();
}

void _startHungerTimer() {
  _hungerTimer?.cancel();

  _hungerTimer = Timer.periodic(
    const Duration(seconds: 30),
    (timer) {
      if (!mounted) {
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
    },
  );
}

@override
void dispose() {
  _hungerTimer?.cancel();
  _nameController.dispose();
  super.dispose();
}



  int _clampMeter(int value) {
  return value.clamp(0, 100).toInt();
  }

  void _feedPet() {
  final nextHunger = _clampMeter(hunger - 10);

  
  final happinessChange = nextHunger < 30 ? -20 : 10;

  setState(() {
    hunger = nextHunger;
    happiness = _clampMeter(happiness + happinessChange);
    
  });
}

void _playPet() {
  setState(() {
    happiness = _clampMeter(happiness + 15);
    hunger = _clampMeter(hunger + 10);
   
  });
}
void _resetPet() {
  _hungerTimer?.cancel();

  setState(() {
    happiness = 50;
    hunger = 50;
  });

  _startHungerTimer();
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
Text('Happiness: $happiness / 100'),
Text('Hunger: $hunger / 100'),

const SizedBox(height: 16),
Wrap(
  spacing: 12,
  runSpacing: 8,
  children: [
    ElevatedButton(
      onPressed: _feedPet,
      child: const Text('Feed'),
    ),
    ElevatedButton(
      onPressed: _playPet,
      child: const Text('Play'),
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
                  const Text('Choose a face'),
                  DropdownButton<FaceType>(
                    value: selectedFace,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem<FaceType>(
                        value: FaceType.classic,
                        child: Text('Classic'),
                      ),
                      DropdownMenuItem<FaceType>(
                        value: FaceType.sleepy,
                        child: Text('Sleepy'),
                      ),
                      DropdownMenuItem<FaceType>(
                        value: FaceType.surprised,
                        child: Text('Surprised'),
                      ),
                    ],
                    onChanged: (FaceType? value) {
                      if (value != null) {
                        setState(() => selectedFace = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
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
                                  'assets/corgi.png',
                                  width: canvasSide,
                                  height: canvasSide,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                    child: CustomPaint(
                    size: Size(canvasSide, canvasSide),
                      painter: const BullseyePainter(),
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

class SmileyPainter extends CustomPainter {
  SmileyPainter({required this.mood, required this.faceType});

  final double mood;
  final FaceType faceType;
  @override
  void paint(Canvas canvas, Size size) {
    // Modules 2–3: add eyes and mouth here. Base every position on size, center, or radius.
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.4;

    final Color faceColor;
    final double curve;

    final leftEye = center + Offset(-radius * 0.35, -radius * 0.25);
    final rightEye = center + Offset(radius * 0.35, -radius * 0.25);

    if (mood < 0.35) {
      faceColor = Colors.blue.shade300;
      curve = -0.3 - ((0.35 - mood) / 0.35) * 0.7;
    } else if (mood <= 0.7) {
      faceColor = Colors.yellow.shade600;
      curve = ((mood - 0.35) / 0.35) * 0.3;
    } else {
      faceColor = Colors.orange.shade400;
      curve = 0.6 + ((mood - 0.7) / 0.3) * 0.4;
    }

    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, facePaint);

    final borderPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.10;

    canvas.drawCircle(center, radius, borderPaint);

    final eyePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.fill;

    if (faceType == FaceType.sleepy) {
      final closedEyePaint = Paint()
        ..color = Colors.black87
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.06
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(
        leftEye + Offset(-radius * 0.13, 0),
        leftEye + Offset(radius * 0.13, 0),
        closedEyePaint,
      );

      canvas.drawLine(
        rightEye + Offset(-radius * 0.13, 0),
        rightEye + Offset(radius * 0.13, 0),
        closedEyePaint,
      );
    } else {
      final eyeRadius =
          radius * (faceType == FaceType.surprised ? 0.16 : 0.10);

      canvas.drawCircle(leftEye, eyeRadius, eyePaint);
      canvas.drawCircle(rightEye, eyeRadius, eyePaint);
    }

    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.08
      ..strokeCap = StrokeCap.round;

    final mouthCenter = center + Offset(0, radius * 0.35);
    final mouthWidth = radius * 1.1;

    if (curve.abs() < 0.01) {
      canvas.drawLine(
        mouthCenter + Offset(-mouthWidth / 2, 0),
        mouthCenter + Offset(mouthWidth / 2, 0),
        mouthPaint,
      );
    } else {
      final mouthRect = Rect.fromCenter(
        center: mouthCenter,
        width: mouthWidth,
        height: radius * 0.8 * curve.abs(),
      );

      canvas.drawArc(
        mouthRect,
        0,
        curve > 0 ? pi : -pi,
        false,
        mouthPaint,
      );
    }

    final hatPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - radius * 0.55,
        center.dy - radius * 1.15,
        radius * 1.10,
        radius * 0.45,
      ),
      hatPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        center.dx - radius * 0.80,
        center.dy - radius * 0.75,
        radius * 1.60,
        radius * 0.10,
      ),
      hatPaint,
    );
  }
  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.faceType != faceType;
  }
}

class BullseyePainter extends CustomPainter {
  const BullseyePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * 0.4;

    final outerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final middlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final innerPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, outerPaint);
    canvas.drawCircle(center, radius * 2 / 3, middlePaint);
    canvas.drawCircle(center, radius / 3, innerPaint);
  }

  @override
  bool shouldRepaint(covariant BullseyePainter oldDelegate) {
    return false;
  }
}