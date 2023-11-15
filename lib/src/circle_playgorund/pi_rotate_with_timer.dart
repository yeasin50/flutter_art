import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'dart:math' as math;

/// circle rotation with timer
///
class PiCircleRotationWithTimer extends StatefulWidget {
  const PiCircleRotationWithTimer({super.key});

  @override
  State<PiCircleRotationWithTimer> createState() => _CircleRotationState();
}

class _CircleRotationState extends State<PiCircleRotationWithTimer> {
  ValueNotifier<double> valueNotifier = ValueNotifier<double>(217);
  late Timer timer;

  _initTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        valueNotifier.value += 1;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => Center(
                child: SizedBox(
                  width: constraints.maxWidth * .6,
                  height: constraints.maxWidth * .6,
                  child: AnimatedBuilder(
                    animation: valueNotifier,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: CircleRotationPainter(
                          value: valueNotifier,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  timer.isActive ? timer.cancel() : _initTimer();
                },
                child: Text(timer.isActive ? 'Stop' : 'Start'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    points.clear();
                  });
                },
                child: const Text('clear'),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

double _deg2Rad(double deg) => deg * (math.pi / 180);

/// Global list of points 🤣
List<Offset> points = [];

/// circle rotation painter
/// the inner ball is rotating around the circle with radius and angle of the [value]
/// the second ball is rotating around the inner ball with radius and angle of the `[value] * [math.pi]
/// the points are the second ball points
///
class CircleRotationPainter extends CustomPainter {
  final ValueNotifier<double> value;

  CircleRotationPainter({required this.value}) : super(repaint: value);

  @override
  void paint(Canvas canvas, Size size) {
    final outlinePaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 4 - 10;

    //border
    final firstBorder = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(firstBorder, outlinePaint);

    final angle = _deg2Rad(value.value);

    final offset = Offset(
      center.dx + radius * math.sin(angle),
      center.dy + radius * math.cos(angle),
    );

    ///inner radius ball
    canvas.drawCircle(offset, 7, Paint()..color = Colors.greenAccent);
    canvas.drawLine(offset, center, outlinePaint);

    ///second ball circle around radius ball
    final secondBallAngle = _deg2Rad(value.value * math.pi);
    final sOffset = Offset(
      offset.dx + radius * math.sin(secondBallAngle),
      offset.dy + radius * math.cos(secondBallAngle),
    );

    canvas.drawCircle(sOffset, 5, Paint()..color = Colors.orange);
    canvas.drawLine(sOffset, offset, outlinePaint);

    ///🤔 should I drop the overlapping points?

    points.add(sOffset);

    canvas.drawPoints(
      ui.PointMode.polygon,
      points,
      Paint()..color = Colors.cyanAccent,
    );

    //center
    canvas.drawCircle(
      center,
      5,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CircleRotationPainter oldDelegate) =>
      oldDelegate.value != value;
}
