import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => GameState(),
        child: MyHomePage(),
      ),
    );
  }
}

class GameState extends ChangeNotifier {
  List<List<IconData?>> board = List.generate(3, (_) => List.filled(3, null));
  bool playerXTurn = true;
  bool gameEnded = false;

  bool checkWinner(int row, int col, IconData? currentSymbol) {
    // Check horizontal line
    if (board[row].every((cell) => cell == currentSymbol)) {
      return true;
    }

    // Check vertical line
    if (board.every((row) => row[col] == currentSymbol)) {
      return true;
    }

    // Check main diagonal
    // if (row == col && board.every((row) => row[col] == currentSymbol)) {
    //   return true;
    // }
    if (row==col && [board[0][0], board[1][1], board[2][2]].every((cell) => cell == currentSymbol)) {
      return true;
    }

    // Check anti-diagonal
    if (row + col == 2 && [board[0][2], board[1][1], board[2][0]].every((cell) => cell == currentSymbol)) {
      return true;
    }

    return false;
  }

  void makeMove(int row, int col, BuildContext context) {
    if (!gameEnded && board[row][col] == null) {
      IconData currentSymbol = playerXTurn ? Icons.clear : Icons.circle_outlined;
      board[row][col] = currentSymbol;

      if (checkWinner(row, col, currentSymbol)) {
        gameEnded = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Player ${currentSymbol == Icons.clear ? 'X' : 'O'} wins!', style: TextStyle(color: playerXTurn ? Colors.red : Colors.blue)),
              actions: [
                TextButton(
                  onPressed: () {
                    resetGame();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK', style: TextStyle(color: playerXTurn ? Colors.red : Colors.blue)),
                ),
              ],
            );
          },
        );
      } else if (board.every((row) => row.every((cell) => cell != null))) {
        gameEnded = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('It\'s a draw!', style: TextStyle(color: Colors.orange)),
              actions: [
                TextButton(
                  onPressed: () {
                    resetGame();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK', style: TextStyle(color: Colors.orange)),
                ),
              ],
            );
          },
        );
      } else {
        playerXTurn = !playerXTurn;
      }
      notifyListeners();
    }
  }

  void resetGame() {
    board = List.generate(3, (_) => List.filled(3, null));
    playerXTurn = true;
    gameEnded = false;
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Player ${Provider.of<GameState>(context).playerXTurn ? 'X' : 'O'}\'s turn',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return InkWell(
                    onTap: () {
                      Provider.of<GameState>(context, listen: false).makeMove(row, col, context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Provider.of<GameState>(context).board[row][col] != null
                            ? Icon(
                          Provider.of<GameState>(context).board[row][col]!,
                          size: 50,
                          color: Provider.of<GameState>(context).board[row][col] == Icons.clear ? Colors.red : Colors.black,
                        )
                            : SizedBox.shrink(),
                      ),
                    ),
                  );
                },
                itemCount: 9,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Provider.of<GameState>(context, listen: false).resetGame();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text('Reset Game', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}