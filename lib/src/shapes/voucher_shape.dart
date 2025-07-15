
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: AspectRatio(
            aspectRatio: 4 / 2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: Material(
                    color: Colors.red,
                    shape: VoucherShapeBorder(xShift: .25),
                  ),
                ),
                Align(
                  // left: 24, //for Positioned widget 
                  // top: 24,
                  // bottom: 24,
                  alignment: Alignment(-.87, 0),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Text(
                      "60% off",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                Positioned(
                  right: 24,
                  top: 24,
                  bottom: 24,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Text("Some details we gonna have ")],
                  ),
                  //
                ),
              ],
            ),
          ),
        ), //
      ),
    );
  }
}

class VoucherShapeBorder extends OutlinedBorder {
  const VoucherShapeBorder({this.xShift = .3});
  final double xShift;
  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return this;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    path.addRect(rect);

    final horizontalCircleRadius = rect.height * .2;

    final cutSections = Path();

    ///  top cut
    cutSections.addOval(
      Rect.fromCircle(
        center: Offset(rect.left + xShift * rect.width, rect.top),
        radius: horizontalCircleRadius,
      ),
    );

    // bottom cut
    cutSections.addOval(
      Rect.fromCircle(
        center: Offset(rect.left + xShift * rect.width, rect.bottom),
        radius: horizontalCircleRadius,
      ),
    );

    double radius = 15;

    /// left cuts
    for (
      double y = rect.top + 5 + radius;
      y < rect.bottom - 5;
      y += radius * 2
    ) {
      final center = Offset(rect.left - (radius / 2), y);
      final oval = Rect.fromCircle(center: center, radius: radius);
      cutSections.addOval(oval);
    }

    // right path
    for (
      double y = rect.top + 5 + radius;
      y < rect.bottom - 5;
      y += radius * 2
    ) {
      final center = Offset(rect.right + (radius / 2), y);
      final oval = Rect.fromCircle(center: center, radius: radius);
      cutSections.addOval(oval);
    }

    return Path.combine(PathOperation.difference, path, cutSections);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint()..color = Colors.green;

    final path = getInnerPath(rect);

    final leftSection = Path.combine(
      PathOperation.difference,
      path,
      Path()..addRect(
        Rect.fromLTWH(rect.left, rect.top, rect.width * xShift, rect.height),
      ),
    );

    canvas.drawPath(leftSection, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return this;
  }
}
