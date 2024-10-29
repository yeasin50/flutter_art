import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'dart:math' as math;

double _deg2Rad(double deg) => deg * (math.pi / 180);

/// Global list of points 🤣
List<Offset> piTravelPoints = [];

/// circle rotation with timer
///
class PiCircleRotationWithTimer extends StatefulWidget {
  const PiCircleRotationWithTimer({super.key});

  @override
  State<PiCircleRotationWithTimer> createState() => _CircleRotationState();
}

class _CircleRotationState extends State<PiCircleRotationWithTimer> {
  ValueNotifier<double> valueNotifier = ValueNotifier<double>(270);
  Timer? timer;

  void startTimer() {
    timer?.cancel();
    timer = null;

    timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        valueNotifier.value += 1;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    piTravelPoints.clear();
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
            child: Text(
              "time: ${Duration(milliseconds: (timer?.tick ?? 0) * 10).toString().substring(0, 10)}",
            ),
          ),
          Expanded(
            child: InteractiveViewer(
              clipBehavior: ui.Clip.none,
              minScale: 0.1,
              maxScale: 16,
              child: AspectRatio(
                aspectRatio: 1,
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: CircleRotationPainter(valueNotifier),
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
                  timer?.isActive == true ? timer?.cancel() : startTimer();
                },
                child: Text(timer?.isActive == true ? 'Stop' : 'Start'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  piTravelPoints.clear();
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

/// circle rotation painter
/// the inner ball is rotating around the circle with radius and angle of the [value]
/// the second ball is rotating around the inner ball with radius and angle of the `[value] * [math.pi]
/// the points are the second ball points
///
class CircleRotationPainter extends CustomPainter {
  //
  const CircleRotationPainter(this.valueNotifier) : super(repaint: valueNotifier);

  final ValueNotifier<double> valueNotifier;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 4;

    final outlinePaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawOval(
      Rect.fromCircle(center: center, radius: radius),
      outlinePaint,
    );

    final rad = _deg2Rad(valueNotifier.value);
    final offset = Offset(
      center.dx + radius * math.sin(rad),
      center.dy + radius * math.cos(rad),
    );

    final piBallAngle = _deg2Rad(valueNotifier.value * math.pi);
    final piBallOffset = Offset(
      offset.dx + radius * math.sin(piBallAngle),
      offset.dy + radius * math.cos(piBallAngle),
    );

    piTravelPoints.add(piBallOffset);

    final Path piTravelPath = Path();
    if (piTravelPoints.length > 2) {
      piTravelPath.moveTo(piTravelPoints[0].dx, piTravelPoints[0].dy);
      for (int i = 1; i < piTravelPoints.length - 1; i++) {
        final p1 = piTravelPoints[i];
        final p2 = piTravelPoints[i + 1];
        final midPoint = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);
        piTravelPath.quadraticBezierTo(p1.dx, p1.dy, midPoint.dx, midPoint.dy);
      }
      piTravelPath.lineTo(piTravelPoints.last.dx, piTravelPoints.last.dy);
    }

    canvas.drawPath(
      piTravelPath,
      Paint()
        ..color = Colors.cyanAccent
        ..style = PaintingStyle.stroke,
    );

    canvas.drawCircle(piBallOffset, 4, Paint()..color = Colors.white);
    canvas.drawLine(offset, piBallOffset, outlinePaint);

    canvas.drawCircle(offset, 7, Paint()..color = Colors.greenAccent);
    canvas.drawLine(center, offset, outlinePaint);

    ///center
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 5, height: 5),
      Paint()..color = Colors.red,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
