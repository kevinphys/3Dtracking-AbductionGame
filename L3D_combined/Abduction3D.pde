import peasy.*;
import processing.serial.*;
import processing.opengl.*;

// Abduction3D part
import damkjer.ocd.*;
UFO ufo;
Gaia gaia;

// L3D cube frame part
color [][][] cube;
int side=8;
PVector center=new PVector(side/2-.5, side/2 - 0.5, side/2- 0.5);
PeasyCam cam;
int scale=240;
int state=0;
int zed=0;
int inc=1;
Point spot=new Point(0,0,0);
PImage logo;



void setup()
{
  logo=loadImage("logo.png");
  cube=new color[side][side][side];
  print(center);
  size(displayWidth, displayHeight, P3D);
  cam = new PeasyCam(this, 4000);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(10000);
  initMulticast();
  frameRate(100);
}


void draw()
{
  background(0); 
  rotateX(PI);
  stroke(255, 10);
  translate(-side*scale/2, -side*scale/2, -side*scale/2);
  
  

  updateSerial();

  if(mousePressed && mouseButton == LEFT)
    msg("defining boundaries");
    
  updateCube();
  
  for (int x=0; x<side; x++)  
    for (int y=0; y<side; y++)  
      for (int z=0; z<side; z++)  
      {
        pushMatrix();
        translate(x*scale, y*scale, z*scale);
        if (brightness(cube[x][y][z])!=0)
          fill(cube[x][y][z]);
        else
          noFill();
        box(scale, scale, scale);
        popMatrix();
      }
      
  cam.beginHUD();
  image(logo,0,0);
  String []info={"L3D Cube streaming test",
                "This program streams to any cube on the local network that's running the Listening program",
                "Move the blue voxel around using the arrow keys for the x and y axes",
                "The 'q' and 'a' keys move it along the z axis",
                "Voxel position: ("+spot.x+", "+spot.y+", "+spot.z+")"};

  HUDText(info, new PVector(0,100,0));
  cam.endHUD();
}

void HUDText(String[] info, PVector origin)
{
  fill(255);
  for(int i=0;i<info.length;i++)
    text(info[i],origin.x, origin.y+15*i, origin.z);
}

void setVoxel(int x, int y, int z, color col)
{
  if ((x>=0)&&(x<side))
    if ((y>=0)&&(y<side))
      if ((z>=0)&&(z<side))
        cube[x][y][z]=col;
}

void setVoxel(Point p, color col)
{
  if ((p.x>=0)&&(p.x<side))
    if ((p.y>=0)&&(p.y<side))
      if ((p.z>=0)&&(p.z<side))
        cube[p.x][p.y][p.z]=col;
}

void updateCube()
{
  cubeBackground(color(0, 0, 0)); 
    //abduction
  ufo.update(getXYZ());
  gaia.update();
  
  sendData();
  //delay(10);
}

void cubeBackground(color col)
{
  for (int x=0; x<side; x++)
    for (int y=0; y<side; y++)
      for (int z=0; z<side; z++)
        cube[x][y][z]=col;
}

void oneVoxel()
{
  setVoxel(spot, color(0,0,255));
  fill(255);
  text("( "+spot.x+", "+spot.y+", "+spot.z+" )",10,10);
}

void line(Point p1, Point p2, color col) {

  int i, dx, dy, dz, l, m, n, x_inc, y_inc, z_inc, err_1, err_2, dx2, dy2, dz2;
  Point currentPoint=new Point(p1.x, p1.y, p1.z);
  dx = p2.x - p1.x;
  dy = p2.y - p1.y;
  dz = p2.z - p1.z;
  x_inc = (dx < 0) ? -1 : 1;
  l = abs(dx);
  y_inc = (dy < 0) ? -1 : 1;
  m = abs(dy);
  z_inc = (dz < 0) ? -1 : 1;
  n = abs(dz);
  dx2 = l << 1;
  dy2 = m << 1;
  dz2 = n << 1;

  if ((l >= m) && (l >= n)) {
    err_1 = dy2 - l;
    err_2 = dz2 - l;
    for (i = 0; i < l; i++) {
      setVoxel(currentPoint, col);
      if (err_1 > 0) {
        currentPoint.y += y_inc;
        err_1 -= dx2;
      }
      if (err_2 > 0) {
        currentPoint.z += z_inc;
        err_2 -= dx2;
      }
      err_1 += dy2;
      err_2 += dz2;
      currentPoint.x += x_inc;
    }
  } else if ((m >= l) && (m >= n)) {
    err_1 = dx2 - m;
    err_2 = dz2 - m;
    for (i = 0; i < m; i++) {
      setVoxel(currentPoint, col);
      if (err_1 > 0) {
        currentPoint.x += x_inc;
        err_1 -= dy2;
      }
      if (err_2 > 0) {
        currentPoint.z += z_inc;
        err_2 -= dy2;
      }
      err_1 += dx2;
      err_2 += dz2;
      currentPoint.y += y_inc;
    }
  } else {
    err_1 = dy2 - n;
    err_2 = dx2 - n;
    for (i = 0; i < n; i++) {
      setVoxel(currentPoint, col);
      if (err_1 > 0) {
        currentPoint.y += y_inc;
        err_1 -= dz2;
      }
      if (err_2 > 0) {
        currentPoint.x += x_inc;
        err_2 -= dz2;
      }
      err_1 += dy2;
      err_2 += dx2;
      currentPoint.z += z_inc;
    }
  }

  setVoxel(currentPoint, col);
}

class Point {
  int x, y, z;

  Point() {
  }
  Point(int _x, int _y, int _z)
  {
    x=_x;
    y=_y;
    z=_z;
  }
}










import processing.serial.*;
import processing.opengl.*;

// abduction
import damkjer.ocd.*;
UFO ufo;
Gaia gaia;

Serial serial;
String serialPort = "/dev/tty.usbmodem1411";   
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

void setup()
{
  logo=loadImage("logo.png");
  cube=new color[side][side][side];
  print(center);
  size(displayWidth, displayHeight, P3D);
  cam = new PeasyCam(this, 4000);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(10000);
  initMulticast();
  frameRate(100);

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
