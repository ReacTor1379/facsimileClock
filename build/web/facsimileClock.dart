// A facsimile of the dart Clock Sample.

library clock;

import 'dart:html';
import 'dart:math';
import 'dart:async';

part 'ball.dart';
part 'board.dart';
part 'collideBoard.dart';

void main() {

  Panel panel = new Panel();

}

setAbsolute(Element el) => el.style.position = 'absolute';

setPosition(Element el, num x, num y) => el.style.transform = 'translate(${x}px, ${y}px)';

class Panel {
  static const PADDING_SPACE = 20;

  List<NumberBoard> hours = new List<NumberBoard>(2);
  List<NumberBoard> minutes = new List<NumberBoard>(2);
  List<NumberBoard> seconds = new List<NumberBoard>(2);

  int displayedHour = 0;
  int displayedMinute = 0;
  int displayedSecond = 0;

  Element container;
  CollideBoard collideBoard;

  Panel() {
    // Contains all the displayed elements.
    container = querySelector("#container");

    createClockBoard(container);

    updateTime(new DateTime.now());

    collideBoard = new CollideBoard();

    // To trigger the tick function for the first time.
    var timer = new Timer.periodic(const Duration(milliseconds: 1000), (Timer t) => tick());
  }

  // Create the background consist by grey balls.
  void createClockBoard(Element container) {
    int wSize = NumberBoard.WIDTH * 6 + 32 + PADDING_SPACE * 7;
    int hSize = NumberBoard.HEIGHT;

    double curX = (container.clientWidth - wSize) / 2;
    double curY = (container.clientHeight - hSize) / 3;

    curX = initBoard(hours, curX, curY, 'BLUE');
    curX = initColon(curX, curY);
    curX = initBoard(minutes, curX, curY, 'RED');
    curX = initColon(curX, curY);
    curX = initBoard(seconds, curX, curY, 'GREEN');

  }

  double initBoard(List<NumberBoard> boards, num x, num y, String color) {
    for (int i = 0; i < boards.length; i++) {
      boards[i] = new NumberBoard(color);
      container.nodes.add(boards[i].root);
      setPosition(boards[i].root, x, y);
      x += NumberBoard.WIDTH + PADDING_SPACE;
    }

    return x;
  }

  double initColon(num x, num y) {
    ColonBoard colon = new ColonBoard();
    container.nodes.add(colon.root);
    setPosition(colon.root, x, y);
    x += ColonBoard.WIDTH + PADDING_SPACE;

    return x;
  }

  // Convert the time to the format like HH:MM:SS.
  void updateTime(DateTime now) {

    if (now.second != displayedSecond) {
      setDigits(pad2(now.second), seconds);
      displayedSecond = now.second;

      if (now.hour != displayedHour || now.hour == 0) {
        setDigits(pad2(now.hour), hours);
        displayedHour = now.hour;
      }

      if (now.minute != displayedMinute || now.minute == 0) {
        setDigits(pad2(now.minute), minutes);
        displayedMinute = now.minute;
      }
    }
  }
  // Convert the String type like '0' to the Number type like 0.
  void setDigits(String digits, List<NumberBoard> timeBoard) {
    for (int i = 0; i < digits.length; ++i) {
      int digit = digits.codeUnitAt(i) - '0'.codeUnitAt(0);
      timeBoard[i].setPixels(digit);
    }
  }

  // Add '0' before the number is a single digit.
  String pad2(int num) => (num < 10) ? '0${num}' : '${num}';

  void tick() {
    print(new DateTime.now());
    updateTime(new DateTime.now());
  }

}

