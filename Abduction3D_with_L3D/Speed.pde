class Speed {
  /** Every LEDs in 8x8x8 cube, we set class Speed to each humans' speed. 
      
          y ^
            |   ^ z
            |  /
            | /
            |/
            o--------> x
               L3D
               front
  **/

  int x, z;   // We don't need y direction

  Speed() {
    x = int(random(-2, 2));
    z = int(random(-2, 2));

    checkMove();
  }

  void checkMove() {
    // To avoid people stopping
    while (x == 0 && z == 0) {
      x = int(random(-2, 2));
      z = int(random(-2, 2));
    }
  }

  void checkRebounded(Point p, int side) {
    // 
    if (p.x == side-1) x = -x;
    if (p.x == 0) x = -x;
    if (p.z == side-1) z = -z;
    if (p.z == 0) z = -z;
  }

}
