import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Shooter_2_0 extends PApplet {



public void setup() {
  
  frameRate(60);
  debug = true;
  
  loadFiles();

  setupKeys();
  setupFlags();
  setupPlayer();
  setupDebug();
  setupGameScene();
  setupBuildScene();
}

public void draw() {
  switch(flags.get("gamestate")) {
  case "game": // User is in game.
    gameScene.update();
    gameScene.render();
    break;
  case "build": // User is building their ship.
    buildScene.update();
    buildScene.render();
    break;
  case "menu": // User is building their ship.
    break;
  }
  if (debug) {
    debug();
  }
}

public void mousePressed() {
  buildScene.click(mouseX, mouseY);
  gameScene.click(mouseX, mouseY);
  if (mouseButton == CENTER) {
  }
}

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

  public void updatePosition(float x, float y) {
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

  public void set(int x, int y, int id) {
    if (x >= 0 && x < this.w && this.y >= 0 && this.y < this.h) {
      this.blocks[x%this.w + floor(y/this.h)] = id;
    }
  }

  public int get(int x, int y) {
    if (x >= 0 && x < this.w && this.y >= 0 && this.y < this.h) {
      return this.blocks[x%this.w + floor(y/this.h)];
    }
    return -1;
  }

  public void resize(int x, int y) {
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

  public void update() {
  }

  public Data select(float x, float y) {
    int xindex = floor((x-this.x+this.w*7.5f)/15);
    int yindex = floor((y-this.y+this.h*7.5f)/15);

    int index = -1;
    if (!(xindex < this.w && yindex < this.h && xindex >= 0 && yindex >= 0))
      return null;

    index = xindex + yindex * this.w;
    if (index == -1 || this.blocks[index] == 0)
      return null;

    float xrender = (index%this.w)*15-this.w*7.5f;
    float yrender = floor(index/this.w)*15-this.h*7.5f;

    return new Data(1, 1, xrender, yrender);
  }

  public void render() {
    pushMatrix();
    translate(x-this.w*7.5f, y-this.h*7.5f);
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
  public void action() {
  }
}

class BuildScene {

  BuildScene() {
    this.setupBuildMenu();
  }

  UIFrame buildMenu;

  UIFrame buildMenuTooltip;

  public void setupBuildMenu() {
    this.buildMenu = new UIFrame(120, 200, 10, 5, 5, false, true);
    this.buildMenuTooltip = new UIFrame(250, 300, 10, 5, 5);

    JSONArray values = blockData.getJSONArray("blocks");
    this.buildMenu.addBlockData(values);
  }

  public void update() {
    p.bm.update();
  }

  public void hover() {
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

  // Outlines the item that the user is hovering over.
  public UIFrame renderHoverBuildMenu() {
    if (!this.buildMenu.click(mouseX, mouseY))
      return null;

    UIFrame out = null;
    stroke(255, 0, 0);
    strokeWeight(2);
    for (UIFrame child : this.buildMenu.children) {
      if (!child.click(mouseX, mouseY))
        continue;

      this.buildMenu.renderChild(child);
      out = child;
      break;
    }
    stroke(0);
    strokeWeight(1);
    return out;
  }

  public void renderItemData(UIFrame item) {
    if (item == null)
      return;

    JSONObject data = item.data;
    if (data == null)
      return;

    float x = mouseX-this.buildMenu.padding-this.buildMenuTooltip.w;
    float y = mouseY;

    fill(255);
    this.buildMenuTooltip.updatePosition(x, y);
    this.buildMenuTooltip.render();

    String[] order = blockData.getJSONArray("displayOrder").getStringArray();
    JSONObject display = blockData.getJSONObject("display");
    
    TextPiece[] textPieces = new TextPiece[0];
    for (int i = 0; i < order.length; i++) {
      Object piece = data.get(order[i]);
      if (piece == null)
        continue;

      JSONObject field = display.getJSONObject(order[i]);
      if (field == null)
        continue;

      String value = piece.toString();
      String label = field.getJSONObject("label").getString("en");

      TextPiece textPiece = new TextPiece(label, value);
      textPieces = (TextPiece[])append(textPieces, textPiece);
    }
    
    TextArea textArea = new TextArea(this.buildMenuTooltip, textPieces);
    textArea.render();
  }

  public void render() {
    background(0);
    p.bm.updatePosition(width/2, height/2);
    p.render();

    // UI For building stuff



    this.hover();

    this.buildMenu.render();

    UIFrame item = this.renderHoverBuildMenu();
    this.renderItemData(item);
  }
  public void click(float x, float y) {
    if (!this.buildMenu.click(x, y))
      return;

    ArrayList<UIFrame> children = this.buildMenu.children;
    for (UIFrame child : children) {
      if (!child.click(x, y)) {
      }
    }
  }
}

BuildScene buildScene;
public void setupBuildScene() {
  buildScene = new BuildScene();
}

Boolean debug;

StringDict DEBUG_TEXT_MAPPING;
public void setupDebug() {
  DEBUG_TEXT_MAPPING = new StringDict();
  String[][] keyMap = new String[][]{
    new String[]{"w", "W"}, 
    new String[]{"a", "A"}, 
    new String[]{"s", "S"}, 
    new String[]{"d", "D"}, 
    new String[]{str(ESC), "^"}
  };

  for (int i = 0; i < keyMap.length; i++) {
    DEBUG_TEXT_MAPPING.set(keyMap[i][0], keyMap[i][1]);
  }
}

// y axis spacing of text.
int DEBUG_TEXT_LEVEL_LEFT;
int DEBUG_TEXT_LEVEL_RIGHT;
public void debugText(String title, String text, Boolean left) {
  textAlign(left ? LEFT : RIGHT, TOP);

  float x = left ? textWidth(title) : width;
  float y = left ? 12 * DEBUG_TEXT_LEVEL_LEFT : 12 * DEBUG_TEXT_LEVEL_RIGHT;

  text(text, x, y);
  if (left) {
    DEBUG_TEXT_LEVEL_LEFT++;
    text(title, 0, y);
  } else {
    DEBUG_TEXT_LEVEL_RIGHT++;
    text(title, width-textWidth(text), y);
  }
}

public void textBorder(String text, float x, float y, int[] fillA, int[] fillB) {
  fill(fillA);
  textSize(15);
  for (int i = -1; i < 2; i++) {
    for (int j = -1; j < 2; j++) {
      text(text, x+i, y+j);
      text(text, x+i+j, y);
      text(text, x, y+j+i);
    }
  }
  fill(fillB);
  text(text, x, y);
}

public void debug() {
  fill(255);
  textSize(12);
  DEBUG_TEXT_LEVEL_LEFT = 0;
  DEBUG_TEXT_LEVEL_RIGHT = 0;

  debugFps();
  debugKeysK();
  debugKeysV();
  debugCoord();
}

// Show fps
public void debugFps() {
  String text = nf(frameRate, 0, 1);
  String title = "Fps: ";

  debugText(title, text, true);
}

// Show keys pressed.
public void debugKeysK() {
  String[] array = keys.keyArray();
  String text = "";
  String title = "K: ";
  for (int i = 0; i < array.length; i++) {
    text = text + DEBUG_TEXT_MAPPING.get(array[i]);
  }
  debugText(title, text, false);
}

// Show value of keys pressed.
public void debugKeysV() {
  String[] array = keys.keyArray();
  String text = "";
  String title = "V: ";
  for (int i = 0; i < array.length; i++) {
    text = text + nf(keys.get(array[i]), 0, 0);
  }
  debugText(title, text, false);
}

// Show coordinates of player.
public void debugCoord() {
  String text = "x: " + nf(p.x, 0, 1) + " " + "y: " + nf(p.y, 0, 1);
  String title = "Coord: ";
  debugText(title, text, true);
}

String[] configurationFlags;
StringDict flags;
public void setupFlags() {
  flags = new StringDict();
  flags.set("gamestate", "build");
}

class GameScene {

  GameScene() {
  }

  public void update() {
    p.update();
  }

  public void render() {
    background(0);
    p.render();
  }

  public void click(float x, float y) {
  }
}

GameScene gameScene;
public void setupGameScene() {
  gameScene = new GameScene();
}

public Boolean Click(float clickx, float clicky, float x, float y, float w, float h) {
  return clickx > x && clickx < x+w && clicky > y && clicky < y+h;
  // THIS IS A STUPID TRIANGLE... AAAA
  //return w/2-abs((w/2+x)-clickx)+h/2-abs((h/2+y)-clicky) > 0;
}

public Boolean ClickChild(float clickx, float clicky, UIFrame parent, UIFrame child) {
  float[] data = parent.calculateFrame(child);
  float x = data[0], y = data[1], w = data[2], h = data[3];
  return Click(clickx, clicky, x, y, w, h);
}


public float clamp(float a, float min, float max) {
  return a < min ? min : a > max ? max : a;
}

public void fill(int[] colors) {
  if (colors.length == 1) {
    fill(colors[0]);
  } else {
    fill(colors[0], colors[1], colors[2]);
  }
}

public void rect(float[] data) {
  if(data.length != 4)
    return;
    
  rect(data[0], data[1], data[2], data[3]);
}

float textSize = 12;
public void setTextSize(float newTextSize) {
  textSize = newTextSize;
}



JSONObject blockDisplayOrder;
JSONObject blockData;

public JSONObject load(String filename) {
  print("Loading " + filename + "... ");
  JSONObject data = loadJSONObject("data/" + filename + ".json");
  println("Finished");
  return data;
}

public void loadFiles() {
  blockData = load("blockData");
}

char[] configurationKeys;
IntDict keys;
public void setupKeys() {
  keys = new IntDict();
  configurationKeys = new char[]{
    'w', 
    'a', 
    's', 
    'd', 
    ESC
  };

  for (int i = 0; i < configurationKeys.length; i++) {
    keys.set(str(configurationKeys[i]), 0);
  }
}

public Boolean pressed(char k) {
  if (keys.hasKey(str(k)))
    return keys.get(str(k)) == 1;
  return false;
}

public void setKey(String k, int set) {
  for (int i = 0; i < keys.size(); i++) {
    if (keys.hasKey(k)) {
      keys.set(k, set);
    }
  }
}

boolean escapeDebounce;
public void keyPressed() {
  // Handle input
  setKey(str(key), 1);

  // Customization
  if (keyCode == 27) {
    key = 0;

    if (flags.get("gamestate") == "game") {
      flags.set("gamestate", "build");
    } else {
      flags.set("gamestate", "game");
    }

    if (escapeDebounce) {
      escapeDebounce = false;
    }
  } else {
    escapeDebounce = true;
  }
}


public void keyReleased() {
  setKey(str(key), 0);
}


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

  public void update() {
    this.y+=pressed('w')?-1:pressed('s')?1:0;
    this.x+=pressed('a')?-1:pressed('d')?1:0;
    this.bm.updatePosition(this.x, this.y);
  }

  public void render() {
    this.bm.render();
  }
}

Player p;

public void setupPlayer() {
  p = new Player(width/2, height/2);
}

class TextPiece {
  
  String label, value;
  String[] lines;
  String calculatedValue;
  float labelWidth, valueWidth;
  
  TextPiece(String label, String value) {
    this.label = label;
    this.value = value;
    this.lines = new String[0];
  }
  
  public void addLine(String line) {
    this.lines = append(this.lines, line);
    if(textWidth(line) > this.valueWidth)
      this.valueWidth = textWidth(line);
  }
  
  public void calculateLabel() {
    this.labelWidth = textWidth(this.label + ": ");
  }
  
  public void calculateValue(float w) {
    String line = "";

    for (String word : split(this.value, ' ')) {
      if (textWidth(line + word) > w) {
        addLine(line);
        line = "";
      }
      line += word + " ";
    }
    addLine(line);
    
    calculatedValue = join(this.lines, '\n');
  }
  
  public float render(float x, float y, float labelWidth) {
    text(this.label + ":", x, y);
    int index = 0;
    for (String line : this.lines) {
      text(line, x+labelWidth, y+index*textSize);
      index++;
    }
    return this.lines.length*textSize;
  }
}

class TextArea {
  
  UIFrame parent;
  TextPiece[] textPieces;
  float labelWidth, valueWidth;

  TextArea(UIFrame parent, TextPiece[] textPieces) {
    this.parent = parent;
    this.textPieces = textPieces;
    
    this.calculateLabel();
    this.calculateValue();
  }
  
  public void calculateLabel() {
    for (TextPiece piece : this.textPieces) {
      piece.calculateLabel();
      
      if (piece.labelWidth > this.labelWidth)
        this.labelWidth = piece.labelWidth;
    }
  }
  
  public void calculateValue() {
    for (TextPiece piece : this.textPieces) {
      piece.calculateValue(this.parent.w-this.parent.margin*2-this.labelWidth);
      
      if (piece.valueWidth > this.valueWidth)
        this.valueWidth = piece.valueWidth;
    }
  }

  public void render() {
    int textSize = 12;
    
    float xoffset = 0;
    float yoffset = 0;
    
    float x = this.parent.x+this.parent.margin;
    float y = this.parent.y+this.parent.margin;
    
    textAlign(LEFT, TOP);
    fill(0);
    for (TextPiece textPiece : this.textPieces) {
      float addOffset = textPiece.render(x, y+yoffset, this.labelWidth);
      yoffset = yoffset + addOffset;
    }
  }
}

public class UIFrame {

  UIFrame parent;
  float x, y, w, h, padding, margin, spacing;
  Boolean left, bottom;
  ArrayList<UIFrame> children;
  JSONObject data;
  Boolean active = true;

  int blockCount, rowCount;

  public void addBlockData(JSONArray values) {
    ArrayList<UIFrame>children = new ArrayList<UIFrame>();

    int rowCount = 3;
    float spacing = 100/rowCount;
    for (int i = 0; i < values.size(); i++) {
      JSONObject data = values.getJSONObject(i);
      float offsetX = 100/rowCount*(i%rowCount);
      float offsetY = 100/rowCount*floor(i/rowCount);

      UIFrame child = new UIFrame(this, offsetX, offsetY, spacing, spacing);
      child.data = data;

      children.add(child);
    }
    this.children = children;
  }

  UIFrame(float w, float h, float padding, float margin, float spacing, Boolean left, Boolean top) {
    this.parent = null;
    this.w = w;
    this.h = h;
    this.padding = padding;
    this.margin = margin;
    this.spacing = spacing;
    this.x = left ? this.w+this.padding : width-this.w-this.padding;
    this.y = top ? this.h+this.padding : height-this.h-this.padding;
  }

  UIFrame(float w, float h, float padding, float margin, Boolean left, Boolean top) {
    this.parent = null;
    this.w = w;
    this.h = h;
    this.padding = padding;
    this.margin = margin;
    this.x = left ? this.w+this.padding : width-this.w-this.padding;
    this.y = top ? this.h+this.padding : height-this.h-this.padding;

    this.spacing = 0;
  }

  UIFrame(float w, float h, float padding, float margin, float spacing) {
    this.parent = null;
    this.w = w;
    this.h = h;
    this.padding = padding;
    this.margin = margin;
    this.spacing = spacing;
    this.x = 0;
    this.y = 0;
  }

  UIFrame(UIFrame parent, float x, float y, float w, float h) {
    this.parent = parent;
    this.x = x/100;
    this.y = y/100;
    this.w = w/100;
    this.h = h/100;
  }

  public void updatePosition(float x, float y) {
    this.x = x;
    this.y = y;
  }

  public float[] calculateFrame(UIFrame child) {
    float w = this.w-this.margin*2;
    float spacing = this.margin+this.spacing/2;
    float x = this.x+child.x*w+spacing;
    float y = this.y+child.y*w+spacing; // + (-1+sin(scroll/1000))*85

    return new float[]{x, y, child.w*w-this.spacing, child.h*w-this.spacing};
  }

  public void renderChildren() {
    if (this.children == null)
      return;

    fill(255);
    for (UIFrame child : this.children) {
      this.renderChild(child);
    }
  }
  
  public void renderText(String text) {
    textAlign(LEFT, TOP);
    fill(0);
    text(text, x+this.margin/2, y+this.margin/2, this.w-this.margin/2, this.h-margin/2);
  }

  public void renderChild(UIFrame child) {
    clip(this.x, this.y, this.w, this.h);
    float[] data = this.calculateFrame(child);
    rect(data);
    noClip();
  }

  public void render() {
    if (!this.active)
      return;

    if (parent != null)
      return;

    rect(this.x, this.y, this.w, this.h);

    this.renderChildren();

    //float scroll = millis();
  }

  public Boolean click(float x, float y) {
    if (parent == null)
      return Click(x, y, this.x, this.y, this.w, this.h);

    return ClickChild(x, y, this.parent, this);
  }
}
  public void settings() {  size(600, 600, P2D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Shooter_2_0" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
