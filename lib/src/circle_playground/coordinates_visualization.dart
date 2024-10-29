import 'package:flutter/material.dart';
import 'dart:math' as math;

class CoordinatesVisualization extends StatefulWidget {
  const CoordinatesVisualization({super.key});

  @override
  State<CoordinatesVisualization> createState() => _CoordinatesVisualizationState();
}

class _CoordinatesVisualizationState extends State<CoordinatesVisualization> {
  double angle = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Coordinate visualization")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 48),
            Expanded(
              child: CustomPaint(
                painter: _CircleCoordinatesPainter(angle),
                child: const SizedBox.expand(),
              ),
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                const Text("X"),
                Expanded(
                  child: Slider(
                    value: angle,
                    min: 0,
                    max: 360,
                    divisions: 360,
                    onChanged: (value) {
                      angle = value;
                      setState(() {});
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

double _deg2Rad(double deg) => deg * (math.pi / 180);

class _CircleCoordinatesPainter extends CustomPainter {
  const _CircleCoordinatesPainter(this.angle);

  final double angle;

  @override
  void paint(Canvas canvas, Size size) {
    final outlinePaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final firstBorder = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawPath(firstBorder, outlinePaint);

    canvas.drawCircle(center, 4, Paint()..color = Colors.red);

    final sOffset = Offset(
      center.dx + radius * math.cos(_deg2Rad(angle)),
      center.dy + radius * math.sin(_deg2Rad(angle)),
    );

    canvas.drawCircle(sOffset, 8, Paint()..color = Colors.green);
    canvas.drawLine(sOffset, center, Paint()..color = Colors.white.withAlpha(100));
  }

  @override
  bool shouldRepaint(covariant _CircleCoordinatesPainter oldDelegate) => oldDelegate.angle != angle;
}
