// class UFO {
//   // int hp;
//   // int score;
  
//   // float radius;
//   // float halfH; // half height
  
//   Point pos = new Point(0, 0, 0);
//   Point coverage = new Point(0, 0);
  
//   //PShape ufoShape, top, body, bottom;
  
//   // UFO(float _radius) {
//   //   hp = 100;
//   //   score = 0;
//   //   radius = _radius;
//   //   halfH = 0.2 * radius;
    
//   //   createUFOShape(50, 1.1* radius, 0.9* radius, 2*halfH);
//   // }


//   // void paintUFOShape(){
    
//   // }


//   // void scoreUp(){
//   //   score += 1;
//   // }
//   // void getHit(){
//   //   hp -=1;
//   // }
  
//   void renewPos(float ax, float ay, float az){
//     pos.set(ax, ay, az);
//     coverage.set(pos.x, pos.y);
//   }

//   // void paint(){
//     // pushMatrix();
//     //   translate(pos.x, pos.y, pos.z);
//     //   shape(ufoShape);
//     // popMatrix();
//   // }
//   void oneVoxel()
//   {
//     setVoxel(spot, color(0,0,255));
//     fill(255);
//     text("( "+spot.x+", "+spot.y+", "+spot.z+" )",10,10);
//   }


//   void update(Point axyz){
//     //if (hp > 0)
//     renewPos(axyz.x, axyz.y, axyz.z);
//     // else 
//     //   renewPos(12*radius*sin(0.001*millis()), 12*radius*cos(0.001*millis()), 2*radius);
    
//     paintUFOShape();
//   }
// }
