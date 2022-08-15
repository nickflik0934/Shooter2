
Boolean debug;

StringDict DEBUG_TEXT_MAPPING;
void setupDebug() {
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
void debugText(String title, String text, Boolean left) {
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

void fill(int[] colors) {
  if (colors.length == 1) {
    fill(colors[0]);
  } else {
    fill(colors[0], colors[1], colors[2]);
  }
}

void textBorder(String text, float x, float y, int[] fillA, int[] fillB) {
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

void debug() {
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
void debugFps() {
  String text = nf(frameRate, 0, 1);
  String title = "Fps: ";

  debugText(title, text, true);
}

// Show keys pressed.
void debugKeysK() {
  String[] array = keys.keyArray();
  String text = "";
  String title = "K: ";
  for (int i = 0; i < array.length; i++) {
    text = text + DEBUG_TEXT_MAPPING.get(array[i]);
  }
  debugText(title, text, false);
}

// Show value of keys pressed.
void debugKeysV() {
  String[] array = keys.keyArray();
  String text = "";
  String title = "V: ";
  for (int i = 0; i < array.length; i++) {
    text = text + nf(keys.get(array[i]), 0, 0);
  }
  debugText(title, text, false);
}

// Show coordinates of player.
void debugCoord() {
  String text = "x: " + nf(p.x, 0, 1) + " " + "y: " + nf(p.y, 0, 1);
  String title = "Coord: ";
  debugText(title, text, true);
}
