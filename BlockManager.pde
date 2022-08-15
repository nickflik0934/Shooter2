
int[][] BLOCK_DATA_COLOR = new int[][]{
  new int[]{255, 0, 255}, 
  new int[]{255}, 
  new int[]{175}
};

class BlockManager {

  public class Data {

    int id, index;
    float x, y;

    Data(int id, int index, float x, float y) {
      this.id = id;
      this.index = index;
      this.x = x;
      this.y = y;
    }
  }

  int w, h;
  float x, y;
  int[] blocks;

  void updatePosition(float x, float y) {
    this.x = x;
    this.y = y;
  }

  BlockManager(int w, int h, float x, float y) {
    this.w = w;
    this.h = h;
    this.x = x;
    this.y = y;

    this.blocks = new int[w*h];
    for (int i = 0; i < w*h; i++) {
      this.blocks[i] = 1;
    }
  }

  void set(int x, int y, int id) {
    if (x >= 0 && x < this.w && this.y >= 0 && this.y < this.h) {
      this.blocks[x%this.w + floor(y/this.h)] = id;
    }
  }

  int get(int x, int y) {
    if (x >= 0 && x < this.w && this.y >= 0 && this.y < this.h) {
      return this.blocks[x%this.w + floor(y/this.h)];
    }
    return -1;
  }

  void resize(int x, int y) {
    int[] newBlocks = new int[0];

    // Populate empty spaces in the blocks array
    // Also we check if the width resize is bigger than the current width...
    // That is because sizing up is a bit different than sizing down...
    if (x > this.w) {
      int[] empty = new int[x-this.w];
      for (int i = 0; i < this.h; i++) {
        for (int j = 0; j < x-this.w; j++) {
          empty[j] = floor(random(2));
        }
        newBlocks = concat(newBlocks, subset(this.blocks, i*this.w, this.w));
        newBlocks = concat(newBlocks, empty);
      }
    } else {
      for (int i = 0; i < this.h; i++) {
        newBlocks = concat(newBlocks, subset(this.blocks, i*this.w, x));
      }
    }
    this.w = x;

    // Just add empty space at the end of the array
    if (y > this.h) {
      int[] empty = new int[x*(y-this.h)];
      newBlocks = concat(newBlocks, empty);
    } else {
      newBlocks = subset(newBlocks, 0, this.w*y);
    }
    this.h = y;
    this.blocks = newBlocks;
  }

  void update() {
  }

  Data select(float x, float y) {
    int xindex = floor((x-this.x+this.w*7.5)/15);
    int yindex = floor((y-this.y+this.h*7.5)/15);

    int index = -1;
    if (!(xindex < this.w && yindex < this.h && xindex >= 0 && yindex >= 0))
      return null;

    index = xindex + yindex * this.w;
    if (index == -1 || this.blocks[index] == 0)
      return null;

    float xrender = (index%this.w)*15-this.w*7.5;
    float yrender = floor(index/this.w)*15-this.h*7.5;

    return new Data(1, 1, xrender, yrender);
  }

  void render() {
    pushMatrix();
    translate(x-this.w*7.5, y-this.h*7.5);
    rectMode(0);
    fill(255);
    for (int i = 0; i < this.blocks.length; i++) {
      float m_x = i%this.w * 15;
      float m_y = floor(i/this.w) * 15;
      if (this.blocks[i] != 0 && this.blocks[i] != -1) {
        fill(BLOCK_DATA_COLOR[this.blocks[i]]);
        rect(m_x, m_y, 15, 15);
      }
    }
    popMatrix();
  }

  // Do something or something
  void action() {
  }
}
