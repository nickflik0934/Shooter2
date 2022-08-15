
class BuildScene {
  
  BuildScene() {
    
  }
  
  void update() {
    p.bm.update();
  }
  
  void hover() {
    BlockManager.Data data = p.bm.select(mouseX, mouseY);
    
    if(data == null) {
      return;
    }
    
    float x = data.x;
    float y = data.y;
    
    pushMatrix();
    translate(p.bm.x, p.bm.y);
    noFill();
    stroke(255,0,0);
    strokeWeight(2);
    rectMode(0);
    rect(x, y, 15, 15);
    popMatrix();
    
    textAlign(CENTER, CENTER);
    String text = "id: " + data.id;
    textBorder(text, mouseX+5+textWidth(text), mouseY-8, new int[]{0}, new int[]{255,255,255});
    
    fill(255);
    stroke(0);
    strokeWeight(1);
  }
  
  void render() {
    background(0);
    p.bm.updatePosition(width/2, height/2);
    p.render();
    
    // UI For building stuff
    float w = 120, h = 200, padding = 10, margin = 5;
    float x = width-w-padding, y = height-h-padding;
    int blockCount = 18, rowCount = 3;
    rect(x,y,w,h);
    
    JSONObject[] blocks = new JSONObject[blockCount];
    for(int i = 0; i < blockCount; i++) {
      JSONObject block = new JSONObject();
      block.setInt("id", 1);
      
      blocks[i] = block;
    }
    
    clip(x, y, w, h);
    for(int i = 0; i < blockCount; i++) {
      JSONObject block = blocks[i];
      int index = i%rowCount;
      float offsetX = margin/(rowCount+3)*(index+2);
      float offsetY = margin/(rowCount+3)*(index+2);
      rect(x+index*w/rowCount+offsetX, y+floor(i/rowCount)*w/rowCount + offsetY, w/rowCount-margin, w/rowCount-margin);
    }
    noClip();
    
    
    this.hover();
    
    
    
    // Check if stuff is in center 
    //rect(0,0,250,600);
    //rect(350,0,250,600);
  }
  
  void click(int x, int y) {
    
  }
  
}

BuildScene buildScene;
void setupBuildScene() {
  buildScene = new BuildScene();
}
