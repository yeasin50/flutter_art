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
  ValueNotifier<double> valueNotifier = ValueNotifier<double>(100);
  Timer? timer;

  _initTimer() {
    timer?.cancel();
    timer = null;

    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        valueNotifier.value += 1;
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text("time: ${Duration(milliseconds: (timer?.tick ?? 0) * 10).toString().substring(0, 10)}"),
          ),
          Expanded(
            child: InteractiveViewer(
              minScale: 0.1,
              maxScale: 16,
              child: AspectRatio(
                aspectRatio: 1,
                child: AnimatedBuilder(
                  animation: valueNotifier,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: CircleRotationPainter(value: valueNotifier),
                    );
                  },
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  timer?.isActive == true ? timer?.cancel() : _initTimer();
                },
                child: Text(timer?.isActive == true ? 'Stop' : 'Start'),
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
          const SizedBox(height: 48)
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
  CircleRotationPainter({
    required this.value,
  }) : super(repaint: value);

  final ValueNotifier<double> value;

  @override
  void paint(Canvas canvas, Size size) {
    final outlinePaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 4 - 10;

    //border
    final firstBorder = Path()..addOval(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(firstBorder, outlinePaint);

    final angle = _deg2Rad(value.value);

    final offset = Offset(
      center.dx + radius * math.sin(angle),
      center.dy + radius * math.cos(angle),
    );

    ///second ball circle around radius ball
    final secondBallAngle = _deg2Rad(value.value * math.pi);
    final sOffset = Offset(
      offset.dx + radius * math.sin(secondBallAngle),
      offset.dy + radius * math.cos(secondBallAngle),
    );

    ///🤔 should I drop the overlapping points?

    points.add(sOffset);

    canvas.drawPoints(
      ui.PointMode.polygon,
      points,
      Paint()..color = Colors.cyanAccent,
    );

    ///inner radius ball and line
    canvas.drawCircle(offset, 7, Paint()..color = Colors.greenAccent);
    canvas.drawLine(offset, center, outlinePaint);

    ///second(outer) ball and line
    canvas.drawCircle(sOffset, 5, Paint()..color = Colors.orange);
    canvas.drawLine(sOffset, offset, outlinePaint);

    //center
    canvas.drawCircle(
      center,
      3,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CircleRotationPainter oldDelegate) => false;
}
