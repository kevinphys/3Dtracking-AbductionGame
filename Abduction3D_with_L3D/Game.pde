class Game {

  int side;
  //int score = 0;
  int howManyPeople;

  Speed[] v;  // Speed of running human
  Point[] humans;
  Point handPosition;
  color[][][] cube;
  

  Game(color[][][] _cube, int _side, int _howManyPeople, Point _handPosition) {
    side = _side;
    howManyPeople = _howManyPeople;

    handPosition = new Point(_handPosition);
    v = new Speed[howManyPeople];
    humans = new Point[howManyPeople];
    cube = new color[side][side][side];
    
    arrayCopy(_cube, cube);   // From global cube color array to local class one
  }


  void setVoxel(Point p, color col) {
  	if ((p.x>=0)&&(p.x<side))
    	if ((p.y>=0)&&(p.y<side))
    		if ((p.z>=0)&&(p.z<side))
        		cube[p.x][p.y][p.z]=col;
  }
  
  void setVoxel(int x, int y, int z, color col)
  {
    if ((x>=0)&&(x<side))
      if ((y>=0)&&(y<side))
        if ((z>=0)&&(z<side))
          cube[x][y][z]=col;
  }

  void updateHand(Point p) {
    handPosition = new Point(p);
  }

  void paintUFO() {
    setVoxel(handPosition, color(150, 0, 255));
    handPosition.y = handPosition.y + 1;
    setVoxel(handPosition, color(0, 0, 255));
    handPosition.y = handPosition.y - 1;
    handPosition.x = handPosition.x + 1;
    setVoxel(handPosition, color(0, 0, 255));
    handPosition.x = handPosition.x - 2;
    setVoxel(handPosition, color(0, 0, 255));
    handPosition.x = handPosition.x + 1;
    handPosition.z = handPosition.z + 1;
    setVoxel(handPosition, color(0, 0, 255));
    handPosition.z = handPosition.z - 2;
    setVoxel(handPosition, color(0, 0, 255));
    handPosition.x = handPosition.x + 1;
    setVoxel(handPosition, color(0, 0, 120));
    handPosition.x = handPosition.x - 2;
    setVoxel(handPosition, color(0, 0, 120));
    handPosition.z = handPosition.z + 2;
    setVoxel(handPosition, color(0, 0, 120));
    handPosition.x = handPosition.x + 2;
    setVoxel(handPosition, color(0, 0, 120));
    handPosition.z = handPosition.z - 1;
    handPosition.x = handPosition.x - 1;
  }


  void sucking(int i) {
    int tempY = handPosition.y - humans[i].y;
    if (tempY <= 1) {
      setVoxel(humans[i], color(255, 157, 0));
      setVoxel(humans[i].x, humans[i].y + 1, humans[i].z, color(255, 110, 0));
      humans[i].x = int(random(side));
      humans[i].y = 0;
      humans[i].z = int(random(side));
      //score++;
    }
    else {
      setVoxel(humans[i], color(255, 220, 0));
      humans[i].y = humans[i].y + round(tempY/4);
      setVoxel(humans[i], color(255, 200, 0));
      humans[i].y = humans[i].y + round(tempY/2);
      setVoxel(humans[i], color(255, 157, 0));
      setVoxel(humans[i].x, humans[i].y + 1, humans[i].z, color(255, 170, 0));
      setVoxel(humans[i].x, humans[i].y + 2, humans[i].z, color(255, 110, 0));
    }
  }

  
  void updateHuman() {
    for (int i=0; i<humans.length; i++) {
      println(humans[i].dressCode);
      if (handPosition.x == humans[i].x && handPosition.z == humans[i].z) {
        sucking(i);
      }
      else if (humans[i].y > 0) {
        sucking(i);
      }
      else {
        humans[i].x = humans[i].x + v[i].x;
        humans[i].y = 0;
        humans[i].z = humans[i].z + v[i].z;
        humans[i].checkInBound(side);
        v[i].checkRebounded(humans[i], side);
      }
    }
  }


  void paintHuman() {
    // Set random color to each human's body
    updateHuman();
    for (int i=0; i<humans.length; i++) {
      if (humans[i].y == 0){
        switch(humans[i].dressCode) {
          case 0:
            setVoxel(humans[i], color(255, 0, 0));  // Red body
            setVoxel(humans[i].x, humans[i].y + 1, humans[i].z, color(255, 110, 0));
            break;
          case 1:
            setVoxel(humans[i], color(0, 255, 0));  // Green body
            setVoxel(humans[i].x, humans[i].y + 1, humans[i].z, color(255, 110, 0));
            break;
          case 2:
            setVoxel(humans[i], color(0, 0, 255));  // Blue body
            setVoxel(humans[i].x, humans[i].y + 1, humans[i].z, color(255, 110, 0));
            break;
        }
      }
    }
    delay(50);
  }


  void updateGame() {
    paintUFO();
    paintHuman();
  }


  color[][][] updateCubeInGame(color[][][] newCube) {
    updateGame();
    arrayCopy(cube, newCube);

    return newCube;
  }
}
