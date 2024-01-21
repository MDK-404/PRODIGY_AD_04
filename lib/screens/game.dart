import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainColor {
  static const primaryColor = Colors.blue;
  static const secondaryColor = Colors.black;
  static const accentColor = Colors.green;
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String currentPlayer = 'O'; // Default starting player

  bool oTurn = true;
  List<String> displayXO = ['', '', '', '', '', '', '', '', ''];
  List<int> matchedIndexes = [];
  int attempts = 0;

  int oScore = 0;
  int xScore = 0;
  int filledBoxes = 0;
  String resultDeclaration = '';
  bool winnerFound = false;

  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer? timer;

  static var customFontWhite = GoogleFonts.coiny(
    textStyle: TextStyle(
      color: Colors.white,
      letterSpacing: 3,
      fontSize: 28,
    ),
  );



  void stopTimer() {
    resetTimer();
    timer?.cancel();
  }

  void resetTimer() => seconds = maxSeconds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPlayerScore('O', oScore, oTurn),
                    SizedBox(width: 20),
                    _buildPlayerScore('X', xScore, !oTurn),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      _tapped(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 5,
                          color: MainColor.primaryColor,
                        ),
                        color: matchedIndexes.contains(index)
                            ? MainColor.accentColor
                            : MainColor.secondaryColor,
                      ),
                      child: Center(
                        child: Text(
                          displayXO[index],
                          style: GoogleFonts.coiny(
                            textStyle: TextStyle(
                              fontSize: 64,
                              color: matchedIndexes.contains(index)
                                  ? MainColor.secondaryColor
                                  : MainColor.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(resultDeclaration, style: customFontWhite),
                    SizedBox(height: 10),
                    _buildTimer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerScore(String player, int score, bool isCurrentPlayer) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: isCurrentPlayer ? MainColor.accentColor : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10),
        color: isCurrentPlayer ? MainColor.accentColor : Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            color: isCurrentPlayer ? MainColor.accentColor : Colors.transparent,
            child: Text(
              'Player $player',
              style: GoogleFonts.coiny(
                textStyle: TextStyle(
                  color: Colors.white ,
                  letterSpacing: 3,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          Text(
            score.toString(),
            style: customFontWhite,
          ),
        ],
      ),
    );
  }

  void _tapped(int index) {
    final isRunning = timer == null ? false : timer!.isActive;

    if (isRunning) {
      setState(() {
        if (oTurn && displayXO[index] == '') {
          displayXO[index] = 'O';
          filledBoxes++;
        } else if (!oTurn && displayXO[index] == '') {
          displayXO[index] = 'X';
          filledBoxes++;
        }

        oTurn = !oTurn;
        _checkWinner();
      });
    }
  }


  void _checkWinner() {
    // check 1st row
    if (displayXO[0] == displayXO[1] &&
        displayXO[0] == displayXO[2] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[0] + ' Wins!';
        matchedIndexes.addAll([0, 1, 2]);
        stopTimer();
        _updateScore(displayXO[0]);
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _clearBoard();
        });
      });
    }

    // check 2nd row
    if (displayXO[3] == displayXO[4] &&
        displayXO[3] == displayXO[5] &&
        displayXO[3] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[3] + ' Wins!';
        matchedIndexes.addAll([3, 4, 5]);
        stopTimer();
        _updateScore(displayXO[3]);
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _clearBoard();
        });
      });
    }

    // check 3rd row
    if (displayXO[6] == displayXO[7] &&
        displayXO[6] == displayXO[8] &&
        displayXO[6] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[6] + ' Wins!';
        matchedIndexes.addAll([6, 7, 8]);
        stopTimer();
        _updateScore(displayXO[6]);
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _clearBoard();
        });
      });
    }

    // check 1st column
    if (displayXO[0] == displayXO[3] &&
        displayXO[0] == displayXO[6] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[0] + ' Wins!';
        matchedIndexes.addAll([0, 3, 6]);
        stopTimer();
        _updateScore(displayXO[0]);
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _clearBoard();
        });
      });
    }

    // check 2nd column
    if (displayXO[1] == displayXO[4] &&
        displayXO[1] == displayXO[7] &&
        displayXO[1] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[1] + ' Wins!';
        matchedIndexes.addAll([1, 4, 7]);
        stopTimer();
        _updateScore(displayXO[1]);
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _clearBoard();
        });
      });
    }

    // check 3rd column
    if (displayXO[2] == displayXO[5] &&
        displayXO[2] == displayXO[8] &&
        displayXO[2] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[2] + ' Wins!';
        matchedIndexes.addAll([2, 5, 8]);
        stopTimer();
        _updateScore(displayXO[2]);
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _clearBoard();
        });
      });
    }

    // check diagonal
    if (displayXO[0] == displayXO[4] &&
        displayXO[0] == displayXO[8] &&
        displayXO[0] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[0] + ' Wins!';
        matchedIndexes.addAll([0, 4, 8]);
        stopTimer();
        _updateScore(displayXO[0]);
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _clearBoard();
        });
      });
    }

    // check diagonal
    if (displayXO[6] == displayXO[4] &&
        displayXO[6] == displayXO[2] &&
        displayXO[6] != '') {
      setState(() {
        resultDeclaration = 'Player ' + displayXO[6] + ' Wins!';
        matchedIndexes.addAll([6, 4, 2]);
        stopTimer();
        _updateScore(displayXO[6]);
      });

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _clearBoard();
        });
      });
    }
    else  if (   filledBoxes == 9) {
      setState(() {
        resultDeclaration = 'Nobody Wins!';
        stopTimer();

      });
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _clearBoard();
        });
      });
    }
  }

  void _updateScore(String winner) {
    if (winner == 'O') {
      oScore++;
    } else if (winner == 'X') {
      xScore++;
    }
    winnerFound = true;
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayXO[i] = '';
      }
      resultDeclaration = '';
      matchedIndexes = [];
    });
    filledBoxes = 0;
  }

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;

    return isRunning
        ? SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: 1 - seconds / maxSeconds,
            valueColor: AlwaysStoppedAnimation(Colors.white),
            strokeWidth: 8,
            backgroundColor: MainColor.accentColor,
          ),
          Center(
            child: Text(
              '$seconds',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 50,
              ),
            ),
          ),
        ],
      ),
    )
        : ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
      onPressed: () {
        startTimer();
        _clearBoard();
        attempts++;
      },
      child: Text(
        attempts == 0 ? 'Start' : 'Play Again!',
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
    );
  }
}
