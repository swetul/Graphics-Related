
// Swetul Patel 

import java.util.Stack;

// used to implement your model matrix stack
Stack<PMatrix3D> matrixStack = new Stack<PMatrix3D>();

//matrices
PMatrix3D Vp;
PMatrix3D Pr;
PMatrix3D V;
PMatrix3D M;
PMatrix3D I;
float currentZoom = 1;
float currentAngle = 0;
PVector center = new PVector(0,0,1);
PVector up = new PVector(0,1,1);
float currentX = 0;
float currentY = 0;

// called once, at the start of our program
void setup() {
  size(640, 640);
  colorMode(RGB, 1.0f);
  
  Vp = getViewPort();
  Pr = getOrtho(-width/2,width/2,-height/2,height/2);
  V = getCamera(up,center,currentZoom);
  M = getIdentity();
  I = getIdentity();
  
}

PMatrix3D getViewPort()
{
  PMatrix3D scale = new PMatrix3D(width/2.0,0.0,0.0,0.0,-height/2.0,0.0);
  PMatrix3D translate = new PMatrix3D(1.0,0.0,width/2,0.0,1.0,height/2.0);
  translate.apply(scale);
  translate.print();
  return translate;
}
PMatrix3D getOrtho(float left, float right, float bottom, float top)
{
  PMatrix3D orth = new PMatrix3D((2.0/(right-left)),0.0,(-(right+left)/(right-left)),0.0,(2.0/(top-bottom)), (-(top+bottom)/(top-bottom)));
  orth.print();
 return orth;  
}
PMatrix3D getCamera(PVector up, PVector center, float zoom)
{
  PVector perp = new PVector(up.y, -up.x);
  float lenUp = sqrt((up.x*up.x)+(up.y*up.y));
  float lenperp = sqrt((perp.x*perp.x)+(perp.y*perp.y));
  PMatrix3D Basis = new PMatrix3D(up.y, up.x,0,-up.x,up.y,0);
  PMatrix3D t = new PMatrix3D(1, 0,-center.x,0,1,-center.y);
  PMatrix3D sc = new PMatrix3D(1/zoom,0,0,0,1/zoom,0);
  //t.print();
  //sc.print();
  //Basis.print();--------------------------------------------------------------=============================================
  if(lenUp == lenperp)
  {
    Basis = new PMatrix3D(up.y,-up.x,0,up.x,up.y,0);
  }
  else
  {
    Basis.invert();    
  }
  //t.apply(sc);
  //t.apply(Basis);
  //t.print();
  //return t;
  
  
  sc.apply(Basis);
  t.apply(sc);
  //Basis.print();
  return t;   
}
PMatrix3D getIdentity()
{
  return new PMatrix3D(1,0,0,0,1,0);    
}

//void changeCamera()
//{
//  println(currentZoom);
//  println(mouseX);
//  println(mouseY);
//  float localX = mouseX - 320;
//  float localY = -(mouseY-320);
//  println(localX);
//  println(localY);
//  //changing mouse from processing to local
//  PVector upBegin = new PVector(localX,localY,1);
//  PVector upEnd = new PVector(localX,(height/2)*currentZoom,1);
//  PVector up = upBegin.sub(upEnd);
  
//  PVector center = new PVector(localX,localY,1);
  
//  V = getCamera(up,center, currentZoom);
    
//}

// called roughly 60 times per second
void draw() {
  clear();

  // HELLO world, so to speak
  // draw a line from the top left to the center, in Processing coordinate system
  //  highlights what coordinate system you are currently in.
  stroke(1,1,1);
  checkPan();
  if (testMode) {
    drawTest(1000);
    drawTest(100);
    drawTest(1);
    
  } else {
    
    drawScene(0,0,0);
    
  }
}

void checkPan()
{
 
  if(mouseX != currentX || mouseY != currentY)
  {
    float localX = (mouseX - width/2)*currentZoom;
    float localY = -(mouseY-height/2)*currentZoom;
    //changing mouse from processing to local
    PVector center1 = new PVector(localX,localY,1);
    PVector up1 = new PVector(0,0.75/currentZoom,1);
    V = getCamera(up1,center1, currentZoom);
  }
}


void checkOrtho()
{
  if(orthoMode == OrthoMode.IDENTITY)
  {
      Pr = I.get();
  }
  if(orthoMode == OrthoMode.CENTER640)
  {
    Pr = getOrtho(-width/2,width/2,-height/2,height/2);
  }
  if(orthoMode == OrthoMode.BOTTOMLEFT640)
  {
    Pr = getOrtho(0,width,0,height);
  }
  if(orthoMode == OrthoMode.FLIPX)
  {
    Pr = getOrtho(width/2,-width/2,-height/2,height/2);
  }
  if(orthoMode == OrthoMode.ASPECT)
  {
    Pr = getOrtho(-320,320,-100,100);
  }
}

void drawScene(float thetaLow, float thetaHigh, float thetaArms)
{
  myPush(M);
  beginShape(QUADS);
  
  //make circle
  
  stroke(1,1,1);
  myVertex(-230,-230);
  myVertex(230,-230);
  myVertex(-310,-310);
  myVertex(310,-310);
  endShape();
  myTranslate(0,(-230/320));
  
  makeSphere(100,20);
  M = myPop();
  //myVertex(x, bottom);
  //myVertex(x, top);

  
}
void makeSphere(int radius, int divisions)
{
  float spaceX = TWO_PI/divisions;
  float spaceY = PI/divisions;
  float[][][] points = new float[divisions+1][divisions+1][3];
  stroke(1.0f, 1.0f, 1.0f);
  float iterX = 0.5;
  float iterY = 0.5;
  for(int i = 0; i <= divisions; i++)
  {
    for(int j = 0; j <= divisions; j++)
    {
      float X = (radius*sin(iterY)*sin(iterX));
      float Y = (radius*cos(iterY));
      float Z = (radius*sin(iterY)*cos(iterX));
      float[] temp = {X,Y,Z};
      points[i][j] = temp;

      iterY += spaceY;
    }
    iterY = 0;
    iterX += spaceX;
  }
  for(int a = 0; a < divisions; a++)
  {
    for(int b = 0; b < divisions; b++)
    {
      float[] v1; 
      float[] v2;
      float[] v3;
      fill(0.3,0.2,0.4);
      beginShape(TRIANGLES);
      v1 = points[a][b];                   //ab--a+1b--a+1b+1 CW OR ab--a+1b+1--a+1b  CCW  Correct
      v2 = points[a+1][b+1];                    
      v3 = points[a+1][b];                    //ab--a+1b+1--ab+1 CW OR ab--ab+1--a+1b+1  CCW  correct
      myVertex(v1[0],v1[1]);
      myVertex(v2[0],v2[1]);
      myVertex(v3[0],v3[1]);
      endShape();
      
      fill(0.5,0.5,0.6);
      beginShape(TRIANGLES);
      v1 = points[a][b];                      
      v2 = points[a][b+1];                    
      v3 = points[a+1][b+1];
      myVertex(v1[0],v1[1]);
      myVertex(v2[0],v2[1]);
      myVertex(v3[0],v3[1]);
      endShape();
     }
    }
}

void myPush(PMatrix3D mat)
{
   matrixStack.push(mat);
}
PMatrix3D myPop()
{
  return matrixStack.pop();
}

void myRotate(float theta)
{
  PMatrix3D temp = new PMatrix3D(cos(theta),-sin(theta),0,sin(theta),cos(theta),0);
  M.apply(temp);
}
void myScale(float s)
{
  PMatrix3D temp = new PMatrix3D(s,0,0,0,s,0);
  M.apply(temp);
}
void myTranslate(float tx, float ty)
{
  PMatrix3D temp = new PMatrix3D(1,0,tx,0,1,ty);
  M.apply(temp);
}
