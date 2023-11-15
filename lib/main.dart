import 'package:flutter/material.dart';

import 'src/circle_playgorund/circle_division_v0.dart';
import 'src/circle_playgorund/pi_roate_circle.dart';
import 'src/circle_playgorund/pi_rotate_circle_v1.dart';
import 'src/circle_playgorund/pi_rotate_with_timer.dart';
import 'src/circle_playgorund/roate_circle.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PiCircleRotationWithTimer(),
    );
  }
}
