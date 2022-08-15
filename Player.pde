

class Player {
  
  BlockManager bm;
  float x, y;
  
  public float getX() {
    return this.x;
  }
  
  public void setX(float x) {
    this.bm.x = x;
  }
  
  Player(float x, float y) {
    this.x = x;
    this.y = y;
    this.bm = new BlockManager(5, 5, x, y);
  }
  
  void update() {
    this.y+=pressed('w')?-1:pressed('s')?1:0;
    this.x+=pressed('a')?-1:pressed('d')?1:0;
    this.bm.updatePosition(this.x, this.y);
  }
  
  void render() {
    this.bm.render();
  }
  
}

Player p;

void setupPlayer() {
  p = new Player(width/2, height/2); 
}
