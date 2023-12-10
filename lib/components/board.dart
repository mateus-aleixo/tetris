import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tetris/components/piece.dart';
import 'package:tetris/components/pixel.dart';

const int rows = 15;
const int columns = 10;

List<List<Tetromino?>> board = List.generate(
  rows,
  (index) => List.generate(
    columns,
    (index) => null,
  ),
);

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  int score = 0;
  bool _isGameOver = false;

  late Timer _gameTimer;

  Piece currentPiece = Piece(
    type: Tetromino.values[Random().nextInt(Tetromino.values.length)],
  );

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.initialize();

    Duration frameRate = const Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    _gameTimer = Timer.periodic(
      frameRate,
      (timer) {
        setState(
          () {
            clearRows();
            updateGame();

            if (_isGameOver) {
              timer.cancel();
              gameOver();
            }

            currentPiece.move(Direction.down);
          },
        );
      },
    );
  }

  bool hasCollision(Direction direction) {
    for (int element in currentPiece.position) {
      int row = element ~/ columns;
      int column = element % columns;

      switch (direction) {
        case Direction.left:
          column--;
          break;
        case Direction.right:
          column++;
          break;
        case Direction.down:
          row++;
          break;
      }

      if (row >= rows || column < 0 || column >= columns) {
        return true;
      } else if (row > 0 &&
          row < rows &&
          column > 0 &&
          column < columns &&
          board[row][column] != null) {
        return true;
      }
    }

    return false;
  }

  void lockPiece() {
    for (int element in currentPiece.position) {
      int row = element ~/ columns;
      int column = element % columns;

      if (row >= 0 && row < rows && column >= 0 && column < columns) {
        board[row][column] = currentPiece.type;
      }
    }
  }

  void spawnPiece() {
    currentPiece = Piece(
      type: Tetromino.values[Random().nextInt(Tetromino.values.length)],
    );
    currentPiece.initialize();

    if (isGameOver()) {
      setState(() {
        _isGameOver = true;
      });
    }
  }

  void updateGame() {
    if (hasCollision(Direction.down)) {
      lockPiece();
      spawnPiece();
    }
  }

  void move(Direction direction) {
    if (!hasCollision(direction)) {
      setState(() {
        currentPiece.move(direction);
      });
    }
  }

  void drop() {
    while (!hasCollision(Direction.down)) {
      setState(() {
        currentPiece.move(Direction.down);
      });
    }
  }

  void rotate() {
    setState(() {
      currentPiece.rotate();
    });
  }

  void clearRows() {
    for (int row = rows - 1; row >= 0; row--) {
      bool isFull = true;

      for (int column = 0; column < columns; column++) {
        if (board[row][column] == null) {
          isFull = false;
          break;
        }
      }

      if (isFull) {
        for (int r = row; r > 0; r--) {
          board[r] = List.from(board[r - 1]);
        }

        board[0] = List.generate(
          row,
          (index) => null,
        );

        score++;
      }
    }
  }

  bool isGameOver() {
    for (int column = 0; column < columns; column++) {
      if (board[0][column] != null) {
        return true;
      }
    }

    return false;
  }

  void gameOver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Game Over"),
        content: Text("Score: $score"),
        actions: [
          TextButton(
            onPressed: () {
              reset();
              Navigator.pop(context);
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }

  void reset() {
    if (_gameTimer.isActive) {
      _gameTimer.cancel();
    }

    board = List.generate(
      rows,
      (index) => List.generate(
        columns,
        (index) => null,
      ),
    );

    score = 0;
    _isGameOver = false;

    spawnPiece();
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKey: (node, event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          move(Direction.left);
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          move(Direction.right);
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
          move(Direction.down);
        } else if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          drop();
        } else if (event.isKeyPressed(LogicalKeyboardKey.keyU)) {
          reset();
        } else if (event.isKeyPressed(LogicalKeyboardKey.keyR)) {
          rotate();
        }

        return KeyEventResult.handled;
      },
      autofocus: true,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    itemCount: rows * columns,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                    ),
                    itemBuilder: (context, index) {
                      int row = index ~/ columns;
                      int column = index % columns;

                      if (currentPiece.position.contains(index)) {
                        return Pixel(
                          color: currentPiece.color,
                        );
                      } else if (board[row][column] != null) {
                        return Pixel(
                          color: Piece.colors[board[row][column]]!,
                        );
                      } else {
                        return Pixel(
                          color: Colors.grey[900],
                        );
                      }
                    },
                  ),
                ),
                Text(
                  "Score: $score",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                    bottom: 50.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => move(Direction.left),
                        color: Colors.white,
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      IconButton(
                        onPressed: () => rotate(),
                        color: Colors.white,
                        icon: const Icon(Icons.rotate_right),
                      ),
                      IconButton(
                        onPressed: () => move(Direction.right),
                        color: Colors.white,
                        icon: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
