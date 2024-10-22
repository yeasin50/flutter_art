import 'package:flutter/material.dart';

import 'src/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(
          // scaffoldBackgroundColor: Colors.black,
          ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
