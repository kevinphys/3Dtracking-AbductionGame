class Missile extends Earthbeing {
  Missile(Gaia _gaia) {
    super(_gaia);
  }
  PVector generateSpeed(){
    return PVector.mult(new PVector(0f, 0f, 1f), random(1.0*radius, 1.5*radius));
  }
  boolean abductable(){
    return false;
  }
  void paint(){
    pushMatrix();
      rotateZ(speed.heading());
      
      PVector horizontalSpeed = new PVector(speed.x, speed.y);
      float horizontalMag = horizontalSpeed.mag();
      
      PVector zSpeed = new PVector(horizontalMag, speed.z);
      rotateY(zSpeed.heading());
      
      shape(gaia.missileShape);
    popMatrix();
  }
}
