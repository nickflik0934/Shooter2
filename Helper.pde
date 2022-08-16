
Boolean Click(float clickx, float clicky, float x, float y, float w, float h) {
  return clickx > x && clickx < x+w && clicky > y && clicky < y+h;
  // THIS IS A STUPID TRIANGLE... AAAA
  //return w/2-abs((w/2+x)-clickx)+h/2-abs((h/2+y)-clicky) > 0;
}

Boolean ClickChild(float clickx, float clicky, UIFrame parent, UIFrame child) {
  float[] data = parent.calculateFrame(child);
  float x = data[0], y = data[1], w = data[2], h = data[3];
  return Click(clickx, clicky, x, y, w, h);
}


float clamp(float a, float min, float max) {
  return a < min ? min : a > max ? max : a;
}

void fill(int[] colors) {
  if (colors.length == 1) {
    fill(colors[0]);
  } else {
    fill(colors[0], colors[1], colors[2]);
  }
}

void rect(float[] data) {
  if(data.length != 4)
    return;
    
  rect(data[0], data[1], data[2], data[3]);
}



JSONObject blockDisplayOrder;
JSONObject blockData;

JSONObject load(String filename) {
  print("Loading " + filename + "... ");
  JSONObject data = loadJSONObject("data/" + filename + ".json");
  println("Finished");
  return data;
}

void loadFiles() {
  blockData = load("blockData");
}
