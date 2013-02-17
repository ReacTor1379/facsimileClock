part of clock;

// The scene for MoveBalls runs!
class CollideBoard{
  
  static List<MoveBall> collideBalls = new List<MoveBall>();
  static DivElement root = query('#collideArea');
  
  static void generateMoveBall(Ball ball){
    MoveBall moveBall = new MoveBall(ball.color);
    var pos = ball.ballDiv.getBoundingClientRect();
    MoveBall.addAt(moveBall, root, pos.left, pos.top);
    setAbsolute(moveBall.ballDiv);
    collideBalls.add(moveBall);
  }
  
  CollideBoard(){
    setPosition(root, 0, 0);
    
    // Every frame checks every MoveBalls' status.
    // If it's out of bounds, remove it.Or if it hits another ball, do the collide animation.
    window.requestAnimationFrame(collide);
  }
  
    void remove(int i){
      root.nodes.remove(collideBalls[i].ballDiv);
      collideBalls.removeAt(i);
    }
      
      void collide(num time){
        for(int i = 0; i < collideBalls.length; i++){
            collideBalls[i].move(time);
        }
        window.requestAnimationFrame(collide);
      }
}

