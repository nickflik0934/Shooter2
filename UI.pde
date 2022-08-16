
public class UIFrame {

  UIFrame parent;
  float x, y, w, h, padding, margin, spacing;
  Boolean left, bottom;
  ArrayList<UIFrame> children;
  JSONObject data;
  Boolean active = true;

  int blockCount, rowCount;

  void addBlockData(JSONArray values) {
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

  void updatePosition(float x, float y) {
    this.x = x;
    this.y = y;
  }

  float[] calculateFrame(UIFrame child) {
    float w = this.w-this.margin*2;
    float spacing = this.margin+this.spacing/2;
    float x = this.x+child.x*w+spacing;
    float y = this.y+child.y*w+spacing; // + (-1+sin(scroll/1000))*85

    return new float[]{x, y, child.w*w-this.spacing, child.h*w-this.spacing};
  }

  void renderChildren() {
    if (this.children == null)
      return;

    fill(255);
    for (UIFrame child : this.children) {
      this.renderChild(child);
    }
  }
  
  void renderText(String text) {
    textAlign(LEFT, TOP);
    fill(0);
    text(text, x+this.margin/2, y+this.margin/2, this.w-this.margin/2, this.h-margin/2);
  }

  void renderChild(UIFrame child) {
    clip(this.x, this.y, this.w, this.h);
    float[] data = this.calculateFrame(child);
    rect(data);
    noClip();
  }

  void render() {
    if (!this.active)
      return;

    if (parent != null)
      return;

    rect(this.x, this.y, this.w, this.h);

    this.renderChildren();

    //float scroll = millis();
  }

  Boolean click(float x, float y) {
    if (parent == null)
      return Click(x, y, this.x, this.y, this.w, this.h);

    return ClickChild(x, y, this.parent, this);
  }
}
