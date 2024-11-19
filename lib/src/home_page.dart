import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'circle_playground/circle_division_v0.dart';
import 'circle_playground/coordinates_visualization.dart';
import 'circle_playground/pi_rotate_with_timer.dart';
import 'shader_practice/color_opacity_with_shader.dart';
import 'shader_practice/madelbrot_factal_shader_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, Widget> items = {
    "circle coordinates": const CoordinatesVisualization(),
    "circle division": const CircleDivision(),
    // "Pi being irrational": const PiCircleRotation(),
    // "Pi being irrational V1": const PiCircleRotationV1(),
    "Pi being irrational VTimer": const PiCircleRotationWithTimer(),
    "simple shader": const FragmentPractice(),
    "Mandelbrot shader": const MandelbrotFractalPage(),
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          runSpacing: 16,
          spacing: 16,
          children: items.keys.mapIndexed(
            (i, e) {
              return InkWell(
                child: Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  color: Colors.primaries[i % Colors.primaries.length],
                  child: Text(
                    e,
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  final route = MaterialPageRoute(
                    builder: (context) => items[e]!,
                  );
                  Navigator.of(context).push(route);
                },
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
