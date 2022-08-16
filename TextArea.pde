
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
  
  void addLine(String line) {
    this.lines = append(this.lines, line);
    if(textWidth(line) > this.valueWidth)
      this.valueWidth = textWidth(line);
  }
  
  void calculateLabel() {
    this.labelWidth = textWidth(this.label + ": ");
  }
  
  void calculateValue(float w) {
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
  
  float render(float x, float y, float labelWidth) {
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
  
  void calculateLabel() {
    for (TextPiece piece : this.textPieces) {
      piece.calculateLabel();
      
      if (piece.labelWidth > this.labelWidth)
        this.labelWidth = piece.labelWidth;
    }
  }
  
  void calculateValue() {
    for (TextPiece piece : this.textPieces) {
      piece.calculateValue(this.parent.w-this.parent.margin*2-this.labelWidth);
      
      if (piece.valueWidth > this.valueWidth)
        this.valueWidth = piece.valueWidth;
    }
  }

  void render() {
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
