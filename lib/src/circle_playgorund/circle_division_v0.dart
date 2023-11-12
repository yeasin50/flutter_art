import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircleDivision extends StatefulWidget {
  const CircleDivision({super.key});

  @override
  State<CircleDivision> createState() => _CircleRotationState();
}

class _CircleRotationState extends State<CircleDivision>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation animation;

  double sides = 0;
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
        }
      })
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) => Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: constraints.maxWidth * .6,
                  height: constraints.maxWidth * .6,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: CircleDivisionPainter(
                          side: sides.toInt(),
                          value: _controller.value,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Slider(
              value: sides,
              min: 0,
              max: 25,
              divisions: 360,
              onChanged: (value) {
                setState(() {
                  sides = value;
                });
              },
            ),
            const SizedBox(height: 24)
          ],
        ),
      ),
    );
  }
}

double _deg2Rad(double deg) => deg * (math.pi / 180);

List<Offset> points = [];

class CircleDivisionPainter extends CustomPainter {
  final double value;
  final int side;

  CircleDivisionPainter({required this.value, this.side = 1});

  @override
  void paint(Canvas canvas, Size size) {
    final outlinePaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;

    //border
    final firstBorder = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(firstBorder, outlinePaint);

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

    for (int i = 1; i <= side; i++) {
      final angle = (math.pi * 2) / side * i;
      final ballCenter = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      /// radius ball
      canvas.drawCircle(ballCenter, 5, outlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CircleDivisionPainter oldDelegate) =>
      oldDelegate.value != value;
}
