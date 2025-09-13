import java.util.Arrays;

// global params

int tick; // program updates 60 ticks/sec
int speed; // time interval between piece drops, in ticks
int highscore = 0; // high score of this session
int buttonR, buttonG, buttonB; // rgb of button
boolean overButton = false; // true if mouse is hovering over button
PFont fontTypewriter; // typewriter font
PFont fontChalk; // chalkduster font
Piece dummyPiece; // placeholder piece

// direction arrays
int[] dx = {0, 1, 0, -1}; // 0: up, 1: right, 2: down, 3: left
int[] dy = {-1, 0, 1, 0}; // 0: up, 1: right, 2: down, 3: left

// color IDs to RGB
// a color ID of -1 means a blank square
int[][] rgb = {{101, 224, 222}, // 0: aqua I Piece
               {245, 242, 98}, // 1: yellow O Piece
               {158, 89, 227}, // 2: purple T Piece
               {136, 247, 124}, // 3: green S Piece
               {252, 33, 33}, // 4: red Z Piece
               {17, 21, 245}, // 5: blue J Piece
               {245, 148, 37}}; // 6: orange L Piece
               
// point table for line clears
int[] lineClearPoints = {0, 100, 300, 500, 800};

ArrayList<Integer> bagOfPieces = new ArrayList<>(); // bag of Tetris pieces to choose from
TetrisGame curGame; // current game of Tetris being played


void setup() {
  size(650,840);
  strokeJoin(ROUND);
  textAlign(CENTER);
  fontTypewriter = loadFont("AmericanTypewriter-36.vlw");
  fontChalk = loadFont("Chalkduster-48.vlw");
}

void draw() {
  background(0);
  
  // sidebar
  fill(#ebeceb);
  rect(440,0,210,840);
  
  // title
  fill(0);
  textFont(fontChalk, 48);
  text("Tetris", 545, 70);
  textSize(20);
  text("by Troy", 545, 100);
  
  // play button
  checkButton();
  fill(buttonR, buttonG, buttonB);
  rect(480,130,130,50,8);
  fill(0);
  textFont(fontTypewriter, 30);
  text("Play", 545, 165);
  
  // nextPiece text and gridbox
  fill(0);
  textFont(fontTypewriter, 24);
  text("Next Piece", 545, 330);
  rect(470,335,150,150,8);
  
  // scoreboard boxes
  fill(0);
  rect(470,535,150,30,8);
  rect(470,615,150,30,8);
  rect(470,695,150,30,8);
  rect(470,775,150,30,8);

  // scoreboard text
  fill(0);
  textFont(fontTypewriter, 24);
  text("Score", 545, 530);
  text("Lines", 545, 610);
  text("Level", 545, 690);
  text("High Score", 545, 770);
  fill(255);
  text(highscore, 545, 800);

  // grid
  stroke(40);
  strokeWeight(2);
  for(int i = 20; i <= 820; i += 40) {
    line(20,i,420,i);
  }
  for(int i = 20; i <= 420; i += 40) {
    line(i,20,i,820);
  }
  noStroke();
  
  if(curGame == null) {
    fill(255);
    textFont(fontChalk, 36);
    text("Click \"Play\"", 220, 390);
    text("to Start", 220, 430);
  } else {
    curGame.display();
    tick++;
  
    if(tick % speed == 0) {
      // try soft-dropping piece down
      curGame.getFallingPiece().tempShift(2, 1);
      if(!curGame.getFallingPiece().isValid()) {
        // if piece can't be dropped, shift it back up,
        // lock the piece in place, clear rows as needed,
        // and choose the next piece to fall down
        curGame.getFallingPiece().tempShift(0, 1);
        curGame.lockPiece();
        curGame.clearRows();
        curGame.choosePiece();
      
        // check if the new falling piece can be placed
        // if not, the game is over
        if(!curGame.fallingPiece.isValid()) curGame.gameover();
      } else {
        // update score with soft drop
        curGame.updateScore(false);
      }
    }
  }
}

void checkButton() {
  // check if mouse coordinates are inside the button borders
  // if yes, overButton is true and colors are darker than usual
  // otherwise, overButton is false and colors are lighter
  if(mouseX >= 480 && mouseX <= 610 && mouseY >= 130 && mouseY <= 180) {
    overButton = true;
    buttonR = 70;
    buttonG = 163;
    buttonB = 95;
  } else {
    overButton = false;
    buttonR = 137;
    buttonG = 232;
    buttonB = 162;
  }
}

void mousePressed() {
  if(overButton) {
    // create new game, reset speed and tick counters
    curGame = new TetrisGame();
    speed = 60;
    tick = 0;
  }
}

void keyPressed() {
  if(curGame == null) return;
  if(keyCode == UP) {
    // rotate piece
    curGame.getFallingPiece().rotate();
  } else if(keyCode == RIGHT) {
    // shift piece right if possible
    curGame.getFallingPiece().shift(1, 1);
  } else if(keyCode == DOWN) {
    // hard drop the piece
    curGame.getFallingPiece().tempShift(2, 1);
    if(curGame.getFallingPiece().isValid()) {
      // if possible, then update score
      curGame.updateScore(true);
    } else {
      // if not possible, shift piece back up
      curGame.getFallingPiece().tempShift(0, 1);
    }
  } else if(keyCode == LEFT) {
    // shift piece left if possible
    curGame.getFallingPiece().shift(3, 1);
  } else if(key == ' ') {
    // insta drop piece with same scoring as hard drop
    while(curGame.getFallingPiece().isValid()) {
      curGame.getFallingPiece().tempShift(2, 1);
      curGame.updateScore(true);
    }
    curGame.getFallingPiece().tempShift(0, 1);
    tick = (tick + speed - 1) / speed * speed - 1;
  }
}
