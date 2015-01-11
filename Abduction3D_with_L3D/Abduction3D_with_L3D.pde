import peasy.test.*;
import peasy.org.apache.commons.math.*;
import peasy.*;
import peasy.org.apache.commons.math.geometry.*;

import processing.serial.*;

//  ------ Serial Port ------
//  - In Windows, if you have 3 ports : COM1, COM2, COM3 , and set "COMx".
//  - In Mac OSX or Linux, you could check this reference http://arduino.cc/en/guide/macOSX.
//    It would be like "/dev/tty.usbmodem____".
Serial serial;
String serialPort = "COM4";   

// Declare UFO abduction game class
Game game;

// Initializing the direction of {x, y, z}
boolean[] flip = {false, false, false};

int sen = 3;            // Aluminium foil sensors
int side = 8;           // LEDs on each side of cube
int howManyPeople = 5;
int scale = 240;        // Set simulation box's size 

// ------ Using three arrays to store different data ------
// nxyz[], template position without fliping stored in (n[0], n[1], n[2])
// axyz[], up-to-date position stored in (axyz[0], axyz[1], axyz[2])
// n[],    used for normalizing
float[] nxyz = new float[sen];
MomentumAverage axyz[] = new MomentumAverage[sen];
Normalize n[] = new Normalize[sen];

PVector center = new PVector(side/2-.5, side/2 - 0.5, side/2- 0.5);
PeasyCam cam;
PImage logo;
color [][][] cube;      // cube[x][y][z] stores the color code


void setup()
{
  logo = loadImage("logo.png");
  cube = new color[side][side][side];
  
  size(displayWidth, displayHeight, P3D);
  println(Serial.list()); 
  serial = new Serial(this, serialPort, 115200);
  
  for(int i = 0; i < sen; i++) {
    // Initialize 3D tracking system
    n[i] = new Normalize();
    axyz[i] = new MomentumAverage(.13); // MomentumAverage(Sensitivity)
  }

  // Start a new game
  game = new Game(cube, side, howManyPeople, getXYZ());

  for(int i = 0; i < howManyPeople; i++) {
    // Give birth to poor humans
    game.humans[i] = new Point(side);
    game.v[i] = new Speed();
  }

  cam = new PeasyCam(this, 4000);
  cam.setMinimumDistance(500);
  cam.setMaximumDistance(10000);

  initMulticast();    // Ready for UDP
  frameRate(10);
}
  

void draw()
{
  background(0); 
  rotateX(PI);
  stroke(255, 10);
  translate(-side*scale/2, -side*scale/2, -side*scale/2);
  
  updateSerial();     // Update hand position from serial port
    
  updateCube();       // Update each 8x8x8 LEDs' on or off throughout UDP
  
  for (int x=0; x<side; x++)  
    for (int y=0; y<side; y++)  
      for (int z=0; z<side; z++)  
      {
        // ------ Draw each cube's color in Java visual box ------
        // We don't send data to L3D cube here. Only for display at monitor.
        pushMatrix();
        translate(x*scale, y*scale, z*scale);
        if (brightness(cube[x][y][z])!=0)
          fill(cube[x][y][z]);
        else
          noFill();
        box(scale, scale, scale);
        popMatrix();
      }

  // ------ Put the L3D logo and display the hand position info ------
  // Default all at left up corner
  cam.beginHUD();
  image(logo,0,0);
  String[] info={"L3D Cube combined with UFO Abdction game!!!",
                "Voxel position: ("+getXYZ().x+", "+getXYZ().y+", "+getXYZ().z+")"};
  HUDText(info, new PVector(0,100,0));
  cam.endHUD();
}


void updateSerial() {
  // ------ Getting data from 3D tracking system ------
  // In here, each capacitance of x, y, z will send back data with arduino
  // using USB to computer.
  String cur = serial.readStringUntil('\n');
  if(cur != null) {
    String[] parts = split(cur, " "); // Store x, y, z original data
    if(parts.length == sen) {
      float[] xyz = new float[sen];
      for(int i = 0; i < sen; i++)
        xyz[i] = float(parts[i]);

      if(mousePressed && mouseButton == LEFT)
        // ------ Calibration ------
        // Pressing mouse left button and moving hand from inside to outside 
        // will normalize data in n[] which was stored in xyz[] before.
        // This step will set data range(max and min) during moving hand.
        for(int i = 0; i < sen; i++)
          n[i].note(xyz[i]);

      nxyz = new float[sen];

      for(int i = 0; i < sen; i++) {
        // ------ Check every data using normalized n[] ------
        // We will get the exact position in this for loop, and (x, y, z)
        // will be stored in axyz[].avg
        float raw = n[i].choose(xyz[i]);
        nxyz[i] = flip[i] ? 1 - raw : raw;
        axyz[i].note(nxyz[i]);
      }
    }
  }
}

void HUDText(String[] info, PVector origin)
{
  // Info text function
  fill(255);
  for(int i=0;i<info.length;i++)
    text(info[i],origin.x, origin.y+15*i, origin.z);
}

void setVoxel(int x, int y, int z, color col)
{
  // ------ Set each voxel color code ------
  // Using exact (x, y, z) to store color in cube[x][y][z].
  if ((x>=0)&&(x<side))
    if ((y>=0)&&(y<side))
      if ((z>=0)&&(z<side))
        cube[x][y][z]=col;
}

void setVoxel(Point p, color col)
{
  // ------ Set each voxel color code with Point vector ------
  // Using pre-stored vector P in function
  if ((p.x>=0)&&(p.x<side))
    if ((p.y>=0)&&(p.y<side))
      if ((p.z>=0)&&(p.z<side))
        cube[p.x][p.y][p.z]=col;
}


void updateCube()
{
  // ------ Send data with UDP to L3D cube ------
  // When every time we update L3D cube, it will reset the global cube[x][y][z]
  // to all black and update cube again.
  cubeBackground(color(0, 0, 0)); 
  
  game.updateHand(getXYZ());
  arrayCopy(game.updateCubeInGame(cube), cube);
  
  sendData(); // UDP part
  //delay(10);
}

void cubeBackground(color col)
{
  // ------ Set all LEDs in same color ------
  // Default: dim, RGB(0, 0, 0)
  for (int x=0; x<side; x++)
    for (int y=0; y<side; y++)
      for (int z=0; z<side; z++)
        cube[x][y][z]=col;
}

Point getXYZ() {
  // Real time hand position
  Point axyzVector = new Point(
    // Because axyz[].avg is between 0 and 1, then it multiplies by 7.
    // With "round" function, we can get (x, y, z) from 0 to 7. 
    round(axyz[0].avg * 7),  // ax * 2w/3
    round(axyz[1].avg * 7),
    round(axyz[2].avg * 7));

  return axyzVector;
}

void restartGame() {
  game = new Game(cube, side, howManyPeople, getXYZ());
}

