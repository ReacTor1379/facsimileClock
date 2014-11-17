part of clock;

int get clientWidth => window.innerWidth;

int get clientHeight => window.innerHeight;

// Fixed ball that won't be move, used to display the time numbers.
class Ball {
  static const RADIUS = 8;

  static final Map<String, String> BALL_COLOR = {
    "GREY": "#c9c9c9",
    "BLUE": "#13acfa",
    "RED": "#c0000b",
    "GREEN": "#009a49",
    "BLACK": "#000000"
  };

  static addAt(Ball ball, Element ele, num coordX, num coordY) {
    ele.nodes.add(ball.ballDiv);
    setAbsolute(ball.ballDiv);
    setPosition(ball.ballDiv, coordX, coordY);
  }

  DivElement ballDiv;
  String color;

  // If no argument of the color, it will create a grey one.
  Ball([String color = "GREY"]) {
    if (BALL_COLOR.containsKey(color)) {
      createBall(BALL_COLOR[color]);
    } else {
      createBall(BALL_COLOR['GREY']);
    }
    this.color = color;
  }

  void createBall(String color) {
    DivElement ballDiv = new DivElement();

    ballDiv
        ..style.backgroundColor = color
        ..style.width = '${RADIUS*2}px'
        ..style.height = '${RADIUS*2}px'
        ..style.borderRadius = '${RADIUS}px';

    this.ballDiv = ballDiv;
  }

  // When the time changed, change the balls color to display the new time.
  void changeColor(String color) {
    if (BALL_COLOR.containsKey(color)) {
      this.ballDiv.style.backgroundColor = BALL_COLOR[color];
    } else {
      this.ballDiv.style.backgroundColor = BALL_COLOR['GREY'];
    }

    this.color = color;
  }
}

// The ball can move&collide!
// Create when time changed and the ball on the background turns to grey.

class MoveBall extends Ball {

  static final Map<String, String> BALL_COLOR = {
    "GREY": "#c9c9c9",
    "BLUE": "#13acfa",
    "RED": "#c0000b",
    "GREEN": "#009a49",
    "BLACK": "#000000"
  };

  static const double GRAVITY = 400.0;
  static const double RESTITUTION = 0.8;
  static const double MIN_VELOCITY = 100.0;
  static const double INIT_VELOCITY = 800.0;

  static Random random;

  static double randomVelocity() {
    if (random == null) {
      random = new Random();
    }

    return (random.nextDouble() - 0.5) * INIT_VELOCITY;
  }

  static addAt(Ball ball, Element ele, num coordX, num coordY) {
    ele.nodes.add(ball.ballDiv);
    setAbsolute(ball.ballDiv);
    setPosition(ball.ballDiv, coordX, coordY);
  }

  double x, y;
  double vx, vy;
  double ax, ay;
  num lastTime;
  double delta;

  //MoveBall([String color]) : super(color);
  MoveBall(String color) {

    createBall(BALL_COLOR[color]);

    this.color = color;

    lastTime = new DateTime.now().millisecondsSinceEpoch;

    ax = 0.0;
    ay = GRAVITY;

    vx = randomVelocity();
    vy = randomVelocity();
  }

  // The moving ball change it's velocity and test if it's hitted every frame.
  // The algorithm copies from the original dart Clock code.
  void move(num time) {
    double nowTime = time;

    delta = max(1000 / (nowTime - lastTime), 30.0);

    lastTime = nowTime;

    if (x == null) {
      x = this.ballDiv.getBoundingClientRect().left;
      y = this.ballDiv.getBoundingClientRect().top;
    } else {
      isCollide();
    }

    x += this.vx / delta;
    y += this.vy / delta;

    vy += ay / delta;

    // When the ball out of the display area, remove it.
    if (x <= -Ball.RADIUS * 2 || x >= clientWidth + Ball.RADIUS * 2) {
      remove();
    }

    // When the ball hit the 'ground' of the display area, it bounds.
    if (y > clientHeight - Ball.RADIUS * 2) {
      y = clientHeight.toDouble() - Ball.RADIUS * 2;
      vy *= -RESTITUTION;
    }

    setPosition(this.ballDiv, this.x, this.y);
  }

  void isCollide() {
    CollideBoard.collideBalls.forEach((otherBall) {
      if (otherBall != this && (otherBall.x != null)) {
        double dx = (this.x - otherBall.x).abs();
        double dy = (this.y - otherBall.y).abs();
        double dis = sqrt(dx * dx + dy * dy);

        if (dis < Ball.RADIUS * 2) {
          // If the two balls are approaching, do the bump action.
          if (isApproaching(otherBall, dis)) {

            if (dis == 0) {
              // TODO: move balls apart.

              return;
            }

            dx /= dis;
            dy /= dis;

            // Calculate the impact velocity and speed along the collision vector.
            double impactx = this.vx - otherBall.vx;
            double impacty = this.vy - otherBall.vy;
            double impactSpeed = impactx * dx + impacty * dy;

            // Bump.
            this.vx -= dx * impactSpeed;
            this.vy -= dy * impactSpeed;
            otherBall.vx += dx * impactSpeed;
            otherBall.vy += dy * impactSpeed;
          }
        }
      }
    });
  }

  bool isApproaching(MoveBall otherBall, double dis) {
    double newOx = otherBall.x + otherBall.vx * 1 / delta;
    double newOy = otherBall.y + otherBall.vy * 1 / delta;
    double newTx = this.x + this.vx * 1 / delta;
    double newTy = this.y + this.vy * 1 / delta;

    double nx = (newTx - newOx).abs();
    double ny = (newTy - newOy).abs();
    double newDis = sqrt(nx * nx + ny * ny);
    if (newDis < dis) {
      return true;
    }

    // If the two balls are aparting, do nothing.
    return false;
  }

  void remove() {
    CollideBoard.collideBalls.remove(this);
    this.ballDiv.parent.nodes.remove(this.ballDiv);
  }
}
