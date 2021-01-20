// Swetul Patel 

final char KEY_ROTATE_RIGHT = ']';
final char KEY_ROTATE_LEFT = '[';
final char KEY_ZOOM_IN = '=';
final char KEY_ZOOM_OUT = '-';
final char KEY_ORTHO_CHANGE = 'o';
final char KEY_TEST_MODE = 't';

final float ANGLE_CHANGE = PI/16; // additive
final float ZOOM_CHANGE = 1.1;    // multiplicative


// if on, draws test pattern. Otherwise, draws your scene
boolean testMode = true;
boolean debug = true;
enum OrthoMode {
  IDENTITY,        // no change. straight to viewport
    CENTER640,     // 0x0 at center, width/height is 640 (+- 320)
    BOTTOMLEFT640, // 0x0 at bottom left, top right is 640x640
    FLIPX,         // same as CENTER640 but x is flipped
    ASPECT         // uneven aspect ratio: x is < -320 to 320 >, y is <-100 - 100> 
}
OrthoMode orthoMode = OrthoMode.IDENTITY;
final OrthoMode DEFAULT_ORTHO_MODE = OrthoMode.CENTER640; //<>//

void keyPressed()
{
  if(key == 'o')
  {
    int next = (orthoMode.ordinal()+1)%OrthoMode.values().length;
    orthoMode = OrthoMode.values()[next];
    checkOrtho();
    printState();
  }
  if(key == 't')
  {
    testMode = !testMode; 
  }
  if(key == '-')
  {
    currentZoom = currentZoom * ZOOM_CHANGE;
    V = getCamera(up,center,currentZoom);
    print("here");
  }
  if(key == '=')
  {
    currentZoom = currentZoom / ZOOM_CHANGE;
    V = getCamera(up,center,currentZoom);
  }
  if(key == ']')
  {
    currentAngle = currentAngle - ANGLE_CHANGE;
    println(currentAngle);
    PMatrix3D rot = new PMatrix3D(cos(currentAngle),-sin(currentAngle),1,sin(currentAngle),cos(currentAngle),1);
    rot.print();
    PVector x = new PVector(0,1,1);
    rot.mult(up,x);
    println(x);
    V = getCamera(x,center,currentZoom);
  }
  if(key == '[')
  {
    currentAngle = currentAngle + ANGLE_CHANGE;
    println(currentAngle);
    PVector x = new PVector(0,1,1);
    PMatrix3D rot = new PMatrix3D(cos(currentAngle),-sin(currentAngle),1,sin(currentAngle),cos(currentAngle),1);
    rot.mult(up,x);
    V = getCamera(up,center,currentZoom);
  }
  
  
}
void printState()
{
  String msg = "OrthoMode: ";
  if(orthoMode == OrthoMode.IDENTITY)
  {
      msg += "IDENTITY";
  }
  if(orthoMode == OrthoMode.CENTER640)
  {
    msg += "CENTER640";
  }
  if(orthoMode == OrthoMode.BOTTOMLEFT640)
  {
    msg += "BOTTOMLEFT640";
  }
  if(orthoMode == OrthoMode.FLIPX)
  {
    msg += "FLIPX";
  }
  if(orthoMode == OrthoMode.ASPECT)
  {
    msg += "ASPECT";
  }
  msg += "\n";
  println(msg);
}
