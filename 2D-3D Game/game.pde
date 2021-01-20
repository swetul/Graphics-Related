//swetul patel 
//textures
//sources:
//https://www.pngitem.com/pimgs/m/222-2222200_sonic-sprite-sheet-transparent-hd-png-download.png
//https://previews.123rf.com/images/gdainti/gdainti1902/gdainti190200005/120986151-pixel-art-style-set-of-different-16x16-texture-pattern-sprites-stone-wood-brick-dirt-metal-8-bit-gam.jpg
//https://t3.ftcdn.net/jpg/02/24/51/72/360_F_224517287_XuFU5zbZXCc69P0DST102qgkcgf8xIwK.jpg

PImage[] sonicRun = new PImage[12];
PImage[] flipSonicRun = new PImage[12];
PImage[] sonicDecel = new PImage[6];
PImage[] flipSonicDecel = new PImage[6];
PImage[] floorTex = new PImage[4];
PImage[] obstacles = new PImage[3];
PImage[] jumpFr = new PImage[8];
PImage[] flipJumpFr = new PImage[8];
PImage[] flames = new PImage[5];

//Floor variables
ArrayList<Cube> floor = new ArrayList<Cube>();
ArrayList<Cube> obst = new ArrayList<Cube>();
final int numCubes = 20;
int cubeSize = 20;//(width/numCubes);
final int rows = 100; // X-axis
final int columns = 10;// -Z-axis
final int numObstacles = int(rows/4);
float baseY;
final float Friction = 0.25;
float inc = 1;
float zSpeed = 1;


// character Movement variables
float speedX = 0;
float speedZ = 0;
float xPos = 0;
float zPos = columns/2;
int runT = 0;
int decT = 0;
PImage currTex;
final float maxSpeed = 0.3;
boolean doubleJump = false;
float jump = 0;
boolean midJump = false;
float jumpframe = 0;
boolean decel = false;
boolean decelR = false;
boolean direction = true;

//obstacles
int numFlames = 25;
float[] xFlames = new float[numFlames];
float[] zFlames = new float[numFlames];
ArrayList<Cube> movObj = new ArrayList<Cube>();
boolean activeFlames = false;
int currFlame = 0;
int fC = 0;
int movObjNum = 0;

void setup() {

  //REALIZED IDEAL FRAMTE RATE TO VIEW AND PLAY 20
  frameRate(60);
  
  size(1000, 1000, P3D);
  colorMode(RGB, 1.0f);
  
  //importing all textures needed for the program
  for (int i = 0; i < sonicRun.length; i++) {
    sonicRun[i] = loadImage("sonic ("+(i+1)+").png");
    flipSonicRun[i] = loadImage("sonicF ("+(i+1)+").png");
  }
  for (int i = 0; i < sonicDecel.length; i++) {
    sonicDecel[i] = loadImage("sonicD ("+(i+1)+").png");
    flipSonicDecel[i] = loadImage("sonicDF ("+(i+1)+").png");
  }
  for (int i = 0; i < obstacles.length; i++) {
    obstacles[i] = loadImage("obs"+i+".png");
  }
  for (int i = 0; i < floorTex.length; i++) {
    floorTex[i] = loadImage("floor ("+i+").png");
  }
  for (int i = 0; i < jumpFr.length; i++) {
    jumpFr[i] = loadImage("jump ("+i+").png");
  }
  for (int i = 0; i < flipJumpFr.length; i++) {
    flipJumpFr[i] = loadImage("jumpF ("+(i+1)+").png");
  }
  for (int i = 0; i < flames.length; i++) {
    flames[i] = loadImage("flames ("+(i+1)+").png");
  }
  //---------------------------------------------------------------------------
  
  currTex = sonicRun[0];
  textureMode(NORMAL); // uses normalized 0..1 texture coords
  textureWrap(CLAMP);
  baseY = height-cubeSize;
  cubeSize = height/numCubes;
  genFloor(floor);
  genObstacles(obst);
  
}


void draw() {
  // don't use resetMatrix to start. It clears the modelView matrix, which includes your camera.
  // if you change the camera, you need to build the model again
  clear();
  background(1,0.99,0.89);
  float camX = cameraONrails();
  pushMatrix();
  
  if(orthoMode)
  {
     camera(camX,(height/2),height/1.75, camX,(height/2),0,0,1,0);
     ortho(-width/2, width/2, -height/2,height/2);
  }
  else
  { 
    camera(camX,(height/5),height/1.75, camX,(height/2),0,0,1,0);
    float fov = PI/3;
    float cameraZ = (height/10.0)/ tan(fov/2.0);
    //print(cameraZ);
    perspective(fov, 1, cameraZ/10, cameraZ*10);
  }
  pollKeys();
  doCollisions();
  drawFloor();
  drawObstacles();
  drawFlames();
  drawCharacter();
  
  popMatrix();
}
void doCollisions()
{
  if(doCollision)
  {
    float minR = xPos-1;
    float maxR = xPos+1;
    float minZ = zPos-1;
    float maxZ = zPos+1;
    
    // out of time - :(
  }
}
//Poll for keys being pressed
void pollKeys()
{
  //movement keys - accelerate in X-axis
 if(keyLeft || keyRight)
 {
   decelR = false;
   if(speedX < maxSpeed)
   {
     speedX += 0.01;
     if(runT < 11)
     {
       runT++;
     }
   }
   if(keyLeft){xPos -= speedX;direction = false;}
   if(keyRight){xPos += speedX;direction = true;}
 }
 else //decelerate
 {
   decelR = true;
   speedX *= Friction;
   if(decT < 6)
    {
       decT++;
    }
   if(speedX < 0){speedX = 0;}
 }
 //accelerate in Z-axis
 if(keyUp || keyDown)
 {
   if(speedZ < maxSpeed){speedZ += 0.01;}
   if(keyDown){zPos -= speedZ;}
   if(keyUp){zPos += speedZ;}
 }
 else // decelerate in Z
 {
   speedZ *= Friction;
   if(speedZ < 0){speedZ = 0;}
 }
 
//jump functionality-------------------------------------
 if(keyJump && !decel)
 {
   jumpframe += 1;
   if(doubleJump && !decel)
   {
      jump += 0.5;
      if(jump > 5){decel = true;} 
   }
   else
   {
     jump += 0.2;
     if(jump > 3){decel = true;} 
   }
   if(jumpframe > 7)
   {
      jumpframe = 7; 
   }
 }
 else if(decel)
 {
   jump -= (9.81/10);
   jumpframe --;
   if(jumpframe < 1)
   {
      jumpframe = 0; 
   }
   if(jump <= 0)
   {
      jump = 0;
      keyJump = false;
      doubleJump = false;
      midJump = false;
      decel = false;
   }
 }
 //-------------------------------------
}
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
//draws the character in whichever position, texture it should be in, at any given frame
void drawCharacter()
{
  float[] gen = {1,0,0};  //red color
  float posR = xPos+speedX;
  float posC = zPos+speedZ;
  if(posC > columns-1)
  {
     posC = columns-1;
     zPos = columns-1;
     speedZ = 0;
  }
  if(posC <= 0)
  {
    posC = 0;
    zPos = 0;
    speedZ = 0;
  }
  if(posR <= 0)
  {
    posR = 0;
    xPos = 0;
    speedX = 0;
  }
  if(posR > rows-1)
  {
    posR = rows-1;
    xPos = rows-1;
    speedX = 0;
  }
  
  //finding out which texture to put on based on movements
  PImage tex = currTex;
  if(!decelR)
  {
    decT = 0;
    if(runT > 11){runT = 11;}
    if(direction)
    {
      tex = sonicRun[runT];
    }
    else
    {
      tex = flipSonicRun[runT];
    }
  }
  else
  {
    runT = 0;
    if(decT > 5||decT==0){decT = 5;}
    if(direction)
    {
      tex = sonicDecel[decT];
    }
    else
    {
      tex = flipSonicDecel[decT];
    }
  }
  if(keyJump || decel)
  {
     if(direction)
     {
       tex = jumpFr[int(jumpframe)];
     }
     else
     {
       tex = flipJumpFr[int(jumpframe)];
     } 
  }
  //send to draw sub-function
  currTex = tex;
  Cube c = new Cube(posR, posC, 0.0,gen,tex);
  float yTemp = baseY-(cubeSize) - (jump*cubeSize);
  drawCube(c, yTemp,true); 
}
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
// camera on rails, moves along the X-axis and follows the player
float cameraONrails()
{
  float camX = ((xPos*cubeSize));
  if(camX + (width/2) > (rows*cubeSize))
  {
    camX = (rows*cubeSize)-(width/2);  
  }
  else if((camX) < (width/2))
  {
    camX = width/2; 
  }
  return camX;
}
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
// draw the floor of the game
void drawFloor()
{
  for(Cube c : floor)
  {
    drawCube(c,baseY, false);
  }
}
//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
//draws flame obstacles on the floor to avoid by player (difficulty level for player- HIGH)
void drawFlames()
{
  if(!activeFlames)
  {
    for(int i = 0; i < numFlames; i++)
    {
      int tR = int(random(3,rows-2));
      int tZ = int(random(1,columns));
      
      xFlames[i] = tR;
      zFlames[i] = tZ;
    }
    activeFlames = true;
  }
  else
  {
    for(int i = 0; i < numFlames; i++)
    {
      float X = (xFlames[i])*cubeSize;
      float Z = -((zFlames[i])*cubeSize);
      float Y = baseY-cubeSize;
      float H = cubeSize;
      beginShape();
      //midfront
      texture(flames[currFlame]);
       vertex(X,Y,Z-(.5*cubeSize),0,1);
       vertex(X,Y-H,Z-(.5*cubeSize),0,0);
       vertex(X+cubeSize,Y-H,Z-(.5*cubeSize),1,0);
       vertex(X+cubeSize,Y,Z-(.5*cubeSize),1,1);
       //midright
       texture(flames[currFlame]);
       vertex(X+(.5*cubeSize),Y-H,Z,0,1);
       vertex(X+(.5*cubeSize),Y,Z,0,0);
       vertex(X+(.5*cubeSize),Y,Z-cubeSize,1,0);
       vertex(X+(.5*cubeSize),Y-H,Z-cubeSize,1,1);
       //bottom
       //texture(floorTex[3]);
       //vertex(X,Y,Z,0,1);
       //vertex(X,Y,Z-cubeSize,0,0);
       //vertex(X+cubeSize,Y,Z-cubeSize,1,0);
       //vertex(X+cubeSize,Y,Z,1,1);
       endShape();
    }
    currFlame++;
    fC++;
    if(currFlame > 4)
    {
       currFlame = 0;
    }
    if(fC > 120)
    {
      fC = 0;
      activeFlames = false;
    }
  }
}
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
//draw stationary and non-stationary obstacles
void drawObstacles()
{
  for(Cube c : obst)
  {
    drawCube(c,baseY-cubeSize, false);
  }
  for(int i = 0; i < movObj.size(); i++)
  {
    pushMatrix();
     translate(0,0,zSpeed);
     rotate(PI/16);
     scale(inc,inc,inc);
     drawCube(movObj.get(i), baseY-cubeSize, false);
    popMatrix();
  }
  zSpeed += 0.25;
  inc+= 0.25;
}

//----------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
//Draw function that draws all the building blocks of the game
void drawCube(Cube c, float base, boolean val)
{
  
  float X = (c.location.row) * cubeSize;
  float Y = base;
  float Z = -(c.location.col)* cubeSize;
  float H = cubeSize;
  if(c.tall > 0)
  {
    H = (c.tall +1 )*cubeSize;  
  }
  fill(c.shade[0],c.shade[1],c.shade[2]);
  if(val)// if drawing a character
  {
     noStroke();
     beginShape(QUADS);
     if(doTextures)
     {
       texture(c.txt);
     }
      //front
     vertex(X,Y,Z-(.5*cubeSize),0,1);
     vertex(X,Y-H,Z-(.5*cubeSize),0,0);
     vertex(X+cubeSize,Y-H,Z-(.5*cubeSize),1,0);
     vertex(X+cubeSize,Y,Z-(.5*cubeSize),1,1);
     endShape();
  }
  else //for all other objetcs
  { 
   beginShape(QUADS);
   if(doTextures)
   {
     texture(c.txt);
   }
    //front
   vertex(X,Y,Z,0,1);
   vertex(X,Y-H,Z,0,0);
   vertex(X+cubeSize,Y-H,Z,1,0);
   vertex(X+cubeSize,Y,Z,1,1);
   //rightside
   if(doTextures)
   {
     texture(c.txt);
   }
   vertex(X+cubeSize,Y-H,Z,0,1);
   vertex(X+cubeSize,Y,Z,0,0);
   vertex(X+cubeSize,Y,Z-cubeSize,1,0);
   vertex(X+cubeSize,Y-H,Z-cubeSize,1,1);
   //back
   //vertex(X+cubeSize,Y,Z-cubeSize);
   //vertex(X+cubeSize,Y-H,Z-cubeSize);
   //vertex(X,Y-H,Z-cubeSize);
   //vertex(X,Y,Z-cubeSize);
   //leftside
   if(doTextures)
   {
     texture(c.txt);
   }
   vertex(X,Y-H,Z-cubeSize,0,1);
   vertex(X,Y,Z-cubeSize,0,0);
   vertex(X,Y,Z,1,0);
   vertex(X,Y-H,Z,1,1);
   //top
   if(doTextures)
   {
     texture(c.txt);
   }
   vertex(X,Y-H,Z,0,1);
   vertex(X,Y-H,Z-cubeSize,0,0);
   vertex(X+cubeSize,Y-H,Z-cubeSize,1,0);
   vertex(X+cubeSize,Y-H,Z,1,1);
   
   endShape();
  }
  
  
}
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
//Generates the floor tiles to be drawn later on to avoid dynamic draw every frame
void genFloor(ArrayList<Cube> arena)
{
   for(int i = 0; i < rows; i++)
   {
     for(int j = 0; j < columns; j++)
     {
       float[] rc = {random(0,1),random(0,1),random(0,1)};
        arena.add(new Cube(i,j,0,rc,floorTex[int(random(0,4))]));
     }
   }
}
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------
//Generates a list of obstacles to be drawn later on.
void genObstacles(ArrayList<Cube> arena)
{
   for(int i = 0; i < rows; i++)
   {
     if(i > 0 && i < rows-1)
     {
         boolean obstacle = false;
       for(int j = 0; j < columns; j++)
       {
         float prob = random(0,50);
         float[] rc = {random(0,1),random(0,1),random(0,1)};
         if(!obstacle && (prob > 20 && prob < 22))
         {
           
            float c = random(1,4);
            arena.add(new Cube(i,j,c,rc,obstacles[int(random(0,3))]));
            if(movObjNum < 5)
            {
              movObjNum++;
              movObj.add(new Cube(int(random(3,95)),int(random(1,10)),0, rc,obstacles[int(random(0,3))]));
            }
            
            obstacle = true;
         }
       }
     } 
   }
}

//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------
//Class used to store row and column position of each cube
class Pos
{
   float row;
   float col;
   Pos(float r, float c)
   {
     row = r;
     col = c;
   }
}
//----------------------------------------------------------------------------------------------------------
//Building block of the sketch, used in all applications in the program
class Cube
{
  Pos location;
  float tall;
  float[] shade;
  PImage txt;
  Cube(float r, float c, float t, float[] sh,PImage tx)
  {
    location = new Pos(r,c);
    tall = t;
    shade = sh;
    txt = tx;
  }
}
//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
//END-------------------------------------------------
