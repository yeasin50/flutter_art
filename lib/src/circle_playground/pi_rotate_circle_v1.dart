import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'dart:math' as math;

@Deprecated("use [PiCircleRotationWithTimer]")
class PiCircleRotationV1 extends StatefulWidget {
  const PiCircleRotationV1({super.key});

  @override
  State<PiCircleRotationV1> createState() => _CircleRotationState();
}

class _CircleRotationState extends State<PiCircleRotationV1> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation animation;

  int cycle = 0;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      // upperBound: math.pi, //it still lies here
    );
    _controller
      ..addStatusListener((status) {
        if (_controller.isCompleted) {
          _controller.forward(from: 0);
          cycle += 1;
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: SizedBox(
            width: constraints.maxWidth * .6,
            height: constraints.maxWidth * .6,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: CircleRotationPainter(
                    cycle: cycle,
                    value: _controller.value,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

double _deg2Rad(double deg) => deg * (math.pi / 180);

List<Offset> points = [];

class CircleRotationPainter extends CustomPainter {
  final double value;
  final int cycle;

  CircleRotationPainter({required this.value, this.cycle = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final outlinePaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 4 - 10;

    //border
    final firstBorder = Path()..addOval(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(firstBorder, outlinePaint);

    final ui.PathMetrics pathMetrics = firstBorder.computeMetrics();

    for (ui.PathMetric pathMetric in pathMetrics) {
      Path extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * (value),
      );

      try {
        final metric = extractPath.computeMetrics().first;
        final offset = metric.getTangentForOffset(metric.length)!.position;

        ///inner radius ball
        canvas.drawCircle(offset, 7, Paint()..color = Colors.greenAccent);
        canvas.drawLine(offset, center, outlinePaint);

        ///second ball circle around radius ball
        final secondBallAngle = (cycle + value) * math.pi;
        final sOffset = Offset(
          offset.dx + radius * math.sin(secondBallAngle),
          offset.dy + radius * math.cos(secondBallAngle),
        );

        canvas.drawCircle(sOffset, 5, Paint()..color = Colors.orange);
        canvas.drawLine(sOffset, offset, outlinePaint);

        points.add(sOffset);
      } catch (e) {}
    }

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
  bool shouldRepaint(covariant CircleRotationPainter oldDelegate) => oldDelegate.value != value;
}
