class Speed {
  
  int x, z;

  Speed() {
    x = int(random(-2, 2));
    z = int(random(-2, 2));

    checkMove();
  }

  void checkMove() {
    while (x == 0 && z == 0) {
      x = int(random(-2, 2));
      z = int(random(-2, 2));
    }
  }

  void checkRebounded(Point p, int side) {
    if (p.x == side-1) x = -x;
    if (p.x == 0) x = -x;
    if (p.z == side-1) z = -z;
    if (p.z == 0) z = -z;
  }

}
