import 'dart:ui';

import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MaterialApp(
    home: MandelbrotFractalPage(),
  ));
}

class MandelbrotFractalPage extends StatefulWidget {
  const MandelbrotFractalPage({super.key});

  @override
  State<MandelbrotFractalPage> createState() => _MandelbrotFractalPageState();
}

class _MandelbrotFractalPageState extends State<MandelbrotFractalPage> {
  Future<FragmentProgram> loadMyShader() async =>
      await FragmentProgram.fromAsset('assets/shaders/mandelbrot_fractal.frag');

  late final Future<FragmentProgram> _program = loadMyShader();

  double time = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FutureBuilder<FragmentProgram>(
          future: _program,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("error loading shader: ${snapshot.error}");
            }
            if (snapshot.hasData == false) {
              return const Text("loading shader...");
            }
            final shader = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: CustomPaint(
                    isComplex: true,
                    painter: MandelbrotFractalPainter(shader, time: time),
                    child: const SizedBox.expand(),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: 50,
                        value: time,
                        onChanged: (value) {
                          time = value;
                          print(time);
                          setState(() {});
                        },
                      ),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class MandelbrotFractalPainter extends CustomPainter {
  const MandelbrotFractalPainter(
    this.program, {
    required this.time,
  });

  final FragmentProgram program;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader()
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(MandelbrotFractalPainter oldDelegate) => oldDelegate.time != time;
}
