part of clock;

// The NumberBoard is used for display the time number.
class NumberBoard{
  
  static const int WIDTH_BALL_NUM = 4;
  static const int HEIGHT_BALL_NUM = 7;
  static const int PADDING_SPACE = 5;
  
  static const int WIDTH = (WIDTH_BALL_NUM * Ball.RADIUS * 2) 
                        + (WIDTH_BALL_NUM - 1) * PADDING_SPACE;
  
  static const int HEIGHT = (HEIGHT_BALL_NUM * Ball.RADIUS * 2) 
                        + (HEIGHT_BALL_NUM - 1) * PADDING_SPACE;
  
  List<List<Ball>> balls;
  List<List<int>> pixels;
  
  String color;
  
  DivElement root;
  
  NumberBoard(color){
    this.color = color;
    
    root = new DivElement();
    
    balls = new List<List<Ball>>(HEIGHT_BALL_NUM);
    pixels = new List<List<int>>(HEIGHT_BALL_NUM);
    
    for(int i = 0; i < HEIGHT_BALL_NUM; i++){
      balls[i] = new List<Ball>.fixedLength(WIDTH_BALL_NUM);
      pixels[i] = new List<int>.fixedLength(WIDTH_BALL_NUM);
    }
    
    for(int y = 0; y < HEIGHT_BALL_NUM; y++){
      for(int x = 0; x < WIDTH_BALL_NUM; x++){
        balls[y][x] = new Ball();
        Ball.addAt(balls[y][x], root, 
            x * (Ball.RADIUS * 2 + PADDING_SPACE), y * (Ball.RADIUS * 2 +  PADDING_SPACE));
      }
    }
    
  }
    
    // When the time change, change the color of balls that consist the board.
    void setPixels(int num){
      for(int y = 0; y < HEIGHT_BALL_NUM; y++){
        for(int x = 0; x < WIDTH_BALL_NUM; x++){
          // When the board is empty(all the balls are grey), assign the color to the balls.
          if(pixels[y][x] == null){
            pixels[y][x] = NumbersPixel.PIXELS[num][y][x];
            if(NumbersPixel.PIXELS[num][y][x] == 1){
              balls[y][x].changeColor(this.color);
            }
          // Time changes may leads to the balls' color change. 
          // Compare with the NumbersPixel to decide if the ball needs to change color.
          }else if(pixels[y][x] != NumbersPixel.PIXELS[num][y][x]){
            pixels[y][x] = NumbersPixel.PIXELS[num][y][x];
            // Change the ball to chromatic color when it's grey.
            if(pixels[y][x] == 1){
              balls[y][x].changeColor(this.color);
            }else{
              // Change the ball to grey and create moving balls on the CollideBoard.
              CollideBoard.generateMoveBall(balls[y][x]);
              balls[y][x].changeColor('GREY');  
            }
          }  
        }
      }
    }
 
}

// The Colon between the NumberBoards.
class ColonBoard{

  static const int PADDING_SPACE = 5;
  static const int WIDTH = Ball.RADIUS * 2;
  
  DivElement root;
  
  ColonBoard(){
    root = new DivElement();
    setAbsolute(root);
    Ball ball = new Ball();
    root.nodes.add(ball.ballDiv);
    setPosition(ball.ballDiv, 0, (PADDING_SPACE + Ball.RADIUS) * 3);
    
    ball = new Ball();
    root.nodes.add(ball.ballDiv);
    setPosition(ball.ballDiv, 0, (PADDING_SPACE + Ball.RADIUS) * 5);
  }
}

// To record which balls should be colored.
// Used for compare with the NumberBoard.pixels when the time changed.
class NumbersPixel{
  static const PIXELS = const [
    const [
      const[ 1, 1, 1, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 1, 1, 1 ]
    ], const [
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ]
    ], const [
      const[ 1, 1, 1, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 1, 1, 1, 1 ],
      const[ 1, 0, 0, 0 ],
      const[ 1, 0, 0, 0 ],
      const[ 1, 1, 1, 1 ]
    ], const [
      const[ 1, 1, 1, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 1, 1, 1, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 1, 1, 1, 1 ]
    ], const [
      const[ 1, 0, 0, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 1, 1, 1 ],
      const[ 0, 0, 0, 1 ],                                     
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ]
    ], const [
      const[ 1, 1, 1, 1 ],                                                
      const[ 1, 0, 0, 0 ],
      const[ 1, 0, 0, 0 ],
      const[ 1, 1, 1, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 1, 1, 1, 1 ]
    ], const [
      const[ 1, 1, 1, 1 ],
      const[ 1, 0, 0, 0 ],
      const[ 1, 0, 0, 0 ],
      const[ 1, 1, 1, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 1, 1, 1 ]
    ], const [
      const[ 1, 1, 1, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ]
    ], const [
      const[ 1, 1, 1, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 1, 1, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 1, 1, 1 ]
    ], const [
      const[ 1, 1, 1, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 0, 0, 1 ],
      const[ 1, 1, 1, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 0, 0, 0, 1 ],
      const[ 1, 1, 1, 1 ]                                                                                        ]
    ];
}
