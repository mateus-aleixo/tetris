import 'package:flutter/material.dart';
import 'package:tetris/components/board.dart';

class Tetris extends StatefulWidget {
  const Tetris({super.key});

  @override
  State<Tetris> createState() => _TetrisState();
}

class _TetrisState extends State<Tetris> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Board(),
    );
  }
}
