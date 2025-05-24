class Tile {
  private int x, y;
  
  public Tile(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  public int getX() {
    return x;
  }
  
  public int getY() {
    return y;
  }
  
  // rotates tile 90 deg CW about given center
  public void rotate(double centerx, double centery) {
    double dx = x - centerx, dy = y - centery;
    x = (int) (centerx - dy);
    y = (int) (centery + dx);
  }
  
  // shifts tile by dx in x dir and dy in y dir by dist cells
  public void shift(int dx, int dy, int dist) {
    x += dx * dist;
    y += dy * dist;
  }
  
  // display tile on board by
  // converting x and y to pixel coordinates and
  // drawing rectangle with specified colorID
  public void display(int colorID) {
    fill(rgb[colorID][0], rgb[colorID][1], rgb[colorID][2]);
    rect(CoordConv.convCoord(x), CoordConv.convCoord(y), 38, 38, 3);
  }
  
  // display mini tile on sidebar after shifting coordinates
  // by converting x and y to pixel coordinates and
  // drawing rectangle with specified colorID
  public void sideDisplay(int colorID, int dx, int dy) {
    fill(rgb[colorID][0], rgb[colorID][1], rgb[colorID][2]);
    rect(CoordConv.convCoordMini(x) + dx, CoordConv.convCoordMini(y) + dy, 28, 28, 3);
  }
}

static class CoordConv {
  // static method to convert x/y index of tile to pixel coordinates
  public static int convCoord(int idx) {
    return 20 + 40 * idx;
  }
  
  // static method to convert x/y index of tile to pixel coordinates
  public static int convCoordMini(int idx) {
    return 20 + 30 * idx;
  }
}
