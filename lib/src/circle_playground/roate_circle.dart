import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircleRotation extends StatefulWidget {
  const CircleRotation({super.key});

  @override
  State<CircleRotation> createState() => _CircleRotationState();
}

class _CircleRotationState extends State<CircleRotation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
    _animation = Tween(begin: 0.0, end: 2 * math.pi).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) => Center(
          child: SizedBox(
            width: constraints.maxWidth * .6,
            height: constraints.maxWidth * .6,
            child: CustomPaint(
              painter: CircleRotationPainter(animation: _controller),
            ),
          ),
        ),
      ),
    );
  }
}

double _deg2Rad(double deg) => deg * (math.pi / 180);

class CircleRotationPainter extends CustomPainter {
  final AnimationController animation;

  CircleRotationPainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;
    //border
    canvas.drawCircle(center, radius, paint);

    //center
    canvas.drawCircle(
      center,
      5,
      paint
        ..color = Colors.red
        ..style = PaintingStyle.fill,
    );

    /// rotation ball
    paint.color = Colors.white;
    final ballRadius = 10.0;
    final angle = _deg2Rad(animation.value * 360);
    final ballCenter = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    canvas.drawCircle(ballCenter, ballRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CircleRotationPainter oldDelegate) =>
      oldDelegate.animation != animation;
}
