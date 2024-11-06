import 'dart:ui';

import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
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

  final controller = TransformationController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool colorize = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(onPressed: () {
            controller.value = Matrix4.identity();
          }),
          FloatingActionButton(onPressed: () {
            colorize = !colorize;
            setState(() {});
          }),
        ],
      ),
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
            return InteractiveViewer(
              transformationController: controller,
              minScale: 1,
              maxScale: 150000,
              child: CustomPaint(
                painter: MandelbrotFractalPainter(
                  shader,
                  showColor: colorize,
                ),
                child: const SizedBox.expand(),
              ),
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
    this.showColor = false,
  });

  final FragmentProgram program;
  final bool showColor;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader()
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, showColor ? .1 : 0);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(MandelbrotFractalPainter oldDelegate) => oldDelegate.showColor != showColor;
}
