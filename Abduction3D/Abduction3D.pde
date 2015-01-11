import processing.serial.*;
import processing.opengl.*;

// abduction
import damkjer.ocd.*;
Camera camera;
UFO ufo;
Gaia gaia;

Serial serial;
String serialPort = "/dev/tty.usbmodem1431";   
// << Set this to be the serial port of your Arduino - ie if you have 3 ports : COM1, COM2, COM3 
// and your Arduino is on COM2 you should set this to '1' - since the array is 0 based
              
int sen = 3; // sensors
int div = 3; // board sub divisions

Normalize n[] = new Normalize[sen];
MomentumAverage cama[] = new MomentumAverage[sen];
MomentumAverage axyz[] = new MomentumAverage[sen];
float[] nxyz = new float[sen];
int[] ixyz = new int[sen];

// abduction
float w; // board size
boolean[] flip = {
  false, true, false};

int player = 0;
boolean moves[][][][];

PFont font;

void setup() {
  size(displayWidth, displayHeight, OPENGL);
  frameRate(25);
  
  //abduction
  w = displayHeight;
//  font = loadFont("TrebuchetMS-Italic-20.vlw");
//  textFont(font);
//  textMode(SHAPE);
  
  println(Serial.list());
  serial = new Serial(this, serialPort, 115200);
  
  for(int i = 0; i < sen; i++) {
    n[i] = new Normalize();
    cama[i] = new MomentumAverage(.01);
    axyz[i] = new MomentumAverage(.13);
  }
  
  reset();
  
  //abduction
  camera = new Camera(this, 1.45 * displayHeight, 1.35 * displayHeight, 1.35 * displayHeight, 
                            0, 0, -0.25 * displayHeight);
  camera.roll(radians(-65));
  
  restartGame();
}

void draw() {
  updateSerial();
  
  //abduction
  background(255);
  //drawBoard();
  //stroke(0);
  if(mousePressed && mouseButton == LEFT)
    msg("defining boundaries");
    
  //abduction
  ufo.update(getXYZ());
  gaia.update();
  
  camera.feed();
}

void updateSerial() {
  String cur = serial.readStringUntil('\n');
  if(cur != null) {
    //println(cur);
    String[] parts = split(cur, " ");
    if(parts.length == sen  ) {
      float[] xyz = new float[sen];
      for(int i = 0; i < sen; i++)
        xyz[i] = float(parts[i]);
  
      if(mousePressed && mouseButton == LEFT)
        for(int i = 0; i < sen; i++)
          n[i].note(xyz[i]);
  
      nxyz = new float[sen];
      for(int i = 0; i < sen; i++) {
        float raw = n[i].choose(xyz[i]);
        nxyz[i] = flip[i] ? 1 - raw : raw;
        cama[i].note(nxyz[i]);
        axyz[i].note(nxyz[i]);
        ixyz[i] = getPosition(axyz[i].avg);
      }
    }
  }
}

float cutoff = .2;
int getPosition(float x) {
  if(div == 3) {
    if(x < cutoff)
      return 0;
    if(x < 1 - cutoff)
      return 1;
    else
      return 2;
  } 
  else {
    return x == 1 ? div - 1 : (int) x * div;
  }
}
//abduction
//void drawBoard() {
//  ...
//}
PVector getXYZ() {
  float h = w / 2;
  float sw = w / div; // == w/3

  // draw player hand as a sphere
  float sd = sw * (div - 1);// == 2w/3
  
  
  PVector axyzVector = new PVector(
      axyz[0].avg * sd - w/5.5,  // ax * 2w/3
      axyz[2].avg * sd - w/1.1,
      -axyz[1].avg * sd + w/2.5);
  
  PVector movedOrgin = new PVector(w/4, w, w/3);
  axyzVector.add(movedOrgin);
  
  return axyzVector;
}

//abduction
//void keyPressed() {
//  if(key == TAB) {
//    moves[player][ixyz[0]][ixyz[1]][ixyz[2]] = true;
//    player = player == 0 ? 1 : 0;
//  }
//}

void restartGame(){
  ufo = new UFO(displayHeight/8);
  gaia = new Gaia(ufo, displayHeight);
}

void mousePressed() {
  if(mouseButton == RIGHT){
    reset();
    if(ufo.hp == 0)
      restartGame();
  }
}

void reset() {
  //abduction
  //moves = new boolean[2][div][div][div];
  for(int i = 0; i < sen; i++) {
    n[i].reset();
    cama[i].reset();
    axyz[i].reset();
  }
}

void msg(String msg) {
  //using 'text(msg, 10, height - 10)' results in an exception being thrown in Processing 2.0.3 on OSX
  //we're going to use the console to output instead.
  println(msg);
}
