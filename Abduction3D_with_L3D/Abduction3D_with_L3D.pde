import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import processing.serial.*;
import processing.opengl.*;

// Abduction3D part
import damkjer.ocd.*;

Game game;
Serial serial;
String serialPort = "/dev/tty.usbmodem1431";   
/** Set this to be the serial port of your Arduino
    - In Windows, if you have 3 ports : COM1, COM2, COM3 , and set "COMx".
    - In Mac OSX or Linux, you could check this reference http://arduino.cc/en/guide/macOSX.
      It would be more like "/dev/tty.usbmodem____".
**/

int sen = 3;  // sensors
int div = 3;  // board sub divisions

Normalize n[] = new Normalize[sen];
MomentumAverage cama[] = new MomentumAverage[sen];
MomentumAverage axyz[] = new MomentumAverage[sen];
float[] nxyz = new float[sen];
int[] ixyz = new int[sen];


boolean[] flip = {
  false, false, false};



// L3D cube frame part
color [][][] cube;
int side = 8;
PVector center = new PVector(side/2-.5, side/2 - 0.5, side/2- 0.5);
PeasyCam cam;
int scale = 240;
int state = 0;
int zed = 0;
int inc = 1;
Point spot = new Point(0,0,0);
PImage logo;


void setup()
{
  logo = loadImage("logo.png");
  cube = new color[side][side][side];
  game = new Game(cube, side, getXYZ());
  print(center);
  size(displayWidth, displayHeight, P3D);
  
  println(Serial.list());
  serial = new Serial(this, serialPort, 115200);
  
  for(int i = 0; i < sen; i++) {
    n[i] = new Normalize();
    axyz[i] = new MomentumAverage(.13);
  }
  
  cam = new PeasyCam(this, 4000);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(10000);
  initMulticast();
  frameRate(1000);
}
  

void draw()
{
  background(0); 
  rotateX(PI);
  stroke(255, 10);
  translate(-side*scale/2, -side*scale/2, -side*scale/2);
  
  updateSerial(); // Update hand position data from serial port
    
  updateCube(); // Update each 8x8x8 LED on or off throughout UDP
  
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
  String []info={"L3D Cube combined with 3D tracking test",
                "Voxel position: ("+spot.x+", "+spot.y+", "+spot.z+")"};

  HUDText(info, new PVector(0,100,0));
  cam.endHUD();
}

void updateSerial() {
  String cur = serial.readStringUntil('\n');
  if(cur != null) {
    String[] parts = split(cur, " ");
    if(parts.length == sen) {
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
        //cama[i].note(nxyz[i]);
        axyz[i].note(nxyz[i]);
        //ixyz[i] = getPosition(axyz[i].avg);
      }
    }
  }
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
  
  game.updateHand(getXYZ());
  arrayCopy(game.updateCubeInGame(cube), cube);
  
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

Point getXYZ() {
  Point axyzVector = new Point(
      round(axyz[0].avg * 7),  // ax * 2w/3
      round(axyz[1].avg * 7),
      round(axyz[2].avg * 7));

  return axyzVector;
}

void restartGame() {
  game = new Game(cube, side, getXYZ());
}


