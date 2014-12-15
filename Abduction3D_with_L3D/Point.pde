class Point {
  /** In every LEDs in 8x8x8 cube, we set class Point to each point. 
      
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

  Point() {
  }

  Point(int _x, int _y, int _z) {
    x=_x;
    y=_y;
    z=_z;
  }

  void checkInBound(int side) {
    if (x > side) x -= side;
    if (x < 0) x += side;
    if (y > side) y -= side;
    if (y < 0) y += side;
    if (z > side) z -= side;
    if (z < 0) z += side;
  }
}