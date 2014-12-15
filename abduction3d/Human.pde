class Human extends Earthbeing {
  Human(Gaia _gaia) {
    super(_gaia);
  }
  PVector generateSpeed(){
    return PVector.mult(super.generateSpeed(), 0.25 * radius);
  }
  void paint(){
    shape(gaia.humanShape);
  }
}
