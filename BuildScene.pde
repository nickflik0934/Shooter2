
class BuildScene {

  UIFrame buildMenu;

  BuildScene() {
    this.buildMenu = new UIFrame(120, 200, 10, 10, false, true);

    ArrayList<UIFrame>children = new ArrayList<UIFrame>();

    int blockCount = 18;
    int rowCount = 3;

    float spacing = 100/rowCount;
    for (int i = 0; i < blockCount; i++) {
      float offsetX = 100/rowCount*(i%rowCount);
      float offsetY = 100/rowCount*floor(i/rowCount);

      UIFrame child = new UIFrame(this.buildMenu, offsetX, offsetY, spacing, spacing);

      children.add(child);
    }

    this.buildMenu.children = children;
  }

  void update() {
    p.bm.update();
  }

  void hover() {
    BlockManager.Data data = p.bm.select(mouseX, mouseY);

    if (data == null) {
      return;
    }

    float x = data.x;
    float y = data.y;

    pushMatrix();
    translate(p.bm.x, p.bm.y);
    noFill();
    stroke(255, 0, 0);
    strokeWeight(2);
    rectMode(0);
    rect(x, y, 15, 15);
    popMatrix();

    textAlign(CENTER, CENTER);
    String text = "id: " + data.id;
    textBorder(text, mouseX+5+textWidth(text), mouseY-8, new int[]{0}, new int[]{255, 255, 255});

    fill(255);
    stroke(0);
    strokeWeight(1);
  }

  public class UIFrame {

    UIFrame parent;
    float x, y, w, h, padding, margin;
    Boolean left, bottom;
    ArrayList<UIFrame> children;

    int blockCount, rowCount;

    UIFrame(UIFrame parent, float x, float y, float w, float h) {
      this.parent = parent;
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
    }

    UIFrame(float w, float h, float padding, float margin, Boolean left, Boolean top) {
      this.w = w;
      this.h = h;
      this.padding = padding;
      this.margin = margin;
      this.x = left ? this.w+this.padding : width-this.w-this.padding;
      this.y = top ? this.h+this.padding : height-this.h-this.padding;
    }

    void render() {
      if(parent != null)
        return;
      
      rect(this.x, this.y, this.w, this.h);
      
      clip(x, y, w, h);
      float scroll = millis();
      for (UIFrame child : this.children) {
        rect(this.x+child.x*this.w, y+child.y*this.w + (-1+sin(scroll/1000))*85, child.w*this.w, child.h*this.w);
      }
      noClip();
    }

    Boolean click(float x, float y) {
      return Click(x, y, this.x, this.y, this.w, this.h);
    }
  }

  void render() {
    background(0);
    p.bm.updatePosition(width/2, height/2);
    p.render();

    // UI For building stuff



    this.hover();

    this.buildMenu.render();

    // Check if stuff is in center 
    //rect(0,0,250,600);
    //rect(350,0,250,600);
  }

  void click(float x, float y) {
  }
}

BuildScene buildScene;
void setupBuildScene() {
  buildScene = new BuildScene();
}
