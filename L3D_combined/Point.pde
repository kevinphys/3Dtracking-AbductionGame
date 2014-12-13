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

  Point(int _x, int _y, int _z)
  {
    this.x=_x;
    this.y=_y;
    this.z=_z;
  }

  void add(Point p)
  {
    x = x + p.x;
    y = y + p.y;
    z = z + p.z;
  }
}