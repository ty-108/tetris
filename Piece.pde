class Piece {
  private double centerx, centery; // int or ends in .5
  private int colorID; // id of color corresponding to rgb
  private ArrayList<Tile> tiles; // stores all tiles of the piece
  
  public Piece(double cx, double cy, int cID) {
    centerx = cx;
    centery = cy;
    colorID = cID;
    tiles = new ArrayList<>();
  }
  
  public int getColorID() {
    return colorID;
  }
  
  public ArrayList<Tile> getTiles() {
    return tiles;
  }
  
  // add tile to piece given its position relative to center
  public void addTile(double dx, double dy) {
    Tile cur = new Tile((int) (centerx + dx), (int) (centery + dy));
    tiles.add(cur);
  }
  
  // checks if position of tiles is outside playing grid or overlapping with other tiles
  public boolean isValid() {
    for(Tile i : tiles) {
      if(i.getX() < 0 || i.getX() >= 10 || i.getY() < 0 || i.getY() >= 20) return false;
      if(curGame.occupied(i.getX(), i.getY())) return false;
    }
    return true;
  }
  
  // shifts entire piece up, down, left, or right dist cells
  public void tempShift(int dir, int dist) {
    centerx += dx[dir] * dist;
    centery += dy[dir] * dist;
    for(Tile i : tiles) {
      i.shift(dx[dir], dy[dir], dist);
    }
  }
  
  // only if possible, shifts entire piece up, down, left, or right dist cells
  public void shift(int dir, int dist) {
    // tempShift in given dir
    tempShift(dir, dist);
    
    // check if valid
    if(isValid()) return;
    
    // if tile not valid, tempShift back
    dir = (dir + 2) % 4; // opposite dir
    tempShift(dir, dist);
  }
  
  // rotates entire piece 90 deg CW if it can.
  // will "wall kick" the piece if needed,
  // meaning if the piece can't be rotated as it'd
  // overlap with another piece or the grid walls,
  // the piece can get pushed left or right to help the rotation.
  public void rotate() {
    // rotate each tile individually
    for(Tile i : tiles) {
      i.rotate(centerx, centery);
    }
    
    // check if rotation is valid
    if(isValid()) return;
    
    // try wall kick to left
    // IPiece may need to shift 2 cells to wall kick
    shift(3, 1);
    if(isValid()) return;
    if(this instanceof IPiece) {
      shift(3, 2);
      if(isValid()) return;
    }
    
    // try wall kick to right
    // IPiece may need to shift 2 cells to wall kick
    shift(1, 1);
    if(isValid()) return;
    if(this instanceof IPiece) {
      shift(1, 2);
      if(isValid()) return;
    }
    
    // nothing works, revert rotation
    for(int j = 0; j < 3; j++) {
      for(Tile i : tiles) {
        i.rotate(centerx, centery);
      }
    }
  }
  
  // display piece on board by
  // calling display() for each tile
  public void display() {
    for(Tile i : tiles) {
      i.display(colorID);
    }
  }
  
  // display mini piece on sidebar by
  // calling sideDisplay() for each tile
  public void sideDisplay() {
    int dx = 391, dy = 331;
    if(this instanceof IPiece) {
      dx -= 15;
      dy += 13;
    } else if(this instanceof OPiece) {
      dx -= 15;
    }
    for(Tile i : tiles) {
      i.sideDisplay(colorID, dx, dy);
    }
  }
}

class IPiece extends Piece {
  public IPiece(double cx, double cy) {
    super(cx, cy, 0);
    addTile(-1.5, -0.5);
    addTile(-0.5, -0.5);
    addTile(0.5, -0.5);
    addTile(1.5, -0.5);
  }
}

class OPiece extends Piece {
  public OPiece(double cx, double cy) {
    super(cx, cy, 1);
    addTile(-0.5, -0.5);
    addTile(-0.5, 0.5);
    addTile(0.5, 0.5);
    addTile(0.5, -0.5);
  }
}

class TPiece extends Piece {
  public TPiece(int cx, int cy) {
    super(cx, cy, 2);
    addTile(0, 0);
    addTile(-1, 0);
    addTile(0, -1);
    addTile(1, 0);
  }
}

class SPiece extends Piece {
  public SPiece(int cx, int cy) {
    super(cx, cy, 3);
    addTile(0, 0);
    addTile(-1, 0);
    addTile(0, -1);
    addTile(1, -1);
  }
}

class ZPiece extends Piece {
  public ZPiece(int cx, int cy) {
    super(cx, cy, 4);
    addTile(0, 0);
    addTile(-1, -1);
    addTile(0, -1);
    addTile(1, 0);
  }
}

class JPiece extends Piece {
  public JPiece(int cx, int cy) {
    super(cx, cy, 5);
    addTile(0, 0);
    addTile(-1, 0);
    addTile(-1, -1);
    addTile(1, 0);
  }
}

class LPiece extends Piece {
  public LPiece(int cx, int cy) {
    super(cx, cy, 6);
    addTile(0, 0);
    addTile(-1, 0);
    addTile(1, -1);
    addTile(1, 0);
  }
}
