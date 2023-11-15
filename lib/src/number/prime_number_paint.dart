import 'dart:isolate';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

List<int> generatePrimes(int limit) {
  List<int> primes = [];

  if (limit >= 2) {
    primes.add(2);

    List<bool> isPrime = List.generate((limit - 1) ~/ 2 + 1, (index) => true);

    for (int num = 3; num * num <= limit; num += 2) {
      if (isPrime[(num - 1) ~/ 2]) {
        primes.add(num);
        for (int multiple = num * num; multiple <= limit; multiple += 2 * num) {
          isPrime[(multiple - 1) ~/ 2] = false;
        }
      }
    }

    for (int num = 3; num <= limit; num += 2) {
      if (isPrime[(num - 1) ~/ 2]) {
        primes.add(num);
      }
    }
  }

  return primes;
}

enum CircleType {
  sin,
  cos,
  tan,
  sec,
  cot,
  csc,
}

/// motivation https://youtu.be/EK32jo7i5LQ?si=3cAO_1JlFIixkGVU
/// but I came up with new one xD
///
/// create a circle with radius of prime number and show it on the screen
/// based on Sin, Cos, Tan with prime number radius
///
class PrimeNumberView extends StatefulWidget {
  const PrimeNumberView({super.key});

  @override
  State<PrimeNumberView> createState() => _PrimeNumberViewState();
}

class _PrimeNumberViewState extends State<PrimeNumberView> {
  List<int> _primes = [];
  List<int> currentItems = [];
  final maxNum = 1200;

  CircleType circleType = CircleType.sin;

  /// If useCenter is true, the arc is closed back to the center,
  /// forming a circle sector.
  bool useCenter = false;

  @override
  void initState() {
    super.initState();
    _primes = generatePrimes(maxNum);
  }

  @override
  Widget build(BuildContext context) {
    var inputFiled = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.white.withOpacity(.21),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  "Total prime number: ${currentItems.length}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              for (CircleType type in CircleType.values)
                Row(
                  children: [
                    Radio<CircleType>(
                      value: type,
                      groupValue: circleType,
                      onChanged: (value) {
                        setState(() {
                          circleType = value!;
                        });
                      },
                    ),
                    Text(
                      type.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              const SizedBox(width: 40),
              Row(
                children: [
                  Checkbox(
                    value: useCenter,
                    onChanged: (value) {
                      setState(() {
                        useCenter = value!;
                      });
                    },
                  ),
                  const Text(
                    "Use Center",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SizedBox.expand(
              child: CustomPaint(
                painter: PrimeNumberPinter(
                  primes: currentItems,
                  circleType: circleType,
                  useCenter: useCenter,
                ),
              ),
            ),
          ),
          inputFiled,
        ],
      ),
    );
  }
}

/// motivation https://youtu.be/EK32jo7i5LQ?si=3cAO_1JlFIixkGVU
/// create a circle with radius of prime number and show it on the screen
/// based on [CircleType]
class PrimeNumberPinter extends CustomPainter {
  PrimeNumberPinter({
    required this.primes,
    this.circleType = CircleType.sin,
    this.useCenter = false,
  });

  final CircleType circleType;
  final List<int> primes;

  /// if [useCenter] is true, the center of the circle will be drawn
  final bool useCenter;

  double _deg2Rad(num deg) => deg * (math.pi / 180);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 1;

    // center
    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, 2, paint..color = Colors.white);

    canvas.drawLine(
      Offset(0, center.dy),
      Offset(size.width, center.dy),
      paint..color = Colors.grey,
    );
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      paint..color = Colors.grey,
    );

    List<Offset> points = [];

    for (int i = 0; i < primes.length; i++) {
      final x = primes[i].toDouble();

      final y = switch (circleType) {
        CircleType.sin => math.sin(_deg2Rad(x)),
        CircleType.cos => math.cos(_deg2Rad(x)),
        CircleType.tan => math.tan(_deg2Rad(x)),
        CircleType.sec => 1 / math.sin(_deg2Rad(x)),
        CircleType.cot => 1 / math.tan(_deg2Rad(x)),
        CircleType.csc => 1 / math.cos(_deg2Rad(x)),
        _ => throw Exception('Unknown CircleType'),
      };

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: x),
        0,
        y,
        useCenter,
        paint
          ..color = Colors.primaries[i % Colors.primaries.length]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    canvas.drawPath(
      Path()..addPolygon(points, true),
      paint
        ..color = Colors.white
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant PrimeNumberPinter oldDelegate) {
    return oldDelegate.useCenter != useCenter ||
        oldDelegate.circleType != circleType ||
        oldDelegate.primes != primes;
  }
}
