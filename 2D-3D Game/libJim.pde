//swetul patel

// Custom Camera 
void myCamera(float eyeX, float eyeY, float eyeZ, 
  float centerX, float centerY, float centerZ, 
  float upX, float upY, float upZ) {
    camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, -upX, -upY, -upZ);
}


// 3D axis-aligned box collision. NOT USED
boolean collide(float bottom1, float top1, float left1, float right1, float back1, float front1, 
  float bottom2, float top2, float left2, float right2, float back2, float front2) {
    return collideDimension(bottom1, top1, bottom2, top2) && 
           collideDimension(left1, right1, left2, right2) && 
           collideDimension(back1, front1, back2, front2);
}

// start and stop of 2 shapes in some dimension, returns true of they overlap on the number line
boolean collideDimension(float start1, float stop1, float start2, float stop2){
  return (start1 < stop2 && stop1 > start2);
}


///////////// Custom projection functions. Used to access the Processing under-the-hood engine
PGraphicsOpenGL pogl = null; 

void setupPOGL() {
  pogl = (PGraphicsOpenGL)g;
}

void printProjection() {
  pogl.projection.print();
}

void setProjection(PMatrix3D mat) {
assert pogl != null: 
  "no PGraphics Open GL Conext";
  //pogl.setProjection(mat.get());
  pogl.projection.set(mat.get());
  pogl.updateProjmodelview();
}

PMatrix3D getProjection() {
assert pogl != null: 
  "no PGraphics Open GL Conext";
  return pogl.projection.get();
}
