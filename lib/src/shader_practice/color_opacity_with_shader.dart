import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui';

void main(List<String> args) {
  runApp(const MaterialApp(home: FragmentPractice()));
}

class FragmentPractice extends StatefulWidget {
  const FragmentPractice({super.key});

  @override
  State<FragmentPractice> createState() => _FragmentTestState();
}

class _FragmentTestState extends State<FragmentPractice>
    with SingleTickerProviderStateMixin {
  Future<FragmentProgram> loadMyShader() async =>
      await FragmentProgram.fromAsset('assets/shaders/test.frag');

  late final Future<FragmentProgram> _program = loadMyShader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return ShaderBuilder(shader: shader);
          },
        ),
      ),
    );
  }
}

class ShaderBuilder extends StatefulWidget {
  const ShaderBuilder({
    super.key,
    required this.shader,
  });

  final FragmentProgram shader;

  @override
  State<ShaderBuilder> createState() => _ShaderBuilderState();
}

class _ShaderBuilderState extends State<ShaderBuilder>
    with SingleTickerProviderStateMixin {
  late final FragmentShader shader = widget.shader.fragmentShader();

  ValueNotifier<double> _sliderValueNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(
            painter:
                _CircleRotationPainter(shader, value: _sliderValueNotifier),
          ),
        ),
        Slider(
          value: _sliderValueNotifier.value,
          onChanged: (value) {
            _sliderValueNotifier.value = value;
            setState(() {});
          },
        ),
      ],
    );
  }
}

class _CircleRotationPainter extends CustomPainter {
  const _CircleRotationPainter(
    this.shader, {
    required this.value,
  }) : super(repaint: value);

  final FragmentShader shader;
  final ValueNotifier<double> value;

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(0, value.value);
 
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant _CircleRotationPainter oldDelegate) => false;
}
