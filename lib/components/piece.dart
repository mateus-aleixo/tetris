import 'package:flutter/material.dart';
import 'package:tetris/components/board.dart';

enum Direction {
  left,
  right,
  down,
}

enum Tetromino {
  I,
  O,
  T,
  J,
  L,
  S,
  Z,
}

class Piece {
  final Tetromino type;

  Piece({required this.type});

  static const Map<Tetromino, Color> colors = {
    Tetromino.I: Colors.cyan,
    Tetromino.O: Colors.yellow,
    Tetromino.T: Colors.purple,
    Tetromino.J: Colors.blue,
    Tetromino.L: Colors.orange,
    Tetromino.S: Colors.green,
    Tetromino.Z: Colors.red,
  };

  List<int> position = [];
  int height = 0;
  int rotationState = 1;

  Color get color => colors[type]!;

  void initialize() {
    disappear(List<int> pixels) => pixels.map((e) => e - height * 10).toList();

    switch (type) {
      case Tetromino.I:
        height = 1;
        position = disappear([3, 4, 5, 6]);
        break;
      case Tetromino.O:
        height = 2;
        position = disappear([4, 5, 14, 15]);
        break;
      case Tetromino.T:
        height = 2;
        position = disappear([3, 4, 5, 14]);
        break;
      case Tetromino.J:
        height = 3;
        position = disappear([5, 15, 24, 25]);
        break;
      case Tetromino.L:
        height = 3;
        position = disappear([4, 14, 24, 25]);
        break;
      case Tetromino.S:
        height = 2;
        position = disappear([4, 5, 13, 14]);
        break;
      case Tetromino.Z:
        height = 2;
        position = disappear([3, 4, 14, 15]);
        break;
    }
  }

  void move(Direction direction) {
    switch (direction) {
      case Direction.left:
        position = position.map((e) => e - 1).toList();
        break;
      case Direction.right:
        position = position.map((e) => e + 1).toList();
        break;
      case Direction.down:
        position = position.map((e) => e + 10).toList();
        break;
    }
  }

  void rotate() {
    if (type == Tetromino.O) {
      return;
    }

    List<int> rotated = [];

    switch (type) {
      case Tetromino.I:
        switch (rotationState) {
          case 0:
            rotated = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            rotated = [
              position[1] - columns,
              position[1],
              position[1] + columns,
              position[1] + 2 * columns
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            rotated = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            rotated = [
              position[1] + columns,
              position[1],
              position[1] - columns,
              position[1] - 2 * columns
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = 0;
            }
            break;
        }
        break;
      case Tetromino.T:
        switch (rotationState) {
          case 0:
            rotated = [
              position[2] - columns,
              position[2],
              position[2] + 1,
              position[2] + columns
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            rotated = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + columns
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            rotated = [
              position[1] - columns,
              position[1] - 1,
              position[1],
              position[1] + columns
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            rotated = [
              position[1] - columns,
              position[1] - 1,
              position[1],
              position[1] + 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = 0;
            }
            break;
        }
        break;
      case Tetromino.J:
        switch (rotationState) {
          case 0:
            rotated = [
              position[1] - columns,
              position[1],
              position[1] + columns,
              position[1] + columns - 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            rotated = [
              position[1] - columns - 1,
              position[1],
              position[1] - 1,
              position[1] + 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            rotated = [
              position[1] + columns,
              position[1],
              position[1] - columns,
              position[1] - columns + 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            rotated = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] + columns + 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = 0;
            }
            break;
        }
        break;
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            rotated = [
              position[1] - columns,
              position[1],
              position[1] + columns,
              position[1] + columns + 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            rotated = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + columns - 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            rotated = [
              position[1] + columns,
              position[1],
              position[1] - columns,
              position[1] - columns - 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            rotated = [
              position[1] - columns + 1,
              position[1],
              position[1] + 1,
              position[1] - 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = 0;
            }
            break;
        }
        break;
      case Tetromino.S:
        switch (rotationState) {
          case 0:
            rotated = [
              position[1],
              position[1] + 1,
              position[1] + columns - 1,
              position[1] + columns
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            rotated = [
              position[0] - columns,
              position[0],
              position[0] + 1,
              position[0] + columns + 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            rotated = [
              position[1],
              position[1] + 1,
              position[1] + columns - 1,
              position[1] + columns
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            rotated = [
              position[0] - columns,
              position[0],
              position[0] + 1,
              position[0] + columns + 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = 0;
            }
            break;
        }
        break;
      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            rotated = [
              position[0] - 1,
              position[1],
              position[2] + 1,
              position[3] + columns - 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            rotated = [
              position[0] - columns + 2,
              position[1],
              position[2] - columns + 1,
              position[3] - 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            rotated = [
              position[0] + columns - 2,
              position[1],
              position[2] + columns - 1,
              position[3] + 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            rotated = [
              position[0] - columns + 2,
              position[1],
              position[2] - columns + 1,
              position[3] - 1
            ];

            if (isValid(rotated)) {
              position = rotated;
              rotationState = 0;
            }
            break;
        }
        break;
      default:
        break;
    }
  }

  bool isValid(List<int> position) {
    bool isTaken = position.any((element) =>
        element ~/ columns < 0 ||
        element % columns < 0 ||
        board[element ~/ columns][element % columns] != null);

    if (isTaken) {
      return false;
    }

    bool isAtLeftEdge = position.any((element) => element % columns == 0);
    bool isAtRightEdge =
        position.any((element) => element % columns == columns - 1);

    return !(isAtLeftEdge && isAtRightEdge);
  }
}
