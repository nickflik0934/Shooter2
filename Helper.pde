
Boolean Click(float clickx, float clicky, float x, float y, float w, float h) {
  if (!(clickx > x && clickx < x+w))
    return false;

  if (!(clicky > y && clicky < y+h))
    return false;

  return true;
}
