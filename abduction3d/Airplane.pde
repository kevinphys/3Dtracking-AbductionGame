class Airplane extends Earthbeing {
  Airplane(Gaia _gaia) {
    super(_gaia);
  }
  PVector generateSpeed(){
    return PVector.mult(super.generateSpeed(), 0.8*radius);
  }
  void respawn(){
    respawnHeight = random(0.1*gaia.bound, gaia.bound);
    super.respawn();
  }
  void paint(){
    pushMatrix();
      rotateZ(speed.heading());
      shape(gaia.airplaneShape);
    popMatrix();
  }
}
