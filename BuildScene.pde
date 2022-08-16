
class BuildScene {

  BuildScene() {
    this.setupBuildMenu();
  }

  UIFrame buildMenu;

  UIFrame buildMenuTooltip;

  void setupBuildMenu() {
    this.buildMenu = new UIFrame(120, 200, 10, 5, 5, false, true);
    this.buildMenuTooltip = new UIFrame(250, 300, 10, 5, 5);

    JSONArray values = blockData.getJSONArray("blocks");
    this.buildMenu.addBlockData(values);
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

  // Outlines the item that the user is hovering over.
  UIFrame renderHoverBuildMenu() {
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

  void renderItemData(UIFrame item) {
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

  void render() {
    background(0);
    p.bm.updatePosition(width/2, height/2);
    p.render();

    // UI For building stuff



    this.hover();

    this.buildMenu.render();

    UIFrame item = this.renderHoverBuildMenu();
    this.renderItemData(item);
  }
  void click(float x, float y) {
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
void setupBuildScene() {
  buildScene = new BuildScene();
}
