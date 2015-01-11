class Point {
  /** Every LEDs in 8x8x8 cube, we set class Point to each point. 
      
          y ^
            |   ^ z
            |  /
            | /
            |/
            o--------> x
               L3D
               front
  **/

  int x, y, z;
  int dressCode;  // for humans, 0=red 1=green 2=blue

  Point(int side) {
    x = int(random(side));
    y = 0;
    z = int(random(side));
    dressCode = int(random(3));
  }

  Point(int _x, int _y, int _z) {
    x=_x;
    y=_y;
    z=_z;
  }

  Point(Point p) {
    this(p.x, p.y, p.z);
  }

  void checkInBound(int side) {
    if (x >= side) x -= 1;
    if (x < 0) x += 1;
    if (z >= side) z -= 1;
    if (z < 0) z += 1;
  }
}
