import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

@Deprecated("use [PiCircleRotationWithTimer]")
class PiCircleRotation extends StatefulWidget {
  const PiCircleRotation({super.key});

  @override
  State<PiCircleRotation> createState() => _CircleRotationState();
}

class _CircleRotationState extends State<PiCircleRotation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100 * 3),
    )..repeat();
    _animation = Tween(begin: 0.0, end: 100 * math.pi).animate(_controller);
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
            child: CustomPaint(
              painter: CircleRotationPainter(animation: _animation),
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
  final Animation animation;

  CircleRotationPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final outlinePaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 4 - 10;

    //border
    // canvas.drawCircle(center, radius, outlinePaint);

    //center
    canvas.drawCircle(
      center,
      5,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill,
    );

    /// rotation ball

    final ballRadius = 5.0;
    final angle = _deg2Rad(animation.value * 100);
    final ballCenter = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    /// radius ball
    canvas.drawCircle(ballCenter, ballRadius, outlinePaint);

    ///center to ball line
    canvas.drawLine(center, ballCenter, outlinePaint);

    double realPart = math.cos(math.pi);
    double imaginaryPart = math.sin(math.pi);

    final secondBallAngle = animation.value * 22 / 7; //math.pi;

    ///second ball focus on radius ball
    final secondBallCenter = Offset(
      ballCenter.dx + radius * math.cos(secondBallAngle),
      ballCenter.dy + radius * math.sin(secondBallAngle),
    );

    points.add(secondBallCenter);

    canvas.drawPoints(
      PointMode.polygon,
      points,
      Paint()
        ..color = Colors.cyanAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    canvas.drawCircle(
      secondBallCenter,
      5,
      Paint()
        ..color = Colors.green
        ..style = PaintingStyle.fill,
    );

    canvas.drawLine(secondBallCenter, ballCenter, Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(covariant CircleRotationPainter oldDelegate) => oldDelegate.animation != animation;
}
