
class GameScene {

  GameScene() {
  }

  void update() {
    p.update();
  }

  void render() {
    background(0);
    p.render();
  }

  void click(float x, float y) {
  }
}

GameScene gameScene;
void setupGameScene() {
  gameScene = new GameScene();
}
