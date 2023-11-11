import 'package:flutter/material.dart';

import 'src/circle_playgorund/roate_circle.dart';
import 'src/features/pi_being_Irrational/pi_being_Irrational.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CircleRotation(),
    );
  }
}
