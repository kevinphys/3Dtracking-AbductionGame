class Game {

  int side;
  int howManyPeople = 10;
  int score = 0;

  Speed[] v = new Speed[howManyPeople];
  Point handPostion;
  Point[] humans = new Point[howManyPeople];
  color[][][] cube = new color[side][side][side];


  Game(color[][][] _cube, int _side, Point _handPosition) {
  	side = _side;
    handPostion = _handPosition;

    for (int i=0; i<n; i++) {
      humans[i].x = random(side);
      humans[i].y = 0;
      humans[i].z = random(side);
    }

    arrayCopy(_cube, cube);
  }


  void setVoxel(Point p, color col) {
  	if ((p.x>=0)&&(p.x<side))
    	if ((p.y>=0)&&(p.y<side))
    		if ((p.z>=0)&&(p.z<side))
        		cube[p.x][p.y][p.z]=col;
  }

  void updateHand(Point p) {
    p = handPostion;
  }

  void paintUFO() {
    setVoxel(handPosition, color(150, 0, 255));
    handPostion.y = handPostion.y - 1;
    setVoxel(handPosition, color(150, 0, 255));
    handPostion.y = handPostion.y + 2;
    setVoxel(handPosition, color(0, 0, 255));
    handPostion.y = handPostion.y - 1;
    handPostion.x = handPostion.x + 1;
    setVoxel(handPostion, color(0, 0, 255));
    handPostion.x = handPostion.x - 2;
    setVoxel(handPostion, color(0, 0, 255));
    handPostion.x = handPostion.x + 1;
    handPostion.z = handPostion.z + 1;
    setVoxel(handPostion, color(0, 0, 255));
    handPostion.z = handPostion.z - 2;
    setVoxel(handPostion, color(0, 0, 255));
    handPostion.x = handPostion.x + 1;
    setVoxel(handPostion, color(0, 0, 120));
    handPostion.x = handPostion.x - 2;
    setVoxel(handPostion, color(0, 0, 120));
    handPostion.z = handPostion.z + 2;
    setVoxel(handPostion, color(0, 0, 120));
    handPostion.x = handPostion.x + 2;
    setVoxel(handPostion, color(0, 0, 120));
    handPostion.x = handPostion.z - 1;
    handPostion.x = handPostion.x - 1;
  }

  void sucking(int i) {
    int tempY = handPosition.y - humans[i].y;
    if (tempY <= 1) {
      setVoxel(humans[i], color(255, 157, 0));
      setVoxel(humans[i].y + 1, color(255, 110, 0));
      humans[i].x = random(side);
      humans[i].y = 0;
      humans[i].z = random(side);
      score++;
    }
    else {
      setVoxel(humans[i], color(255, 220, 0));
      humans[i].y = humans[i].y + round(tempY/4);
      setVoxel(humans[i], color(255, 200, 0));
      humans[i].y = humans[i].y + round(tempY/2);
      setVoxel(humans[i], color(255, 157, 0));
      setVoxel(humans[i].y + 1, color(255, 110, 0));
    }
  }
  
  void updateHuman() {
    for (int i=0; i<humans.length; i++) {
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
      }
    }
  }


  void paintHuman() {
    updateHuman();
    for (int i=0; i<humans.length; i++) {
      if (humans[i].y == 0){
        setVoxel(humans[i], color(255, 157, 0));
        setVoxel(humans[i].y + 1, color(255, 110, 0));
      }
    }
  }


  void updateGame() {
    paintUFO();
    paintHuman();
  }


  Point updateCubeInGame(color[][][] newCube) {
    updateGame();
    arrayCopy(cube, newCube);

    return newCube;
  }
}
