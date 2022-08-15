
char[] configurationKeys;
IntDict keys;
void setupKeys() {
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

Boolean pressed(char k) {
  if (keys.hasKey(str(k)))
    return keys.get(str(k)) == 1;
  return false;
}

void setKey(String k, int set) {
  for (int i = 0; i < keys.size(); i++) {
    if (keys.hasKey(k)) {
      keys.set(k, set);
    }
  }
}

boolean escapeDebounce;
void keyPressed() {
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


void keyReleased() {
  setKey(str(key), 0);
}
