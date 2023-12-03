import 'package:flutter/material.dart';
import 'package:tetris/tetris.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
      ).copyWith(
        scaffoldBackgroundColor: Colors.black,
        dividerColor: const Color(0xFF2F2F2F),
        dividerTheme: const DividerThemeData(thickness: 10),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Tetris(),
    );
  }
}
