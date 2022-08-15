
void setup() {
  size(600, 600, P2D);
  debug = true;
  
  setupKeys();
  setupFlags();
  setupPlayer();
  setupDebug();
  setupGameScene();
  setupBuildScene();
}

void draw() {
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
  if(debug) {
    debug();
  }
}

void mousePressed() {
  buildScene.click(mouseX, mouseY);
  gameScene.click(mouseX, mouseY);
  if(mouseButton == CENTER) {
    
  }
}
