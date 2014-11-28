class Gaia {
  int stage;
  float bound;

  UFO ufo;

  Human[] humans = null;
  Airplane[] airplanes = null;
  Missile[] missiles = null;
  
  PShape airplaneShape, planebody, rightFrontWing, leftFrontWing, backWing;
  PShape humanShape, humanhead, humanbody;
  PShape missileShape, missilehead, missilebody1, missilebody2, missilesmoke1, missilesmoke2, missilesmoke3, missilesmoke4;
    
  Gaia(UFO _ufo, float _bound) {
    stage = 0;
    bound = _bound;
    ufo = _ufo;
  }
  void createHumanShape(){
    humanShape = createShape(GROUP);
      humanhead = createShape(SPHERE, 0.01 * bound);
      humanhead.setFill(color(236, 191, 147));// skin color
      humanhead.translate(0, 0, 0.060 * bound);
      
      humanbody = createShape(BOX, 0.015 * bound, 0.015 * bound, 0.040 * bound);
      humanbody.setFill(color(236, 191, 147));// skin color
      humanbody.translate(0, 0, 0.020 * bound);
      
      humanShape.addChild(humanhead);
      humanShape.addChild(humanbody);
  }
  void createAirplaneShape(){
    airplaneShape = createShape(GROUP);
      planebody = createShape(BOX, 0.120 * bound, 0.020 * bound, 0.020 * bound);
      planebody.setFill(color(255));// white
      
      rightFrontWing = createShape(BOX, 0.015 * bound, 0.050 * bound, 0.015 * bound);
      rightFrontWing.setFill(color(255, 0, 0)); // red
      rightFrontWing.rotateZ(120);
      rightFrontWing.translate(0.025 * bound, 0.025 * bound, 0);
      
      leftFrontWing = createShape(BOX, 0.015 * bound, 0.050 * bound, 0.015 * bound);
      leftFrontWing.setFill(color(255, 0, 0)); // red
      leftFrontWing.rotateZ(-120);
      leftFrontWing.translate(0.025 * bound, -0.025 * bound, 0);
      
      backWing = createShape(BOX, 0.010 * bound, 0.060 * bound, 0.010 * bound);
      backWing.setFill(color(255, 0, 0)); // red
      backWing.translate(-0.050 * bound, 0, 0);
      
      airplaneShape.addChild(planebody);
      airplaneShape.addChild(rightFrontWing);
      airplaneShape.addChild(leftFrontWing);
      airplaneShape.addChild(backWing);
  }
  void createMissileShape() {
    missileShape = createShape(GROUP);
      missilehead = createShape(SPHERE, 0.035 * bound);
      missilehead.setFill(color(0, 0, 0));// missile head color
      missilehead.translate(-0.005 * bound, 0, 0);
      
      missilebody1 = createShape(BOX, 0.10 * bound, 0.06 * bound, 0.06 * bound);
      missilebody1.setFill(color(0 ,0 ,0));// body color
      missilebody1.translate(0.05 * bound, 0, 0);
      
      missilebody2 = createShape(BOX, 0.015 * bound, 0.061 * bound, 0.061 * bound);
      missilebody2.setFill(color(0, 0, 0));//missilebody2.setFill(color(255, 128, 0));// body color
      missilebody2.translate(0.03 * bound, 0, 0);
      
      missilesmoke1 = createShape(SPHERE, 0.043 * bound);
      missilesmoke1.setFill(color(120, 120, 120));// smoke color
      missilesmoke1.translate(0.13 * bound, 0, 0);
 
      missilesmoke2 = createShape(SPHERE, 0.035 * bound);
      missilesmoke2.setFill(color(130, 130, 130));// smoke color
      missilesmoke2.translate(0.20 * bound, 0, 0);
      
      missilesmoke3 = createShape(SPHERE, 0.030 * bound);
      missilesmoke3.setFill(color(140, 140, 140));// smoke color
      missilesmoke3.translate(0.28 * bound, 0, 0);
 
      missilesmoke4 = createShape(SPHERE, 0.025 * bound);
      missilesmoke4.setFill(color(160, 160, 160, 170));// smoke color
      missilesmoke4.translate(0.35 * bound, 0, 0);
      
      missileShape.addChild(missilehead);
      missileShape.addChild(missilebody1);
      missileShape.addChild(missilebody2);
      missileShape.addChild(missilesmoke1);
      missileShape.addChild(missilesmoke2);
      missileShape.addChild(missilesmoke3);
      missileShape.addChild(missilesmoke4);
    
    missileShape.scale(0.5f);
  }
  void createHumans(int n){
    createHumanShape();
    
    if (humans == null || humans.length != n){
      humans = new Human[n];
      for(int i = 0; i < humans.length; i++)
        humans[i] = new Human(this);	
    }
  }
  void createAirplanes(int n){
    createAirplaneShape();
    
    if (airplanes == null || airplanes.length != n){
      airplanes = new Airplane[n];
      for(int i = 0; i < airplanes.length; i++)
        airplanes[i] = new Airplane(this);	
    }
  }
  void createMissiles(int n){
    createMissileShape();
    
    if (missiles == null || missiles.length != n){
      missiles = new Missile[n];
      for(int i = 0; i < missiles.length; i++)
        missiles[i] = new Missile(this);  
    }
  }
  void updateBeings(Earthbeing[] earthbeings){
    if (earthbeings != null)
      for(int i = 0; i < earthbeings.length; i++)
        if (earthbeings[i] != null)
	  earthbeings[i].update();
  }
  void newStage(){
    // display info
    fill(255, 0, 0); // red
    textSize(bound/12);
    pushMatrix();
      translate(0, 1.4*bound, 0.8*bound);
      rotateY(radians(90));
      rotateZ(radians(-90));
      String info = "Score: "  + str(ufo.score) + "\nStage: " + str(stage) +"\nHP    : "+ str(ufo.hp);
      if (ufo.hp > 0)
        text(info, 0, 0); 
      else
        text(info + "\nGame Over", 0, 0);
      
    popMatrix();
    
    
    if (ufo.score >= 20*stage){
      stage += 1;
      createHumans( 100 * 1/stage );
      createAirplanes( stage / 2);
      createMissiles( stage / 3);
    }
    
  }
  void update() {
    newStage();
    
    updateBeings(humans);
    updateBeings(airplanes);
    updateBeings(missiles);
    
    pushMatrix();
      fill(0, 255, 60);//green
      rect(0, 0, bound, bound);
      
      fill(102, 255, 255, 100);//blue
        rotateX(radians(90));
        rect(0, 0, bound, bound);
          rotateY(radians(90));
          rect(0, 0, bound, bound);
          rotateY(radians(-90));
        rotateX(radians(-90));
      
      translate(bound/2, bound/2, bound/2);
      stroke(0, 0, 255);
      noFill();
      box(bound);
      noStroke();
    popMatrix();
  
    
  }
}
