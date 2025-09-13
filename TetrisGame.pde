class TetrisGame {
  private int score, lines, level;
  private int[][] board;
  private Piece fallingPiece;
  private Piece nextPiece;
  
  public TetrisGame() {
    score = 0;
    lines = 0;
    level = 1;
    board = new int[20][10];
    
    // initialize board to all empty cells (colorID = -1)
    for(int[] row : board) {
      Arrays.fill(row, -1);
    }
    
    // initialize nextPiece by generating a random piece
    // then start the cycle of pieces with choosePiece()
    // so that fallingPiece will be initialized and
    // a new nextPiece will be generated
    generateRandomPiece();
    nextPiece = dummyPiece;
    choosePiece();
  }
  
  public Piece getFallingPiece() {
    return fallingPiece;
  }
  
  // returns true if the board has a tile at given position
  // returns false otherwise
  public boolean occupied(int x, int y) {
    return board[y][x] >= 0;
  }
  
  // locks current falling piece into grid
  public void lockPiece() {
    for(Tile i : fallingPiece.getTiles()) {
      board[i.getY()][i.getX()] = fallingPiece.getColorID();
    }
  }
  
  // clear rows and update board as needed
  public void clearRows() {
    // find index of all rows that need to be cleared and
    // store in ArrayList in descending order (bottom to top)
    ArrayList<Integer> rowsToClear = new ArrayList<>();
    for(int i = 19; i >= 0; i--) {
      boolean full = true;
      for(int j = 0; j < 10; j++) {
        if(board[i][j] < 0) {
          full = false;
          break;
        }
      }
      if(full) {
        rowsToClear.add(i);
        // Arrays.fill(board[i], -1);
      }
    }
    rowsToClear.add(-1); // creates a boundary for next step
        
    // clear rows by shifting rows above it down
    // if a row is not to be cleared and has k rows to clear below it,
    // shift the row down k spots
    for(int i = 0; i < rowsToClear.size() - 1; i++) {
      for(int j = rowsToClear.get(i) - 1; j > rowsToClear.get(i + 1); j--) {
        System.arraycopy(board[j], 0, board[j + i + 1], 0, 10);
      }
    }
    
    updateScore(rowsToClear.size() - 1); // update score
  }
  
  // update score for clearing rows
  public void updateScore(int rows) {
    score += lineClearPoints[rows] * level;
    highscore = Math.max(score, highscore);
    if(lines % 10 + rows >= 10) {
      level++;
      updateSpeed(level);
    }
    lines += rows;
  }
  
  // update score for dropping
  public void updateScore(boolean hardDrop) {
    if(hardDrop) {
      score += 2;
    } else {
      score++;
    }
    highscore = Math.max(score, highscore);
  }
  
  // update rate at which pieces drop based on level
  // customizable based on player's skill
  public void updateSpeed(int level) {
    double time = Math.pow((0.8 - ((level - 1) * 0.007)), level - 1);
    speed = (int) (time * 60);
  }
  
  // set fallingPiece to nextPiece
  // generate new Piece for nextPiece
  public void choosePiece() {
    fallingPiece = nextPiece;
    generateRandomPiece();
    nextPiece = dummyPiece;
  }
  
  // give the placeholder dummyPiece a random piece
  public void generateRandomPiece() {
    // fill up bag of pieces if empty
    if(bagOfPieces.isEmpty()) {
      for(int i = 0; i < 7; i++) {
        bagOfPieces.add(i);
      }
    }
    
    // randomly select a numbers from 0 to 6,
    // which corresponds to a type of piece
    int idx = (int) (Math.random() * bagOfPieces.size());
    int pieceType = bagOfPieces.remove(idx);
    
    // store corresponding piece in the placeholder dummyPiece
    if(pieceType == 0) {
      dummyPiece = new IPiece(4.5,1.5);
    } else if(pieceType == 1) {
      dummyPiece = new OPiece(4.5,1.5);
    } else if(pieceType == 2) {
      dummyPiece = new TPiece(4,2);
    } else if(pieceType == 3) {
      dummyPiece = new SPiece(4,2);
    } else if(pieceType == 4) {
      dummyPiece = new ZPiece(4,2);
    } else if(pieceType == 5) {
      dummyPiece = new JPiece(4,2);
    } else if(pieceType == 6) {
      dummyPiece = new LPiece(4,2);
    }
  }
  
  // initiates gameover state
  public void gameover() {
    curGame = null;
  }
  
  // displays the board, the falling piece, and score/lines/level
  public void display() {
    // display board colors
    for(int i = 0; i < 20; i++) {
      for(int j = 0; j < 10; j++) {
        int colorID = board[i][j];
        if(colorID >= 0) {
          fill(rgb[colorID][0], rgb[colorID][1], rgb[colorID][2]);
          // j -> column -> x, i -> row -> y
          rect(CoordConv.convCoord(j), CoordConv.convCoord(i), 38, 38, 3);
        }
      }
    }
    
    // display falling piece and next piece
    fallingPiece.display();
    nextPiece.sideDisplay();
    
    // display score/lines/level
    fill(255);
    textFont(fontTypewriter, 24);
    text(score, 545, 560);
    text(lines, 545, 640);
    text(level, 545, 720);
  }
}
