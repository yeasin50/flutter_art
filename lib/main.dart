import 'package:flutter/material.dart';

import 'src/circle_playgorund/circle_division_v0.dart';
import 'src/circle_playgorund/pi_roate_circle.dart';
import 'src/circle_playgorund/pi_rotate_circle_v1.dart';
import 'src/circle_playgorund/pi_rotate_with_timer.dart';
import 'src/circle_playgorund/roate_circle.dart';
import 'src/number/prime_number_paint.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: PrimeNumberView(),
    );
  }
}
